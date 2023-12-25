//
//  DFWQRScanViewController.swift
//  DongFuWang
//
//  Created by qianduan2731 on 2021/7/30.
//

import UIKit
import AudioToolbox
import AVFoundation
typealias ScanResultBlock = (_ resultUrl:String) ->Void
class DFWQRScanViewController: DFWBaseRootViewController,AVCaptureMetadataOutputObjectsDelegate {
    @objc private var scanResultBlock : ScanResultBlock?
    /// 防抖
    @objc private var isCanCallBack: Bool = true
    @objc private var timer:Timer?
    @objc private var upOrDown = false
    @objc private var num : Int = 0
    ///相册图片
    @objc private var photoLibraryImage:UIImage?
    @objc private var bHadAutoVideoZoom = false
    /*@objc*/ private var centerPoint : CGPoint?
    deinit {
        print("DFWQRScanViewController销毁了")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DFW_ColorFromHexColor(hexColor: "#000000")
        self.setNavigationHidden(nagationHidden: true)
    
        //
        DFWAuthorizeManager.isAcesssedCamera { [weak self](authorized, requested) in
            if authorized {
                self?.start()
            }else {
                self?.noAuthorized()
            }
        }
        
        // Do any additional setup after loading the view.
    }
    @objc dynamic private func start() {
        self.addSubviews()
        self.timer = Timer.scheduledTimer(timeInterval: 0.008, target: self , selector: #selector(startAnimation), userInfo: nil, repeats: true)
        // 2.开始扫描
        self.startScan()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        session.startRunning()
        self.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //停止扫描
//        session.stopRunning()
        self.stopRunning()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer?.fireDate = Date.distantFuture
    }
    
    //MARK:返回
    @objc dynamic func backBtnclick(sender: UIButton) {
        self.videoPreView.frame = CGRect(x: 0, y: 0, width: ApplicationWidth, height: ApplicationHeight)
        if let viewControllers = self.navigationController?.viewControllers {
            if viewControllers.count > 1 {
                //push进来的
                self.navigationController?.popViewController(animated: true)
            }else{
                //present进来的
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK: private setup
    @objc dynamic private func noAuthorized() {
        let authorizeAlert = UIAlertController.init(title: "camera.not.permissions",
                                                    message: "camera.set.permissions",
                                                     preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "button.cancel",
                                              style: .default) { (action) in
            if self.navigationController?.presentingViewController != nil {
                self.navigationController?.dismiss(animated: true, completion: {
                    
                })
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        let settingAction = UIAlertAction.init(title: "button.location_setting",
                                               style: .default) { (action) in
            DFWAuthorizeManager.actionToOpenSettings()
            self.noAuthorized()
        }
        authorizeAlert.addAction(cancelAction)
        authorizeAlert.addAction(settingAction)
        authorizeAlert.show(self, sender: nil)
        self.present(authorizeAlert, animated: true, completion: nil)
    }
    //MARK:开灯
    @objc dynamic func QRCodeLightBtnClick(sender: UIButton) {
        
        let isLightOpened = self.isLightOpened()
        self.openLight(open: !isLightOpened)
    }
    
    //MARK:图片
    @objc dynamic func QRCodePhotosBtnClick(sender: UIButton) {
     
        self.openPhotoLibrary()
    }
    
    /**
     执行动画
     */
    @objc dynamic func startAnimation()
    {
        if upOrDown == false {
            self.num += 1
            self.lineImgView.frame = CGRect(x: 19, y: self.scanImgView.frame.origin.y+CGFloat(num), width: self.scanImgView.frame.size.width-4, height: 2.0)
            if num == Int(self.scanImgView.frame.size.height-10) {
                upOrDown = true;
            }
        }
        else{
            self.num -= 1
            self.lineImgView.frame = CGRect(x: 19, y: self.scanImgView.frame.origin.y+5+CGFloat(num), width: self.scanImgView.frame.size.width-4, height: 2.0)
            if (num == 0) {
                upOrDown = false;
            }
        }
    }

    
    // MARK: - 懒加载
    // 会话
    @objc lazy var session : AVCaptureSession = AVCaptureSession()
    
    // 拿到输入设备
    @objc private lazy var deviceInput: AVCaptureDeviceInput? = {
        // 获取摄像头
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            // 创建输入对象
            if let device = device {
                let input = try AVCaptureDeviceInput(device: device)
                return input
            } else {
                return nil
            }
        }catch
        {
            return nil
        }
    }()
    // 拿到输出对象
    @objc private lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    // 创建预览图层
    @objc private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = UIScreen.main.bounds
        layer.videoGravity = .resizeAspectFill
        return layer
    }()
    @objc lazy var photoOutput = AVCapturePhotoOutput.init()
    @objc lazy var videoPreView: UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: ApplicationWidth, height: ApplicationHeight))
        view.backgroundColor = .clear
        return view
    }()
    
    // 创建用于绘制边线的图层
    @objc private lazy var drawLayer: CALayer = {
        let layer = CALayer()
        layer.frame = UIScreen.main.bounds
        return layer
    }()
    
    
    /*
     返回按钮
     */
    @objc lazy var backButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "dfw_return_white"), for: .normal)
        button.addTarget(self, action: #selector(backBtnclick), for: .touchUpInside)
        return button
    }()
    /*
     手电筒按钮
     */
    @objc lazy var lightButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "dfw_scan_light"), for: .normal)
        button.addTarget(self, action: #selector(QRCodeLightBtnClick), for: .touchUpInside)
        return button
    }()
    /*
     相册按钮
     */
    @objc lazy var phontsButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "dfw_scan_picture"), for: .normal)
        button.addTarget(self, action: #selector(QRCodePhotosBtnClick), for: .touchUpInside)
        return button
    }()
    /*
     扫描视图
     */
    @objc lazy var scanView: UIView = {
        let view = UIView.init()
        return view
    }()
    /**
     扫描线
     */
    @objc lazy var lineImgView: UIImageView = {
        let imageView = UIImageView.init(image:UIImage.init(named: "dfw_scan_line"))
        return imageView
    }()
    /**
     扫描框
     */
    @objc lazy var scanImgView: UIImageView = {
        let imageView = UIImageView.init(image:UIImage.init(named: "dfw_scan_small"))
        return imageView
    }()
    /**
     提示文案
     */
    @objc lazy var tipsLabel: UILabel = {
        let label = UILabel.init()
        label.text = "message.scan.tips"
        label.textAlignment = .center
        label.textColor = DFW_ColorFromHexColor(hexColor: "#FFFFFF")
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    
    // 启动
    @objc dynamic func startRunning() {
        DispatchQueue(label: "startRunning").async { [weak self] in
            self?.session.startRunning()
        }
    }
   
    // 停止
    @objc dynamic func stopRunning() {
        DispatchQueue(label: "stopRunning").async { [weak self] in
            self?.session.stopRunning()
        }
    }
}

