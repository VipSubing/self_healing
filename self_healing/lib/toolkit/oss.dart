import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:self_healing/toolkit/log.dart';
import 'package:tencentcloud_cos_sdk_plugin/cos.dart';
import 'package:tencentcloud_cos_sdk_plugin/cos_transfer_manger.dart';
import 'package:tencentcloud_cos_sdk_plugin/pigeon.dart';
import 'package:tencentcloud_cos_sdk_plugin/transfer_task.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

typedef OssJsonsResult = Tuple2<List<Map<String, dynamic>>, bool>;

class Oss {
  static Oss? _shared;
  static Oss get shared {
    _shared ??= Oss._internal();
    return _shared!;
  }

  Oss._internal() {}
  int index = 0;
  bool registed = false;
  String bucket = "self-healing-1309961435";
  String region = "ap-chengdu";
  String? jsonNextMarker;

  Future<OssJsonsResult> getJsons(bool first) async {
    await regist();
    // prevPageBucketContents 是上一页的返回结果，这里的 nextMarker 表示下一页的起始位置
    String? prevPageMarker = jsonNextMarker;
    String prefix = "jsons/";
    BucketContents bucketContents =
        await Cos().getDefaultService().getBucket(bucket,
            prefix: prefix, // 前缀匹配，用来规定返回的对象前缀地址
            marker: first ? null : prevPageMarker, // 起始位置
            maxKeys: 20 // 单次返回最大的条目数量，默认1000
            );
    // 表示数据被截断，需要拉取下一页数据
    var isTruncated = bucketContents.isTruncated;
    // nextMarker 表示下一页的起始位置
    jsonNextMarker = bucketContents.nextMarker;

    var list = bucketContents.contentsList
        .where((item) => (item?.size ?? 0) > 0)
        .map((item) {
      var url = "https://$bucket.cos.$region.myqcloud.com/${item?.key ?? ""}";
      return download(url);
    });
    List<Map<String, dynamic>> jsons = List<Map<String, dynamic>>.from(
        (await Future.wait(list)).where((item) => item != null).toList());

    return OssJsonsResult(jsons, isTruncated);
  }

  Future<Map<String, dynamic>?> download(String url) async {
    Map<String, dynamic>? map;
    try {
      Dio dio = Dio();
      var response = await dio.get(url);
      map = Map<String, dynamic>.from(response.data);
    } catch (e) {
      log_("download failture url :$url");
    }
    return map;
  }

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
    await regist();
    // 获取 TransferManager
    CosTransferManger transferManager = Cos().getDefaultTransferManger();
    //CosTransferManger transferManager = Cos().getTransferManger("newRegion");
    // 存储桶名称，由 bucketname-appid 组成，appid 必须填入，可以在 COS 控制台查看存储桶名称。 https://console.cloud.tencent.com/cos5/bucket
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

  Future regist() async {
    if (registed) {
      return;
    }
    registed = true;
    Dio dio = Dio();

    ///发起get请求
    Response<String> response = await dio.get(
        "https://self-healing-1309961435.cos.ap-chengdu.myqcloud.com/valid_user");
    var text = response.data ?? "error";

    if (text == "error") {
      throw Error();
    }
    var key = encrypt.Key.fromBase64("POpFkIjqiz9S6gWuqwrcEw==");

    final iv = IV.fromBase64("dTAnolx8QoxyNVpUXJi3hA==");
    final encrypter = Encrypter(AES(key));

    final new_encrypted = Encrypted.fromBase64(text);
    final decrypted = encrypter.decrypt(new_encrypted, iv: iv);

    String cosId = decrypted.split("*").first; //永久密钥 secretId
    String cosKey = decrypted.split("*").last; //永久密钥 secretKey
    await Cos().initWithPlainSecret(cosId, cosKey);

// 存储桶所在地域简称，例如广州地区是 ap-guangzhou

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
    await Cos().registerDefaultService(serviceConfig);
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
