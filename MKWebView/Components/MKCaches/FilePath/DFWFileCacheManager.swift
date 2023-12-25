//
//  DFWFileManager.swift
//  AFNetworking
//
//  Created by sunshine on 2022/9/21.
//

import UIKit
import CommonCrypto

open
class DFWFileCacheManager: NSObject {
    /// 单例
    public static let share = DFWFileCacheManager()
    /// 文件夹路径
    private lazy var directoryPath: String = {
        let path = createDirectory("DFWFileManager")
        return path ?? getDocumentsPath()
    }()
    
    private override init() {
        super.init()
    }
   
    /// 写入文件
    /// - Returns: 是否写入成功
    public func writeFile(_ data: String, forKey key: String) {
        let fileName = getFile(key)
        do {
            try data.write(toFile: fileName, atomically: true, encoding: .utf8)
        } catch  {
            print("文件写入失败")
        }
       
    }

    /// 读取文件内容
    public func getObjectString(forKey key: String) -> String {
        let fileName = getFile(key)
        guard let text: NSString = try? NSString(contentsOfFile: fileName, encoding: NSUTF8StringEncoding)  else {
            return ""
        }
        return text as String
    }
    
 
    /// 删除文件
    public func removeFile(forKey key: String) {
        let fileName = getFile(key)
        do {
            try FileManager.default.removeItem(atPath: fileName)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    /// 删除所有文件
    public func removeAllFile() {
        do {
            try FileManager.default.removeItem(atPath: directoryPath)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
}

extension DFWFileCacheManager {
    /// 获取Documents路径
    private func getDocumentsPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let path = paths.first {
            return path
        } else {
            debugPrint("获取沙盒路径失败")
            return ""
        }
    }

    /// 根据传入的文件夹名创建文件夹📂
    private func createDirectory(_ directoryName: String) -> String? {
        /// 获取路径
        let path = DFWFileCacheManager.share.getDocumentsPath()
        /// 创建文件管理者
        let fileManger = FileManager.default
        /// 创建文件夹
        let directoryPath = path + ("/\(directoryName)")
       
        if !fileManger.fileExists(atPath: directoryPath) { /// 先判断是否存在  不存在再创建
            do {
                try fileManger.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
                return directoryPath
            } catch let error {
                debugPrint("文件夹创建失败:\(error.localizedDescription)")
                return nil
            }
        }

        return directoryPath

    }
    
    /// 根据传入的文件名创建文件
    private func getFile(_ fileName: String) -> String {
        /// 创建文件管理者
        let fileManger = FileManager.default
        /// 创建文件
        let key = fileName.FilePathMD5
        let filePath = DFWFileCacheManager.share.directoryPath + ("/\(key)")
        if !fileManger.fileExists(atPath: filePath) { /// 先判断是否存在  不存在再创建
            let isSuccess = fileManger.createFile(atPath: filePath, contents: nil, attributes: nil)
            assert(isSuccess, "文件创建失败")
        }
        debugPrint("文件路径:\(filePath)")
        return filePath
    }
    
}

extension String {
    /// MD5加密
    var FilePathMD5: String {
        let str = cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)

        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }

        result.deallocate()

        return hash as String
    }

}
