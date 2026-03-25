import router from '@ohos.router';

@Entry
@Component
struct ZhuCe {
  @State username: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State registerResult: string = '';

  // 注册验证
  handleRegister(): void {
    // 清空之前的提示
    this.registerResult = '';

    // 验证输入
    if (!this.username || !this.password || !this.confirmPassword) {
      this.registerResult = '所有字段都不能为空';
      return;
    }

    if (this.username.length < 3) {
      this.registerResult = '用户名至少3个字符';
      return;
    }

    if (this.password.length < 6) {
      this.registerResult = '密码至少6个字符';
      return;
    }

    if (this.password !== this.confirmPassword) {
      this.registerResult = '两次密码输入不一致';
      return;
    }

    // 保存到本地存储（实际应用中应该加密并保存到服务器）
    AppStorage.setOrCreate('registered_username', this.username);
    AppStorage.setOrCreate('registered_password', this.password);

    console.info('注册成功: ' + this.username);
    this.registerResult = '注册成功！即将返回登录页面...';

    // 延迟跳转回登录页面
    setTimeout(() => {
      router.back();
    }, 1500);
  }

  build() {
    Column({
      space: 15
    }) {
      Text("注册新账号")
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: "80vp", bottom: "30vp" });

      TextInput({ placeholder: '请输入用户名（至少3个字符）' })
        .onChange((value: string) => {
          this.username = value;
        });

      TextInput({ placeholder: '请输入密码（至少6个字符）' })
        .type(InputType.Password)
        .onChange((value: string) => {
          this.password = value;
        });

      TextInput({ placeholder: '请再次输入密码' })
        .type(InputType.Password)
        .onChange((value: string) => {
          this.confirmPassword = value;
        });

      // 显示注册结果提示
      if (this.registerResult) {
        Text(this.registerResult)
          .fontSize(14)
          .fontColor(this.registerResult.includes('成功') ? Color.Green : Color.Red)
          .margin({ top: 10 });
      }

      Button("注册")
        .width("86%")
        .type(ButtonType.Capsule)
        .backgroundColor('#4CAF50')
        .margin({ top: "20vp" })
        .onClick(() => {
          this.handleRegister();
        });

      Button("返回登录")
        .width("86%")
        .type(ButtonType.Capsule)
        .backgroundColor('#67B1EF')
        .margin({ top: "10vp" })
        .onClick(() => {
          router.back();
        });

      Blank();
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