//
//  ComicApi.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/22.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import Moya
import HandyJSON
import MBProgressHUD

let LoadingPlugin = NetworkActivityPlugin { (type, target) in
    guard let vc = topVC else { return }
    switch type {
    case .began:
        MBProgressHUD.hide(for: vc.view, animated: false)
        MBProgressHUD.showAdded(to: vc.view, animated: true)
    case .ended:
        MBProgressHUD.hide(for: vc.view, animated: true)
    }
}

let timeoutClosure = {(endpoint: Endpoint<ComicApi>, closure: MoyaProvider<ComicApi>.RequestResultClosure) -> Void in
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 20
        closure(.success(urlRequest))
    } else {
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}

let ApiProvider = MoyaProvider<ComicApi>(requestClosure: timeoutClosure)
let ApiLoadingProvider = MoyaProvider<ComicApi>(requestClosure: timeoutClosure, plugins: [LoadingPlugin])

enum ComicApi {
    case searchHot //搜索热门
    case searchRelative(inputText: String)//相关搜索
    case searchResult(argCon: Int, q: String)//搜索结果
    case cateList //分类列表
    case comicList(argCon: Int, argName: String, argValue: Int, page: Int)//漫画列表
    case rankList//排行列表
    case vipList//VIP列表
    case subscribeList//订阅列表
    case boutiqueList(sexType: Int)//推荐列表
    case detailStatic(comicid: Int)//详情(基本)
    case detailRealtime(comicid: Int)//详情(实时)
    case guessLike//猜你喜欢
    case commentList(object_id: Int, thread_id: Int, page: Int)//评论
    case chapter(chapter_id: Int)//章节内容
}


extension ComicApi: TargetType {
    private struct ComicApiKey {
        static var key = "fabe6953ce6a1b8738bd2cabebf893a472d2b6274ef7ef6f6a5dc7171e5cafb14933ae65c70bceb97e0e9d47af6324d50394ba70c1bb462e0ed18b88b26095a82be87bc9eddf8e548a2a3859274b25bd0ecfce13e81f8317cfafa822d8ee486fe2c43e7acd93e9f19fdae5c628266dc4762060f6026c5ca83e865844fc6beea59822ed4a70f5288c25edb1367700ebf5c78a27f5cce53036f1dac4a776588cd890cd54f9e5a7adcaeec340c7a69cd986:::open"
    }
    
    var baseURL: URL {
        return URL(string: "http://app.u17.com/v3/appV3_3/ios/phone")!
    }
    
    var path: String {
        switch self {
        case .searchHot: return "search/hotkeywordsnew"
        case .searchRelative: return "search/relative"
        case .searchResult: return "search/searchResult"
        case .cateList:  return "sort/mobileCateList"
        case .comicList: return "list/commonComicList"
        case .rankList:  return "rank/list"
        case .vipList: return "list/vipList"
        case .subscribeList: return "list/newSubscribeList"
        case .boutiqueList: return "comic/boutiqueListNew"
        case .detailStatic: return "comic/detail_static_new"
        case .detailRealtime: return "comic/detail_realtime"
        case .guessLike: return "comic/guessLike"
        case .commentList: return "comment/list"
        case .chapter: return "comic/chapterNew"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var parmeters = ["time": Int32(Date().timeIntervalSince1970),
                         "device_id": UIDevice.current.identifierForVendor!.uuidString,
                         "key": ComicApiKey.key,
                         "model": UIDevice.current.modelName,
                         "target": "U17_3.0",
                         "version": Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
                      ]
        
        switch self {
        case .cateList:
             parmeters["v"] = 2
            
        case .comicList(let argCon, let argName, let argValue, let page):
            parmeters["argCon"] = argCon
            if argName.count > 0 {
                parmeters["argName"] = argName
            }
            parmeters["argValue"] = argValue
            parmeters["page"] = max(1, page)
            
        case .boutiqueList(let sexType):
            parmeters["sexType"] = sexType
            parmeters["v"] = 3320101
            
        case .detailStatic(let comicid),
             .detailRealtime(let comicid):
            parmeters["comicid"] = comicid
            parmeters["v"] = 3320101
            
        case .commentList(let object_id, let thread_id, let page):
            parmeters["object_id"] = object_id
            parmeters["thread_id"] = thread_id
            parmeters["page"] = page
            
        case .searchRelative(let inputText):
            parmeters["inputText"] = inputText
        
        case .searchResult(let argCon, let q):
            parmeters["argCon"] = argCon
            parmeters["q"] = q
            
        case .chapter(let chapter_id):
            parmeters["chapter_id"] = chapter_id
            
        default: break
        }
        
        print(parmeters)
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default);
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}


extension Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) throws -> T {
        let jsonString = String.init(data: data, encoding: .utf8)
        guard let model = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
            throw MoyaError.jsonMapping(self)
        }
        return model
    }
}


extension MoyaProvider {
    @discardableResult
    open func request<T: HandyJSON>(_ target: Target,
                                    model: T.Type,
                                    completion: ((_ returnData: T?) -> Void)?) -> Cancellable? {
        
        return request(target, completion: { (result) in
            guard let completion = completion,
                let returnData = try? result.value?.mapModel(ResponseData<T>.self) else {
                    return
            }
            print(returnData!)
            completion(returnData?.data?.returnData)
        })
    }
}