extension DFWQRScanViewController{
    @objc dynamic private func addSubviews() {
        self.view.addSubview(backButton)
        self.view.addSubview(lightButton)
        self.view.addSubview(phontsButton)
        self.view.addSubview(scanView)
        self.view.addSubview(tipsLabel)
        self.scanView.addSubview(scanImgView)
        self.scanView.addSubview(lineImgView)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(AppStatusBarHeight+10)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        scanView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo((ApplicationHeight-AppNavBarHeight-250)/2)
            make.width.height.equalTo(250)
        }
        tipsLabel.snp.makeConstraints { make in
            make.top.equalTo(scanView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        scanImgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.top.equalToSuperview().offset(18)
            make.bottom.equalToSuperview().offset(-18)
        }
        lineImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(0)
            make.width.equalTo(210.0)
            make.height.equalTo(2.0)
        }
        lightButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(44)
            make.top.equalTo(scanView.snp.bottom).offset(148)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        phontsButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-44)
            make.centerY.equalTo(lightButton)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
    }
}

//MARK:--打开闪光灯的方法
extension DFWQRScanViewController{
    ///判断闪光灯是否打开
    @objc dynamic private func isLightOpened()-> Bool {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if !(device?.hasTorch ?? false) {
            return false
        } else {
            if device?.torchMode == AVCaptureDevice.TorchMode.on {//闪光灯已经打开
                return true
            }else{
                return false
            }
        }
    }
    
