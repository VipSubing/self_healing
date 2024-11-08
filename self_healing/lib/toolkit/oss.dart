import 'package:tencentcloud_cos_sdk_plugin/cos.dart';
import 'package:tencentcloud_cos_sdk_plugin/cos_transfer_manger.dart';
import 'package:tencentcloud_cos_sdk_plugin/pigeon.dart';
import 'package:tencentcloud_cos_sdk_plugin/transfer_task.dart';

class Oss {
  static Oss? _shared;
  static Oss get shared {
    _shared ??= Oss._internal();
    return _shared!;
  }

  Oss._internal() {
    String SECRET_ID = "SECRETID"; //永久密钥 secretId
    String SECRET_KEY = "SECRETKEY"; //永久密钥 secretKey
    Cos().initWithPlainSecret(SECRET_ID, SECRET_KEY);
  }

  upload() async {
    // 存储桶所在地域简称，例如广州地区是 ap-guangzhou
    String region = "COS_REGION";
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

    // 获取 TransferManager
    CosTransferManger transferManager = Cos().getDefaultTransferManger();
    //CosTransferManger transferManager = Cos().getTransferManger("newRegion");
    // 存储桶名称，由 bucketname-appid 组成，appid 必须填入，可以在 COS 控制台查看存储桶名称。 https://console.cloud.tencent.com/cos5/bucket
    String bucket = "examplebucket-1250000000";
    String cosPath = "exampleobject"; //对象在存储桶中的位置标识符，即称对象键
    String srcPath = "本地文件的绝对路径"; //本地文件的绝对路径
    //若存在初始化分块上传的 UploadId，则赋值对应的 uploadId 值用于续传；否则，赋值 null
    String? _uploadId;

    // 上传成功回调
    successCallBack(Map<String?, String?>? header, CosXmlResult? result) {
      // todo 上传成功后的逻辑
    }
    //上传失败回调
    failCallBack(clientException, serviceException) {
      // todo 上传失败后的逻辑
      if (clientException != null) {
        print(clientException);
      }
      if (serviceException != null) {
        print(serviceException);
      }
    }

    //上传状态回调, 可以查看任务过程
    stateCallback(state) {
      // todo notify transfer state
    }
    //上传进度回调
    progressCallBack(complete, target) {
      // todo Do something to update progress...
    }
    //初始化分块完成回调
    initMultipleUploadCallback(String bucket, String cosKey, String uploadId) {
      //用于下次续传上传的 uploadId
      _uploadId = uploadId;
    }

    //开始上传
    TransferTask transferTask = await transferManager.upload(bucket, cosPath,
        filePath: srcPath,
        uploadId: _uploadId,
        resultListener: ResultListener(successCallBack, failCallBack),
        stateCallback: stateCallback,
        progressCallBack: progressCallBack,
        initMultipleUploadCallback: initMultipleUploadCallback);
    //暂停任务
    //transferTask.pause();
    //恢复任务
    //transferTask.resume();
    //取消任务
    //transferTask.cancel();
  }
}
