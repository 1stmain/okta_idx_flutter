//
//  Utils.swift
//  okta_oidc_flutter
//
//  Created by Sai Gokula Krishnan on 26/07/22.
//

import OktaIdx

class OktaProcessors{
    var credsStorage: Credential?
    
    //MARK: Process Remediation
    func processRemediation(response: Result<Response,InteractionCodeFlowError>,  callback: @escaping (([String:String]?,Error?) -> Void), needResult: Bool = true, getToken: Bool = false)-> Response?{
        var result: Response? = nil;
        switch response {
        case .success(let successResponse):
            result = successResponse
            break
            
        case .failure(let errorResponse):
            callback(nil, errorResponse)
            break
        }
        return result
    }
    
    //MARK: Get Token
    func exchangeTokenFromResponse(response: Response,  callback: @escaping (([String:String]?,Error?) -> Void)){
        guard response.isLoginSuccessful
        else {
             let response : Bool = response.remediations[.challengeAuthenticator] != nil
            if response {
                callback(nil, NSError(domain: "Okta Password iOS", code: 0, userInfo: [NSLocalizedDescriptionKey: "Wrong Password"]))
            }
            return
        }
        response.exchangeCode { tokenResult in
            switch tokenResult{
            case .success(let tokenResponse):
                let tokens = tokenResponse
                callback([
                    "accessToken": tokens.accessToken
                ],nil)
            case .failure(let error):
                callback(nil, error)
            }
        }
    }
}