    ///打开闪光灯的方法
    @objc dynamic private func openLight(open:Bool){
    
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if !(device?.hasTorch ?? false) {
//            LoadingAlert.show(title: "title.prompt", message: "message.scan.light.error",direction:.TextDirectionCenter, commitButton: "button.sure", backgorundHide: false) { (index) in
//            }
        } else {
            if open { //打开
                if  device?.torchMode != AVCaptureDevice.TorchMode.on {
    
                    do{
                        try device?.lockForConfiguration()
                        device?.torchMode = AVCaptureDevice.TorchMode.on
                        device?.unlockForConfiguration()
                    }catch
                    {
                        print(error)
                        
                    }
                }
            }else{//关闭闪光灯
        
                if  device?.torchMode != AVCaptureDevice.TorchMode.off{
                    do{
                        try device?.lockForConfiguration()
                        device?.torchMode = AVCaptureDevice.TorchMode.off
                        device?.unlockForConfiguration()
                        
                    }catch
                    {
                        print(error)
                        
                    }
                }
        
            }
            
        }
        
    }

    ///

}

//MARK:扫描二维码的方法和代理
extension DFWQRScanViewController {

    /**
     扫描二维码
     */
    @objc dynamic private func startScan(){
        guard let deviceInput = deviceInput else {
            return
        }
        // 1.判断是否能够将输入添加到会话中
        if !session.canAddInput(deviceInput)
        {
            return
        }
        // 2.判断是否能够将输出添加到会话中
        if !session.canAddOutput(output)
        {
            return
        }
        // 3.将输入和输出都添加到会话中
        session.addInput(deviceInput)
        session.addOutput(output)
        // 4.设置输出能够解析的数据类型
        output.metadataObjectTypes =  output.availableMetadataObjectTypes
//        print(output.availableMetadataObjectTypes)
        // 5.设置输出对象的代理, 只要解析成功就会通知代理
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // 添加预览图层
        view.layer.insertSublayer(previewLayer, at: 0)
        self.view.insertSubview(self.videoPreView, at: 0)
        self.videoPreView.layer.insertSublayer(previewLayer, at: 0)
        // 添加绘制图层到预览图层上
        previewLayer.addSublayer(drawLayer)
        if self.session.canAddOutput(self.photoOutput) {
            self.session.addOutput(self.photoOutput)
        }
        // 6.告诉session开始扫描
//        session.startRunning()
        self.startRunning()
    }
    
