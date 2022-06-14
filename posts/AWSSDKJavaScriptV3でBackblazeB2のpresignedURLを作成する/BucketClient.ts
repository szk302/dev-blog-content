import { S3Client, S3ClientConfig, PutObjectCommand } from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";

export default class BucketClient {
  private s3ClientConfig: S3ClientConfig;

  constructor(
    private accessKey: string,
    private secretAccessKey: string,
    private endpoint: string
  ) {
    this.s3ClientConfig = {
      endpoint: { hostname: this.endpoint, protocol: "https", path: "/" },
      // 未指定の場合PreSignedUrlにホスト名が含まれない
      forcePathStyle: true,
      // 未指定の場合エラーになるため指定
      region: "ap-northeast-1",
      credentials: {
        accessKeyId: this.accessKey,
        secretAccessKey: this.secretAccessKey,
      },
    };
  }

  public async getPreSignedUrl(
    bucket: string,
    key: string,
    expiresIn: number = 3600
  ) {
    const bucketParams = {
      Bucket: bucket,
      Key: key,
    };
    const s3Client: S3Client = new S3Client(this.s3ClientConfig);
    const command = new PutObjectCommand(bucketParams);
    return getSignedUrl(s3Client, command, {
      expiresIn: expiresIn,
    });
  }
}
