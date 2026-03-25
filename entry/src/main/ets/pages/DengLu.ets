import router from '@ohos.router';

@Entry
@Component
struct DengLu {
  @State username: string = '';
  @State password: string = '';

  private optionMain: router.RouterOptions = {
    url: 'pages/Zhu'
  }; // 登录后跳转主界面

  private optionRegister: router.RouterOptions = {
    url: 'pages/ZhuCe'
  }; // 跳转注册页面

  // 登录验证
  handleLogin(): void {
    if (!this.username || !this.password) {
      console.error('用户名或密码不能为空');
      return;
    }

    // 从本地存储获取已注册的用户信息
    let storedUsername = AppStorage.get<string>('registered_username');
    let storedPassword = AppStorage.get<string>('registered_password');

    if (this.username === storedUsername && this.password === storedPassword) {
      console.info('登��成功');
      router.replaceUrl(this.optionMain);
    } else {
      console.error('用户名或密码错误');
      // 这里可以添加提示信息
    }
  }

  build() {
    Column({
      space: 11
    }) {
      Image($r("app.media.DengLuJieMian"))
        .width(80)
        .height(80)
        .borderRadius(50)
        .margin({ top: "120vp" });

      Text("欢迎登录垃圾分类查询app~")
        .fontColor(Color.Gray)
        .fontSize(14)
        .margin({ top: "25vp" });

      TextInput({ placeholder: '请输入用户名' })
        .margin({ bottom: "10vp" })
        .onChange((value: string) => {
          this.username = value;
        });

      TextInput({ placeholder: '请输入密码' })
        .type(InputType.Password)
        .onChange((value: string) => {
          this.password = value;
        });

      Button("登录")
        .width("86%")
        .type(ButtonType.Capsule)
        .margin({ top: "20vp" })
        .onClick(() => {
          this.handleLogin();
        });

      Text("注册账号")
        .fontColor(Color.Blue)
        .fontSize(14)
        .margin({ top: "10vp" })
        .onClick(() => {
          router.pushUrl(this.optionRegister);
        });

      LoadingProgress()
        .width(50)
        .height(50)
        .color(Color.Blue)
        .margin({ top: "20vp" });

      Blank();

      Row() {
        Line()
          .width("33%")
          .height(0.5)
          .backgroundColor(Color.Gray);

        Text("其他登录方式")
          .fontColor(Color.Gray)
          .fontSize(14)
          .margin({
            left: 12,
            right: 12
          });

        Line()
          .width("33%")
          .height(0.5)
          .backgroundColor(Color.Gray);
      }

      Row() {
        Button() {
          Image($r("app.media.more"))
            .width(40)
            .height(40);
        }
        .backgroundColor(Color.Transparent);
      }
      .width("80%")
      .justifyContent(FlexAlign.Center);
    }
    .backgroundImage($r("app.media.BeiJing"))
    .backgroundImageSize({
      height: '100%',
      width: '100%'
    })
    .padding({
      left: '8vp',
      right: '8vp',
      bottom: '10vp'
    })
    .width("100%")
    .height("100%");
  }
}