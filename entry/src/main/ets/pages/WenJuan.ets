import web_webview from '@ohos.web.webview'
import radio from '@ohos.telephony.radio'
import router from '@ohos.router';
class Item{
name:string
  xx1:string
  xx2:string
  xx3:string
  xx4:string
  dn:number
  constructor(name:string,xx1:string,xx2:string,xx3:string,xx4:string,dn:number) {
    this.name=name
    this.xx1=xx1
    this.xx2=xx2
    this.xx3=xx3
    this.xx4=xx4
    this.dn=dn

  }

}




@Entry
@Component
struct WenJuan {
  controller: web_webview.WebviewController = new web_webview.WebviewController()
@State a:number=0
  @State b:number=0
  private items: Array <Item> = [
    new Item('1.下列哪组均属于可回收物','A.灰土、毛巾','B.纸杯、瓷器','C.玻璃杯、旧衣服','D.废弃日光灯管、塑料袋',2),
    new Item('2.垃圾可以分成几类?','A.两类','B.三类','C.四类','D.五类',3),new Item('3.包了口香糖的纸巾属于哪一类垃圾?','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',1),
  new Item('4.保鲜膜属于哪类垃圾?','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',1),
  new Item('5.变质的香肠属于哪一类垃圾?','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',4),
  new Item('6.槟榔渣属于哪类垃圾?','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',4),
  new Item('7.剥掉的蛋壳属于哪一类垃圾?','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',4),
  new Item('8.菜刀属于哪类垃圾?','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',3),
  new Item('9.茶叶渣应扔进哪个垃圾桶?','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',4),
  new Item('10.吃剩的饼干渣是什么垃圾?','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',4),
  new Item('11.抽完烟的烟蒂是什么垃圾?','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',1),
  new Item('12.刀片属于哪类垃圾?','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',3),
  new Item('13.掉在地上的树叶是什么垃圾?','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',4),
  new Item('14.废电池乱丢对人体可能造成?','A.镉中毒','B.氰中毒','C.碳中毒','D.氟中毒',1),
  new Item('15.废旧的荧光灯管应扔进哪个垃圾桶?','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',2),
  new Item('16.废旧的鼠标应扔进哪个垃圾桶?','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',3),
  new Item('17.废旧塑料瓶可以通过复杂的工艺制成纤维，进而制成衣服。并不是所有的废旧塑料都可以满足工艺条件。下列材质塑料瓶中哪个才能制成服装?','A.PC塑料瓶','B.PET塑料瓶','C.PVC塑料瓶','D.PE塑料瓶',2),
  new Item('18 .废弃的食用油属于？','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',4),
  new Item('19.废弃的钥匙属于哪类垃圾？','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',3),
  new Item('20.甘蔗渣是什么垃圾？','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',4),
  new Item('21.过期的化妆品是什么垃圾？','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',2),
  new Item('22.过期的猫粮属于哪一类垃圾？','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',4),
  new Item('23.包装药片的铝箔属于哪类垃圾？','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',2),
  new Item('24.过期药品属于____, 需要特殊安全处理？','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',2),
  new Item('25.花生壳属于哪一类垃圾？','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',4),
  new Item('26.坏掉的电脑属于哪类垃圾？','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',3),
  new Item('27.灰色塑料袋属于哪类垃圾？','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',1),
  new Item('28.回形针属于哪一类垃圾？','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',1),
  new Item('29.鸡毛属于哪类垃圾？','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',1),
  new Item('30.家庭盆栽废弃的树叶是什么垃圾？','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',4),
  new Item('31.碱性电池属于__垃圾？','A.其他垃圾','B.有害垃圾','C.可回收物','D.厨余垃圾',3)
  ]


  build() {

      Column() {
         List({ space: 20, initialIndex: 0 }) {
                ForEach(this.items, (item: Item) => {

                  ListItem() {
                   Column(){
                    Text(item.name)
                    Row(){
                      Radio({ value: 'Radio1', group:item.name}).checked(false)
                        .height(20)
                        .width(20)
                        .onChange((isChecked: boolean) => {
                          console.log('Radio1 status is ' + isChecked)
                          if (isChecked == true) {
                            this.a=1
                          }

                        })
                      Text(item.xx1)


                    }
                    .width('100%')
                     .justifyContent(FlexAlign.Start)
                     Row(){
                       Radio({ value: 'Radio2', group: item.name }).checked(false)
                         .height(20)
                         .width(20)
                         .onChange((isChecked: boolean) => {
                           console.log('Radio1 status is ' + isChecked)
                           if (isChecked == true) {
                             this.a=2
                           }


                         })
                       Text(item.xx2)


                     }
                     .width('100%')
                     .justifyContent(FlexAlign.Start)
                     Row(){
                       Radio({ value: 'Radio3', group: item.name }).checked(false)
                         .height(20)
                         .width(20)
                         .onChange((isChecked: boolean) => {
                           console.log('Radio1 status is ' + isChecked)
                           if (isChecked == true) {
                             this.a=3
                           }

                         })
                       Text(item.xx3)


                     }.width('100%') .justifyContent(FlexAlign.Start)
                     Row(){
                       Radio({ value: 'Radio4', group: item.name }).checked(false)
                         .height(20)
                         .width(20)
                         .onChange((isChecked: boolean) => {
                           console.log('Radio1 status is ' + isChecked)
                           if (isChecked == true) {
                             this.a=4
                           }

                         })
                       Text(item.xx4)

                     }.width('100%') .justifyContent(FlexAlign.Start)

                           }
                  }

                })
              }

              .listDirection(Axis.Vertical) // 排列方向
              .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 20, endMargin: 20 }) // 每行之间的分界线
              .edgeEffect(EdgeEffect.Spring) // 滑动到边缘无效果
              .onScrollIndex((firstIndex: number, lastIndex: number) => {
                console.info('first' + firstIndex)
                console.info('last' + lastIndex)
              })
              .width('90%')

        Button("提交")
          .onClick(()=>{
router.back()

          })

      }
      .width('100%')
      .height('100%')

      .linearGradient({colors: [
        ['#67B1EF',0],['#FFFFFF',1]
      ]})

  }
}