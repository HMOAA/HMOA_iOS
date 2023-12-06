//
//  MyPageReactor.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/03/24.
//

import ReactorKit
import Kingfisher

class MyPageReactor: Reactor {
    
    var initialState: State
    var service: UserServiceProtocol
    
    enum Action {
        case viewDidLoad
        case didTapGoLoginButton
        case didTapCell(MyPageType)
        case didTapDeleteMember
        case didSwitchAlarm(Bool)
        case settingAlarmAuthorization(Bool)
        case settingIsUserSetting(Bool?)
    }
    
    enum Mutation {
        case setPresentVC(MyPageType?)
        case setSections([MyPageSection])
        case setMember(Member)
        case setProfileImage(UIImage?)
        case updateNickname(String)
        case updateAge(Int)
        case updateSex(Bool)
        case setIsTapGoLoginButton(Bool)
        case setIsDelete(Bool)
        case setIsPushAlarm(Bool)
        case setUserSetting(Bool?)
        case setIsOnSwitch(Bool)
    }
    
    struct State {
        var sections: [MyPageSection] = []
        var member = Member(
            age: 0,
            memberImageUrl: "",
            memberId: 0,
            nickname: "",
            provider: "",
            sex: false)
        var presentVC: MyPageType? = nil
        var profileImage: UIImage? = nil
        var isTapEditButton: Bool = false
        var isTapGoLoginButton: Bool = false
        var isDelete: Bool = false
        var isUserSetting: Bool? = nil
        var isOnSwitch: Bool? = nil
        var isPushSetting: Bool = false
    }
    
    init(service: UserServiceProtocol) {
        self.initialState = State()
        self.service = service
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let event = service.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .updateNickname(content: let nickname):
                return .just(.updateNickname(nickname))
            case .updateImage(content: let image):
                return .just(.setProfileImage(image))
            case .updateUserAge(content: let age):
                return .just(.updateAge(age))
            case .updateUserSex(content: let sex):
                return .just(.updateSex(sex))
            }
        }

        return Observable.merge(mutation, event)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .viewDidLoad:
            return MyPageReactor.reqeustUserInfo()
            
        case .didTapCell(let type):
            return .concat([
                .just(.setPresentVC(type)),
                .just(.setPresentVC(nil))
            ])
            
        case .didTapGoLoginButton:
            return .concat([
                .just(.setIsTapGoLoginButton(true)),
                .just(.setIsTapGoLoginButton(false))
            ])
            
        case .didTapDeleteMember:
            return deleteMember()
            
        case .didSwitchAlarm(let isOn):
            return .just(.setIsOnSwitch(isOn))
            
        case .settingAlarmAuthorization(let authorization):
            return .just(.setIsPushAlarm(authorization))
            
        case .settingIsUserSetting(let setting):
            return .just(.setUserSetting(setting))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPresentVC(let VC):
            state.presentVC = VC
            
        case .setSections(let sections):
            state.sections = sections
            
        case .setMember(let memeber):
            state.member = memeber
            
        case .setProfileImage(let image):
            state.profileImage = image
            
            state.sections = [
                MyPageSection.memberSection(
                    MyPageSectionItem.memberCell(state.member, image))
            ] + [MyPageSection.pushAlarmSection(.pushAlaramCell("서비스 알림"))] + MyPageReactor.setUpOtherSection()
            
        case .updateNickname(let nickname):
            
            state.member.nickname = nickname
            
            state.sections = [
                MyPageSection.memberSection(
                    MyPageSectionItem.memberCell(state.member, state.profileImage))
            ] + [MyPageSection.pushAlarmSection(.pushAlaramCell("서비스 알림"))] + MyPageReactor.setUpOtherSection()
            
        case .updateAge(let age):
            state.member.age = age
            
        case .updateSex(let sex):
            state.member.sex = sex
            
        case .setIsTapGoLoginButton(let isTap):
            state.isTapGoLoginButton = isTap
            
        case .setIsDelete(let isDelete):
            state.isDelete = isDelete
            
        case .setIsPushAlarm(let isPush):
            state.isPushSetting = !isPush
            if let isAlarm = state.isUserSetting {
                state.isOnSwitch = isAlarm && isPush
            } else { state.isOnSwitch = isPush }
            
        case .setUserSetting(let setting):
            state.isUserSetting = setting
            state.isOnSwitch = setting
            UserDefaults.standard.set(setting, forKey: "alarm")
            
        case .setIsOnSwitch(let isOn):
            state.isOnSwitch = isOn
        }
        return state
    }
}

extension MyPageReactor {
    
    static func setUpOtherSection() -> [MyPageSection] {
        let second = [
            MyPageType.myLog.title,
            MyPageType.myInformation.title
            ]   .map { MyPageSectionItem.otherCell($0) }

        let thrid = [
            MyPageType.terms.title,
            MyPageType.policy.title,
            MyPageType.version.title
            ]   .map { MyPageSectionItem.otherCell($0)}
        
        let fourth = [
            MyPageType.inquireAccount.title,
            MyPageType.logout.title,
            MyPageType.deleteAccount.title
            ]   .map { MyPageSectionItem.otherCell($0)}
        
        
        return [MyPageSection.otherSection(second), MyPageSection.otherSection(thrid), MyPageSection.otherSection(fourth)]
    }
    
    static func reqeustUserInfo() -> Observable<Mutation> {
        
        return MemberAPI.getMember()
            .catch { _ in .empty() }
            .flatMap { member -> Observable<Mutation> in

                var sections = [MyPageSection]()
                
                guard var member = member else { return .empty() }

                member.provider.changeProvider()
                
                sections.append(MyPageSection.memberSection(
                    MyPageSectionItem.memberCell(member, nil)))
                sections.append(MyPageSection.pushAlarmSection(.pushAlaramCell("서비스 알림")))
                sections += setUpOtherSection()
                
                return .concat([
                    .just(.setMember(member)),
                    .just(.setSections(sections)),
                    downloadImage(url: member.memberImageUrl)
                ])
            }
    }
    
    func deleteMember() -> Observable<Mutation> {
        return MemberAPI.deleteMember()
            .catch { _ in .empty() }
            .flatMap { data -> Observable<Mutation> in
                return .concat([
                    .just(.setIsDelete(true)),
                    .just(.setIsDelete(false))
                ])
            }
    }
    
    func reactorForMyProfile() -> ChangeProfileImageReactor {
        return ChangeProfileImageReactor(service: service, currentImage: currentState.profileImage)
    }
    
    func reactorForMyInformation() -> MyProfileReactor {
        return MyProfileReactor(service: service, member: currentState.member)
    }
    
    static func downloadImage(url: String) -> Observable<Mutation> {
        return Observable.create { observer in
            guard let imageURL = URL(string: url) else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let resource = KF.ImageResource(downloadURL: imageURL)
            
            KingfisherManager.shared.retrieveImage(with: resource) { result in
                switch result {
                case .success(let value):
                    let image = value.image
                    observer.onNext(.setProfileImage(image))
                    observer.onCompleted()
                case .failure(let error):
                    print("Error downloading image: \(error)")
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }

}
