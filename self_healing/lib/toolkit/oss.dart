import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:self_healing/toolkit/log.dart';
import 'package:tencentcloud_cos_sdk_plugin/cos.dart';
import 'package:tencentcloud_cos_sdk_plugin/cos_transfer_manger.dart';
import 'package:tencentcloud_cos_sdk_plugin/pigeon.dart';
import 'package:tencentcloud_cos_sdk_plugin/transfer_task.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class Oss {
  static Oss? _shared;
  static Oss get shared {
    _shared ??= Oss._internal();
    return _shared!;
  }

  Oss._internal() {
    String SECRET_ID = "AKIDbHm4C8VovsskS6e1Cew8jbQ5g7NRajrt"; //永久密钥 secretId
    String SECRET_KEY = "vfP3byEPTN5kQzNdw894qW1LYaQ8lKnB"; //永久密钥 secretKey
    Cos().initWithPlainSecret(SECRET_ID, SECRET_KEY);
  }
  int index = 0;
  bool registed = false;

  Future<String> uploadSimple(
      {String? srcPath, Uint8List? byteArr, required OSSType type}) {
    Completer<String> completer = Completer<String>();
    upload(
        srcPath: srcPath,
        byteArr: byteArr,
        type: type,
        successCallBack: (Map<String?, String?>? header, CosXmlResult? result) {
          if (result?.accessUrl != null) {
            completer.complete(result?.accessUrl);
          } else {
            completer.completeError(Error());
          }
        },
        failCallBack:
            (CosXmlClientException? exce0, CosXmlServiceException? exce1) {
          completer.completeError(Error());
        });
    return completer.future;
  }

  Future<TransferTask> upload({
    String? srcPath,
    Uint8List? byteArr,
    required OSSType type,
    ResultSuccessCallBack? successCallBack,
    ResultFailCallBack? failCallBack,
    StateCallBack? stateCallback,
    ProgressCallBack? progressCallBack,
  }) {
    var extensionName =
        srcPath != null ? extension(srcPath) : type.extensionType();
    String cosPath =
        path.join(type.cosDirectory(), "${generateFileName()}$extensionName");
    log_("upload cosPath: $cosPath");
    return _upload(
        cosPath: cosPath,
        srcPath: srcPath,
        byteArr: byteArr,
        successCallBack: successCallBack,
        failCallBack: failCallBack,
        stateCallback: stateCallback,
        progressCallBack: progressCallBack);
  }

  Future<TransferTask> _upload({
    required String cosPath,
    Uint8List? byteArr,
    String? srcPath,
    ResultSuccessCallBack? successCallBack,
    ResultFailCallBack? failCallBack,
    StateCallBack? stateCallback,
    ProgressCallBack? progressCallBack,
  }) async {
    if (!registed) {
      await regist();
      registed = true;
    }
    // 获取 TransferManager
    CosTransferManger transferManager = Cos().getDefaultTransferManger();
    //CosTransferManger transferManager = Cos().getTransferManger("newRegion");
    // 存储桶名称，由 bucketname-appid 组成，appid 必须填入，可以在 COS 控制台查看存储桶名称。 https://console.cloud.tencent.com/cos5/bucket
    String bucket = "self-healing-1309961435";
    //若存在初始化分块上传的 UploadId，则赋值对应的 uploadId 值用于续传；否则，赋值 null
    String? _uploadId;

    // 上传成功回调
    _successCallBack(Map<String?, String?>? header, CosXmlResult? result) {
      // todo 上传成功后的逻辑
      if (successCallBack != null) {
        successCallBack(header, result);
      }
    }

    //上传失败回调
    _failCallBack(clientException, serviceException) {
      // todo 上传失败后的逻辑
      if (failCallBack != null) {
        failCallBack(clientException, serviceException);
      }
    }

    //初始化分块完成回调
    initMultipleUploadCallback(String bucket, String cosKey, String uploadId) {
      //用于下次续传上传的 uploadId
      _uploadId = uploadId;
    }

    //开始上传
    TransferTask transferTask = await transferManager.upload(bucket, cosPath,
        filePath: srcPath,
        byteArr: byteArr,
        uploadId: _uploadId,
        resultListener: ResultListener(_successCallBack, _failCallBack),
        stateCallback: stateCallback,
        progressCallBack: progressCallBack,
        initMultipleUploadCallback: initMultipleUploadCallback);
    //暂停任务
    //transferTask.pause();
    //恢复任务
    transferTask.resume();
    //取消任务
    //transferTask.cancel();
    return transferTask;
  }

  regist() async {
// 存储桶所在地域简称，例如广州地区是 ap-guangzhou
    String region = "ap-chengdu";
    // 创建 CosXmlServiceConfig 对象，根据需要修改默认的配置参数
    CosXmlServiceConfig serviceConfig = CosXmlServiceConfig(
      region: region,
      isDebuggable: true,
      isHttps: true,
    );
    // 创建 TransferConfig 对象，根据需要修改默认的配置参数
    // TransferConfig 可以设置智能分块阈值 默认对大于或等于2M的文件自动进行分块上传，可以通过如下代码修改分块阈值
    TransferConfig transferConfig = TransferConfig(
      forceSimpleUpload: false,
      enableVerification: true,
      divisionForUpload: 2097152, // 设置大于等于 2M 的文件进行分块上传
      sliceSizeForUpload: 1048576, //设置默认分块大小为 1M
    );
    // 注册默认 COS TransferManger
    await Cos().registerDefaultTransferManger(serviceConfig, transferConfig);
  }

  String generateFileName() {
    var uuid = const Uuid();
    final name = "${uuid.v1()}-$index";
    index += 1;
    return name;
  }
}

enum OSSType {
  img,
  media,
  collection,
  json;

  String cosDirectory() {
    switch (this) {
      case OSSType.img:
        return "imgs";
      case OSSType.media:
        return "medias";
      case OSSType.collection:
        return "collections";
      case OSSType.json:
        return "jsons";
      default:
    }
    return "default";
  }

  String extensionType() {
    switch (this) {
      case OSSType.img:
        return ".jpg";
      case OSSType.media:
        return ".mp3";
      case OSSType.collection:
        return ".json";
      case OSSType.json:
        return ".json";
      default:
    }
    return "*";
  }
}