    // 只要解析到数据就会调用
    @objc dynamic func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        var result = ""
        for current in metadataObjects {
            if current is AVMetadataMachineReadableCodeObject {
                let scannedResult = (current as? AVMetadataMachineReadableCodeObject)?.stringValue
                if scannedResult != nil && scannedResult != "" {
                    result = scannedResult!
                }
            }
        }
        if result.count<1 {
            return
        }
        if !bHadAutoVideoZoom {
            let obj = self.previewLayer.transformedMetadataObject(for: metadataObjects.last!)
            DispatchQueue.main.async {
                self.changeVideoScale(objc: obj as! AVMetadataMachineReadableCodeObject)
            }
            bHadAutoVideoZoom = true
            return
        }
        print("-------result is", result)
//        session.stopRunning()
        self.stopRunning()
        self.handlerJump(resultString: result)
    }
    @objc dynamic func changeVideoScale(objc:AVMetadataMachineReadableCodeObject) {
        let array = objc.corners
        var point = CGPoint(x: 0, y: 0)
        let dictionary1 = array[0].dictionaryRepresentation
        point = CGPoint.init(dictionaryRepresentation: dictionary1)!
        var point2 = CGPoint(x: 0, y: 0)
        let dictionary2 = array[2].dictionaryRepresentation
        point2 = CGPoint.init(dictionaryRepresentation: dictionary2)!
        self.centerPoint = CGPoint(x: (point.x + point2.x)/2, y: (point.y + point2.y) / 2)
        let scance =  150 / (point2.x - point.x)
        self.setVideoScale(scale: scance)
        return
    }
    @objc dynamic func setVideoScale(scale: CGFloat) {
        try? self.deviceInput?.device.lockForConfiguration()
        var newScale = scale
        let videoConnection = self.connectionWithMediaType(mediaType: .video, connections: self.photoOutput.connections)
        let maxScaleAndCropFactor : CGFloat = self.photoOutput.connection(with: .video)!.videoMaxScaleAndCropFactor/16
        if newScale > maxScaleAndCropFactor {
            newScale = maxScaleAndCropFactor
        }else if scale < 1 {
            newScale = 1
        }
        let zoom = newScale / videoConnection!.videoScaleAndCropFactor
        videoConnection!.videoScaleAndCropFactor = newScale
        self.deviceInput?.device.unlockForConfiguration()
        
        let transform = self.videoPreView.transform
        if newScale == 1 {
            self.videoPreView.transform = transform.scaledBy(x: zoom, y: zoom)
            var rect = self.videoPreView.frame
            rect.origin = CGPoint.init(x: 0, y: 0)
            self.videoPreView.frame = rect
        }else{
            let x = self.videoPreView.center.x - self.centerPoint!.x
            let y = self.videoPreView.center.y - self.centerPoint!.y
            var rect = self.videoPreView.frame
            rect.origin.x = rect.size.width / 2.0 * (1 - newScale)
            rect.origin.y = rect.size.height / 2.0 * (1 - newScale)
            rect.origin.x += x * zoom
            rect.origin.y += y * zoom
            rect.size.width = rect.size.width * newScale
            rect.size.height = rect.size.height * newScale
            
            
            UIView.animate(withDuration: 0.5) {
                self.videoPreView.transform = transform.scaledBy(x: zoom, y: zoom)
//                self.videoPreView.frame = rect
            } completion: { finish in
                
            }
            

        }
        print("放大%f",zoom)
    }
    
    @objc dynamic private func connectionWithMediaType(mediaType: AVMediaType, connections: [AVCaptureConnection]) -> AVCaptureConnection? {
        for connection in connections {
            let inputPorts = connection.inputPorts
            for port in inputPorts {
                if port.mediaType == mediaType {
                    return connection
                }
            }
        }
        return nil
    }
    
    @objc dynamic private func handlerJump(resultString: String) {
        if self.scanResultBlock != nil, isCanCallBack == true {
            self.scanResultBlock!(resultString)
            isCanCallBack = false
        }
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.0) {[weak self] in
            self?.isCanCallBack = true
        }
    }
    
    /// 外部处理结果
    @objc dynamic func isNotNeedDealQRScanResult(qrString: String) {
        if self.scanResultBlock != nil, isCanCallBack == true {
            self.scanResultBlock!(qrString)
            isCanCallBack = false
        }
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.0) {[weak self] in
            self?.isCanCallBack = true
        }
    }
    
    @objc dynamic public func getResultUrl(block:@escaping ScanResultBlock) {
        self.scanResultBlock = block
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

//MARK:--访问相册和从相册解析二维码的方法
extension DFWQRScanViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    ///打开相册的方法
    @objc dynamic private func openPhotoLibrary() {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        picker.modalPresentationStyle = .fullScreen
        self.present(picker, animated: true, completion: nil)
    }

    @objc dynamic func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) { () in }
        session.stopRunning()
        
        var image = (info as NSDictionary).object(forKey: UIImagePickerController.InfoKey.editedImage) as? UIImage
        if image == nil {
            image = (info as NSDictionary).object(forKey: UIImagePickerController.InfoKey.originalImage) as? UIImage
        }
        guard let qrCodeImage: UIImage = image else {
            return
        }
        
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.5) {[weak self] in
            self?.scanQRCodeImage(image: qrCodeImage)
        }
    }
    @objc dynamic private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismiss(animated: true) { () in }
        session.stopRunning()
        
        var image = (info as NSDictionary).object(forKey: UIImagePickerController.InfoKey.editedImage) as? UIImage
        if image == nil {
            image = (info as NSDictionary).object(forKey: UIImagePickerController.InfoKey.originalImage) as? UIImage
        }
        guard let qrCodeImage: UIImage = image else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.5) {[weak self] in
            self?.scanQRCodeImage(image: qrCodeImage)
        }
        
    }

    /// 扫描图片二维码
    @objc func scanQRCodeImage(image: UIImage)  {
        DFWScanCodeImage.scanQrImage(image: image) { qrString in
            if kStringIsEmpty(str: qrString) {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                    LoadingHUD.showToastWithStatus(status: "message.scan.type.error".localized)
//                    self.scanPoint(resultStatus: "fail", resultUrl: nil)
//                }
            } else {
                // 跳转的方法
                DispatchQueue.main.async {
                    self.handlerJump(resultString: qrString ?? "")
                }
            }
        }
    }


}
extension URL{
    var urlParameters : [String:String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {return nil}
        return queryItems.reduce(into: [String:String]()) { result, item in
            result[item.name] = item.value
        }
    }
    
}
