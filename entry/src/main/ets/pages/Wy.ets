import http from '@ohos.net.http';
import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
import image from '@ohos.multimedia.image';
import promptAction from '@ohos.promptAction';

// 定义表格的结果项类型
interface GarbageRecognitionResult {
  name: string;
  category: string;
  description: string;
}

// 保留已有接口定义
interface MessageContent {
  text?: string;
  image?: string;
}

interface RequestMessage {
  role: string;
  content: MessageContent[];
}

interface ApiRequestParams {
  max_tokens: number;
}

interface ApiRequestInput {
  messages: RequestMessage[];
}

interface ApiRequestBody {
  model: string;
  input: ApiRequestInput;
  parameters: ApiRequestParams;
}

interface ResponseMessage {
  content: MessageContent[] | string;
}

interface Choice {
  message: ResponseMessage;
}

interface ApiResponseOutput {
  choices?: Choice[];
}

interface ApiResponse {
  output?: ApiResponseOutput;
}

@Entry
@Component
struct Wy {
  @State imageUri: string = '';
  @State recognitionResult: GarbageRecognitionResult[] = [];
  @State isLoading: boolean = false;
  @State base64Image: string = '';
  @State errorMessage: string = '';

  private apiKey: string = 'sk-7c737070d93446c4907e2953eb388995';
  private apiUrl: string = 'https://dashscope.aliyuncs.com/api/v1/services/aigc/multimodal-generation/generation';

  build() {
    Column() {
      Text('垃圾图像识别')
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 });

