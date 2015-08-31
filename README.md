DDCycleScrollView

简单易用的无限循环滚动

已实现以下功能

使用三个UIImageView实现的循环滚动
自动轮播，可做广告轮播
本demo中数据返回类型为String类型，但是可以根据自己的业务需要更改为其他的数据类型
如果需要其他自定的UIView，可以把DDCycleScrollView.swift文件中的三个UIImageView更改为需要的自定义UIView
本人第一次在gitHub上上传代码，希望大家多多鼓励
使用方法

遵守代理
class ViewController: UIViewController,DDCycleScrollViewDelegate
创建
var cycleScrollView = DDCycleScrollView(frame: CGRectMake((view.frame.width - 250)/2, 64, 250, 300))
      cycleScrollView.backgroundColor = UIColor.blueColor()
      cycleScrollView.delegate = self
      view.addSubview(cycleScrollView)
实现代理方法

func numberOfPages() -> Int {
      return imageArray.count;
  }
  func currentPageViewIndex(index: Int) -> String {
      return imageArray[index]
  }
  func didSelectCurrentPage(index: Int) {
      println("\(index)")
  }
qq 464595115

邮箱 13522064180@163.com
如果有什么问题，希望大家指出，欢迎一起讨论学习
