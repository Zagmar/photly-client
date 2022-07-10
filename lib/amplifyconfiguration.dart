const amplifyconfig = ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "ap-northeast-2_VX4UB4Vr3",
                        "AppClientId": "4gmrm0cgmc7mo367jfhplm6f1c",
                        "Region": "ap-northeast-2"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [],
                        "usernameAttributes": [
                            "EMAIL"
                        ],
                        "signupAttributes": [
                            "EMAIL"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": [
                                "REQUIRES_LOWERCASE",
                                "REQUIRES_NUMBERS"
                            ]
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [],
                        "verificationMechanisms": [
                            "EMAIL"
                        ]
                    }
                }
            }
        }
    },
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "apitest": {
                    "endpointType": "REST",
                    "endpoint": "https://22cdq9hrjb.execute-api.ap-northeast-2.amazonaws.com/dev",
                    "region": "ap-northeast-2",
                    "authorizationType": "AWS_IAM"
                }
            }
        }
    }
}''';