      // 未选择图片的提示区域
      if (this.imageUri === '') {
        Column() {
          Image($r('app.media.icon'))
            .width(100)
            .height(100)
            .opacity(0.3);
          Text('请选择图片')
            .fontSize(16)
            .fontColor('#999999')
            .margin({ top: 10 });
        }
        .width('80%')
        .height(300)
        .backgroundColor('#F5F5F5')
        .borderRadius(10)
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 20 });
      } else {
        Image(this.imageUri)
          .width('80%')
          .height(300)
          .objectFit(ImageFit.Contain)
          .borderRadius(10)
          .margin({ bottom: 20 });
      }

      // 选择图片按钮
      Button('选择图片')
        .type(ButtonType.Capsule)
        .width('80%')
        .backgroundColor('#67B1EF')
        .margin({ bottom: 15 })
        .onClick(() => {
          this.selectImage();
        });

      // 垃圾识别按钮
      Button(this.isLoading ? '识别中...' : '开始识别')
        .type(ButtonType.Capsule)
        .width('80%')
        .backgroundColor(this.imageUri && !this.isLoading ? '#4CAF50' : '#CCCCCC')
        .enabled(!!this.imageUri && !this.isLoading)
        .margin({ bottom: 20 })
        .onClick(() => {
          this.recognizeGarbage();
        });

      // 错误信息显示
      if (this.errorMessage) {
        Text(this.errorMessage)
          .fontSize(14)
          .fontColor(Color.Red)
          .margin({ bottom: 10 })
          .padding(10)
          .width('80%')
          .backgroundColor('#FFE5E5')
          .borderRadius(5);
      }

      // 表格标题和内容
      if (this.recognitionResult.length > 0) {
        // 表头
        Row() {
          Text('垃圾名称')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .width('33%')
            .textAlign(TextAlign.Center);

          Text('分类')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .width('33%')
            .textAlign(TextAlign.Center);

          Text('说明')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .width('34%')
            .textAlign(TextAlign.Center);
        }
        .backgroundColor('#CCCCCC')
        .padding({ top: 8, bottom: 8 })
        .width('90%');

        // 数据行显示结果
        ForEach(this.recognitionResult, (result: GarbageRecognitionResult) => {
          Row() {
            Text(result.name)
              .fontSize(14)
              .width('33%')
              .textAlign(TextAlign.Center);

            Text(result.category)
              .fontSize(14)
              .width('33%')
              .textAlign(TextAlign.Center)
              .fontColor('#4CAF50');

            Text(result.description)
              .fontSize(12)
              .width('34%')
              .textAlign(TextAlign.Center)
              .maxLines(2);
          }
          .padding({ top: 10, bottom: 10 })
          .backgroundColor('#FFFFFF')
          .border({
            width: 1,
            color: '#E0E0E0'
          })
          .width('90%');
        });
      }
    }
    .width('100%')
    .height('100%')
    .padding({ left: 20, right: 20 })
    .linearGradient({
      colors: [
        ['#67B1EF', 0],
        ['#FFFFFF', 1]
      ]
    });
  }

  // 选择图片方法
  async selectImage(): Promise<void> {
    try {
      let photoSelectOptions = new picker.PhotoSelectOptions();
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 1;

      let photoPicker = new picker.PhotoViewPicker();
      let result = await photoPicker.select(photoSelectOptions);

      if (result && result.photoUris && result.photoUris.length > 0) {
        this.imageUri = result.photoUris[0];
        this.recognitionResult = [];
        this.errorMessage = '';
        console.info('选择的图片URI: ' + this.imageUri);

        promptAction.showToast({ message: '图片加载中...', duration: 1000 });

        // 将图片转换为Base64
        await this.convertImageToBase64(this.imageUri);

        promptAction.showToast({ message: '图片加载完成', duration: 1000 });
      }
    } catch (err) {
      let error = err as Error;
      console.error('选择图片失败: ' + JSON.stringify(error));
      this.errorMessage = '选择图片失败: ' + error.message;
      promptAction.showToast({ message: '选择图片失败', duration: 2000 });
    }
  }

  // 将图片转换为Base64（压缩优化版本）
  async convertImageToBase64(uri: string): Promise<void> {
    try {
      // 打开文件
      let file = fs.openSync(uri, fs.OpenMode.READ_ONLY);
      let stat = fs.statSync(file.fd);
      let buffer = new ArrayBuffer(stat.size);
      fs.readSync(file.fd, buffer);
      fs.closeSync(file.fd);

      console.info('原始文件大小: ' + stat.size + ' bytes');

      // 创建ImageSource
      let imageSource = image.createImageSource(buffer);

      // 设置解码参数，压缩图片尺寸
      let decodingOptions: image.DecodingOptions = {
        desiredSize: { width: 800, height: 800 }, // 限制最大尺寸
        desiredPixelFormat: 3 // RGBA_8888
      };

      let pixelMap = await imageSource.createPixelMap(decodingOptions);

      // 获取图片信息
      let imageInfo = await pixelMap.getImageInfo();
      console.info('压缩后图片尺寸: ' + imageInfo.size.width + 'x' + imageInfo.size.height);

      // 将PixelMap转换为JPEG格式的ArrayBuffer（降低质量）
      let packOpts: image.PackingOption = {
        format: 'image/jpeg',
        quality: 60  // 降低质量以减小文件大小
      };
      let imagePacker = image.createImagePacker();
      let data = await imagePacker.packing(pixelMap, packOpts);

      console.info('压缩后文件大小: ' + data.byteLength + ' bytes');

      // 转换为Base64
      this.base64Image = this.arrayBufferToBase64(data);
      console.info('Base64转换完成，长度: ' + this.base64Image.length);

    } catch (err) {
      let error = err as Error;
      console.error('图片转换失败: ' + JSON.stringify(error));
      this.errorMessage = '图片处理失败: ' + error.message;
      throw error;
    }
  }

  // ArrayBuffer转Base64
  arrayBufferToBase64(buffer: ArrayBuffer): string {
    let binary = '';
    let bytes = new Uint8Array(buffer);
    let len = bytes.byteLength;
    for (let i = 0; i < len; i++) {
      binary += String.fromCharCode(bytes[i]);
    }
    return this.btoa(binary);
  }

  // 自定义Base64编码
  btoa(input: string): string {
    const keyStr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
    let output = '';
    let chr1: number;
    let chr2: number;
    let chr3: number;
    let enc1: number;
    let enc2: number;
    let enc3: number;
    let enc4: number;
    let i = 0;

    while (i < input.length) {
      chr1 = input.charCodeAt(i++);
      chr2 = i < input.length ? input.charCodeAt(i++) : Number.NaN;
      chr3 = i < input.length ? input.charCodeAt(i++) : Number.NaN;

      enc1 = chr1 >> 2;
      enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
      enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
      enc4 = chr3 & 63;

      if (isNaN(chr2)) {
        enc3 = enc4 = 64;
      } else if (isNaN(chr3)) {
        enc4 = 64;
      }

      output += keyStr.charAt(enc1) + keyStr.charAt(enc2) + keyStr.charAt(enc3) + keyStr.charAt(enc4);
    }

    return output;
  }

  // 识别垃圾分类的方法
  async recognizeGarbage(): Promise<void> {
    if (!this.base64Image) {
      this.errorMessage = '请先选择图片';
      promptAction.showToast({ message: '请先选择图片', duration: 2000 });
      return;
    }

    this.isLoading = true;
    this.recognitionResult = [];
    this.errorMessage = '';

    try {
      console.info('开始识别垃圾...');
      let httpRequest = http.createHttp();

      let systemContent: MessageContent = {
        text: '你是一个专业的垃圾分类助手。请识别图片中的物品，并判断它属于哪一类垃圾（可回收物、有害垃圾、湿垃圾/厨余垃圾、干垃圾/其他垃圾）。请用简洁的语言回答，每个物品一行，格式为：物品名称 - 垃圾类型 - 简短说明。'
      };

      let userImageContent: MessageContent = {
        image: `data:image/jpeg;base64,${this.base64Image}`
      };

      let userTextContent: MessageContent = {
        text: '请识别这张图片中的垃圾，并告诉我它们分别属于哪一类垃圾。'
      };

      let requestBody: ApiRequestBody = {
        model: 'qwen-vl-max',
        input: {
          messages: [
            {
              role: 'system',
              content: [systemContent]
            },
            {
              role: 'user',
              content: [userImageContent, userTextContent]
            }
          ]
        },
        parameters: {
          max_tokens: 1000
        }
      };

      console.info('发送API请求...');

      let response = await httpRequest.request(this.apiUrl, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${this.apiKey}`
        },
        extraData: JSON.stringify(requestBody),
        expectDataType: http.HttpDataType.STRING,
        connectTimeout: 60000,
        readTimeout: 60000
      });

      console.info('响应状态码: ' + response.responseCode);
      console.info('响应内容: ' + JSON.stringify(response.result).substring(0, 500));

      if (response.responseCode === 200) {
        let apiResponse: ApiResponse = JSON.parse(response.result as string);

        if (apiResponse.output?.choices?.length && apiResponse.output.choices[0]?.message?.content) {
          let content = apiResponse.output.choices[0].message.content;

          console.info('API返回内容类型: ' + typeof content);
          console.info('API返回内容: ' + JSON.stringify(content));

          let textContent = '';

          if (typeof content === 'string') {
            textContent = content;
          } else if (Array.isArray(content)) {
            textContent = content.map((item: MessageContent) => item.text || '').join('\n');
          }

          console.info('解析后的文本: ' + textContent);

          if (textContent) {
            let rows = textContent.split('\n').filter((row: string) => row.trim() !== '');

            this.recognitionResult = rows.map((row: string) => {
              let parts = row.split(' - ');
              let name = parts[0] ? parts[0].trim() : '未知物品';
              let category = parts[1] ? parts[1].trim() : '未分类';
              let description = parts[2] ? parts[2].trim() : '无描述';

              return {
                name: name,
                category: category,
                description: description
              } as GarbageRecognitionResult;
            });

            console.info('识别结果数量: ' + this.recognitionResult.length);
            promptAction.showToast({ message: '识别成功！', duration: 2000 });
          } else {
            this.errorMessage = '识别结果为空';
            promptAction.showToast({ message: '识别结果为空', duration: 2000 });
          }
        } else {
          this.errorMessage = 'API返回结果格式错误';
          console.error('API返回结果格式错误');
          promptAction.showToast({ message: 'API返回结果格式错误', duration: 2000 });
        }
      } else {
        this.errorMessage = `识别失败：HTTP ${response.responseCode}`;
        console.error('识别服务错误，状态码: ' + response.responseCode);
        console.error('错误详情: ' + response.result);
        promptAction.showToast({ message: '识别失败，请重试', duration: 2000 });
      }

      httpRequest.destroy();
    } catch (error) {
      let err = error as Error;
      this.errorMessage = '识别失败: ' + err.message;
      console.error('调用服务失败: ' + JSON.stringify(error));
      promptAction.showToast({ message: '网络错误，请重试', duration: 2000 });
    } finally {
      this.isLoading = false;
    }
  }
}