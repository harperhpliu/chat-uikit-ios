//
//  UserListView.swift
//  TUIRoomKit
//
//  Created by 唐佳宁 on 2023/1/4.
//  Copyright © 2023 Tencent. All rights reserved.
//

import Foundation

class UserListView: UIView {
    let viewModel: UserListViewModel
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0.9
        view.isHidden = true
        return view
    }()
    
    let dropView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(0x17181F)
        return view
    }()
    
    let dropImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "room_lineImage",in:tuiRoomKitBundle(),compatibleWith: nil)
        return view
    }()
    
    let attendeeCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(0xD5E0F2)
        label.font = UIFont(name: "PingFangSC-Regular", size: 16)
        return label
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = .searchMemberText
        searchBar.setBackgroundImage(UIColor(0x17181F).trans2Image(), for: .top, barMetrics: .default)
        return searchBar
    }()
    
    let inviteButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "room_invite_useInButton", in: tuiRoomKitBundle(), compatibleWith: nil)
        button.setImage(image, for: .normal)
        button.setTitle(.inviteText, for: .normal)
        button.setTitleColor(UIColor(0x4791FF), for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        button.backgroundColor = UIColor(0x17181F)
        button.layer.borderColor = UIColor(0x4791FF).cgColor
        button.layer.borderWidth = 1.scale375()
        button.layer.cornerRadius = 6
        return button
    }()
    
    let muteAllAudioButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle(.allMuteAudioText, for: .normal)
        button.setTitleColor(UIColor(0xB2BBD1), for: .normal)
        button.setTitle(.allUnMuteAudioText, for: .selected)
        button.setTitleColor(UIColor(0xF2504B), for: .selected)
        button.backgroundColor = UIColor(0x4F586B)
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.adjustsImageWhenHighlighted = false
        return button
    }()
    
    let muteAllVideoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle(.allMuteVideoText, for: .normal)
        button.setTitleColor(UIColor(0xB2BBD1), for: .normal)
        button.setTitle(.allUnMuteVideoText, for: .selected)
        button.setTitleColor(UIColor(0xF2504B), for: .selected)
        button.backgroundColor = UIColor(0x4F586B)
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.adjustsImageWhenHighlighted = false
        return button
    }()
        
    let moreFunctionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle(.moreText, for: .normal)
        button.setTitleColor(UIColor(0xB2BBD1), for: .normal)
        button.backgroundColor = UIColor(0x4F586B)
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    lazy var userListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(0x17181F)
        tableView.register(UserListCell.self, forCellReuseIdentifier: "UserListCell")
        return tableView
    }()
    
    lazy var userListManagerView: UserListManagerView = {
        let viewModel = UserListManagerViewModel()
        let view = UserListManagerView(viewModel: viewModel)
        view.isHidden = true
        return view
    }()
    
    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var isViewReady: Bool = false
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard !isViewReady else { return }
        isViewReady = true
        backgroundColor = UIColor(0x17181F)
        constructViewHierarchy()
        activateConstraints()
        bindInteraction()
    }
    
    func constructViewHierarchy() {
        addSubview(dropView)
        addSubview(attendeeCountLabel)
        addSubview(searchBar)
        addSubview(inviteButton)
        addSubview(userListTableView)
        addSubview(muteAllAudioButton)
        addSubview(muteAllVideoButton)
        addSubview(moreFunctionButton)
        addSubview(blurView)
        addSubview(userListManagerView)
        dropView.addSubview(dropImageView)
    }
    
    func activateConstraints() {
        dropView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(30.scale375())
        }
        dropImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.scale375())
            make.centerX.equalToSuperview()
            make.height.equalTo(3.scale375())
            make.width.equalTo(24.scale375())
        }
        attendeeCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35.scale375())
            make.leading.equalToSuperview().offset(16.scale375())
            make.trailing.equalToSuperview().offset(-16.scale375())
            make.height.equalTo(24.scale375())
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(77.scale375())
            make.leading.equalToSuperview().offset(16.scale375())
            make.width.equalTo(263.scale375())
            make.height.equalTo(36.scale375())
        }
        inviteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(77.scale375())
            make.leading.equalToSuperview().offset(291.scale375())
            make.trailing.equalToSuperview().offset(-16.scale375())
            make.height.equalTo(36.scale375())
        }
        userListTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16.scale375())
            make.trailing.equalToSuperview().offset(-16.scale375())
            make.top.equalToSuperview().offset(127.scale375())
            make.bottom.equalToSuperview()
        }
        muteAllAudioButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-34.scale375())
            make.leading.equalToSuperview().offset(16.scale375())
            make.width.equalTo(108.scale375())
            make.height.equalTo(40.scale375())
        }
        muteAllVideoButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-34.scale375())
            make.leading.equalToSuperview().offset(133.scale375())
            make.width.equalTo(108.scale375())
            make.height.equalTo(40.scale375())
        }
        moreFunctionButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-34.scale375())
            make.leading.equalToSuperview().offset(250.scale375())
            make.width.equalTo(108.scale375())
            make.height.equalTo(40.scale375())
        }
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        userListManagerView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(355.scale375())
        }
    }
    
    func bindInteraction() {
        viewModel.viewResponder = self
        setupViewState()
        let dropTap = UITapGestureRecognizer(target: self, action: #selector(dropDownRoomInfoAction))
        dropView.addGestureRecognizer(dropTap)
        dropView.isUserInteractionEnabled = true
        attendeeCountLabel.text = .memberText + "（\(viewModel.attendeeList.count)）"
        searchBar.delegate = self
        inviteButton.addTarget(self, action: #selector(inviteMemberAction), for: .touchUpInside)
        muteAllAudioButton.addTarget(self, action: #selector(muteAllAudioAction), for: .touchUpInside)
        muteAllVideoButton.addTarget(self, action: #selector(muteAllVideoAction), for: .touchUpInside)
        moreFunctionButton.addTarget(self, action: #selector(moreFunctionAction), for: .touchUpInside)
        let hideBlurTap = UITapGestureRecognizer(target: self, action: #selector(hideBlurViewAction))
        blurView.addGestureRecognizer(hideBlurTap)
        blurView.isUserInteractionEnabled = true
    }
    
    @objc func dropDownRoomInfoAction(sender: UIView) {
        viewModel.dropDownAction(sender: sender)
    }
    
    func setupViewState() {
        let currentUser = viewModel.engineManager.store.currentUser
        let roomInfo = viewModel.engineManager.store.roomInfo
        let isOwner: Bool = currentUser.userId == roomInfo.ownerId
        muteAllAudioButton.isHidden = !isOwner
        muteAllAudioButton.isSelected = roomInfo.isMicrophoneDisableForAllUser
        muteAllVideoButton.isHidden = !isOwner
        muteAllVideoButton.isSelected = roomInfo.isCameraDisableForAllUser
        moreFunctionButton.isHidden = !isOwner
    }
        
    @objc func inviteMemberAction(sender: UIButton) {
        RoomRouter.shared.dismissPopupViewController(viewType: .userListViewType,animated: false)
        RoomRouter.shared.presentPopUpViewController(viewType: .inviteViewType, height: 186)
    }
    
    @objc func muteAllAudioAction(sender: UIButton) {
        viewModel.muteAllAudioAction(sender: sender, view: self)
    }
    
    @objc func muteAllVideoAction(sender: UIButton) {
        viewModel.muteAllVideoAction(sender: sender, view: self)
    }
    
    @objc func moreFunctionAction(sender: UIButton) {
        RoomRouter.shared.dismissPopupViewController(viewType: .userListViewType,animated: false)
        RoomRouter.shared.presentPopUpViewController(viewType: .inviteViewType, height: 186)
    }
    
    @objc func hideBlurViewAction(sender: UIButton) {
        viewModel.hideUserManageViewAction(view: self)
        blurView.isHidden = true
    }
    
    deinit {
        debugPrint("deinit \(self)")
    }
}

extension UserListView: UISearchBarDelegate {
    func searchBar(_ searchBar:UISearchBar,textDidChange searchText:String){
        let searchContentText = searchText.trimmingCharacters(in: .whitespaces)
        if searchContentText.count == 0 {
            viewModel.attendeeList = viewModel.engineManager.store.attendeeList
            userListTableView.reloadData()
        }else {
            let searchArray = viewModel.engineManager.store.attendeeList.filter({ model -> Bool in
                return (model.userName.contains(searchContentText))
            })
            viewModel.attendeeList = searchArray
            userListTableView.reloadData()
        }
    }
}

extension UserListView: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.attendeeList.count
    }
}

extension UserListView: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let attendeeModel = viewModel.attendeeList[indexPath.row]
        let cell = UserListCell(attendeeModel: attendeeModel, viewModel: viewModel)
        cell.selectionStyle = .none
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let attendeeModel = viewModel.attendeeList[indexPath.row]
        viewModel.showUserManageViewAction(userId: attendeeModel.userId, view: self)
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.scale375()
    }
}

extension UserListView: UserListViewResponder {
    func makeToast(text: String) {
        RoomRouter.makeToastInCenter(toast: text, duration: 0.5)
    }
    
    func updateUIWhenRoomOwnerChanged(isOwner: Bool) {
        muteAllAudioButton.isHidden = !isOwner
        muteAllVideoButton.isHidden = !isOwner
        moreFunctionButton.isHidden = !isOwner
    }
    
    func reloadUserListView() {
        userListTableView.reloadData()
        attendeeCountLabel.text = .memberText + "（\(viewModel.attendeeList.count)）"
    }
    
    func updateBlurViewDisplayStatus(isHidden: Bool) {
        blurView.isHidden = isHidden
    }
}

class UserListCell: UITableViewCell {
    var attendeeModel: UserEntity
    var viewModel: UserListViewModel
    
    let avatarImageView: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 20
        img.layer.masksToBounds = true
        return img
    }()
    
    let userLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(0xD5E0F2)
        label.backgroundColor = UIColor.clear
        label.textAlignment = isRTL ? .right : .left
        label.textAlignment = .left
        label.font = UIFont(name: "PingFangSC-Regular", size: 16)
        label.numberOfLines = 1
        return label
    }()
    
    let roleImageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    let roleLabel: UILabel = {
        let label = UILabel ()
        label.font = UIFont(name: "PingFangSC-Regular", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor(0x4791FF)
        return label
    }()
    
    let muteAudioButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "room_unMute_audio", in: tuiRoomKitBundle(), compatibleWith: nil)?.checkOverturn(), for: .normal)
        button.setImage(UIImage(named: "room_mute_audio_red", in: tuiRoomKitBundle(), compatibleWith: nil)?.checkOverturn(), for: .selected)
        return button
    }()
    
    let muteVideoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "room_unMute_video", in: tuiRoomKitBundle(), compatibleWith: nil)?.checkOverturn(), for: .normal)
        button.setImage(UIImage(named: "room_mute_video_red", in: tuiRoomKitBundle(), compatibleWith: nil)?.checkOverturn(), for: .selected)
        return button
    }()
    
    let inviteStageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = UIColor(0x0565FA)
        button.setTitle(.inviteSeatText, for: .normal)
        button.setTitleColor(UIColor(0xFFFFFF), for: .normal)
        return button
    }()
    
    let downLineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(0x4F586B,alpha: 0.3)
        return view
    }()
    
    init(attendeeModel: UserEntity ,viewModel: UserListViewModel) {
        self.attendeeModel = attendeeModel
        self.viewModel = viewModel
        super.init(style: .default, reuseIdentifier: "UserListCell")
    }
    
    private var isViewReady: Bool = false
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard !isViewReady else { return }
        isViewReady = true
        constructViewHierarchy()
        activateConstraints()
        bindInteraction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constructViewHierarchy() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(userLabel)
        contentView.addSubview(roleImageView)
        contentView.addSubview(roleLabel)
        contentView.addSubview(muteAudioButton)
        contentView.addSubview(muteVideoButton)
        contentView.addSubview(inviteStageButton)
        contentView.addSubview(downLineView)
    }
    
    func activateConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        muteVideoButton.snp.makeConstraints { make in
            make.width.height.equalTo(20.scale375())
            make.trailing.equalToSuperview()
            make.centerY.equalTo(self.avatarImageView)
        }
        muteAudioButton.snp.makeConstraints { make in
            make.width.height.equalTo(20.scale375())
            make.trailing.equalTo(self.muteVideoButton.snp.leading).offset(-20.scale375())
            make.centerY.equalTo(self.avatarImageView)
        }
        inviteStageButton.snp.makeConstraints { make in
            make.width.equalTo(62.scale375())
            make.height.equalTo(24.scale375())
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalTo(self.avatarImageView)
        }
        userLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4.scale375Height())
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12.scale375())
            make.width.equalTo(150.scale375())
            make.height.equalTo(22.scale375())
        }
        roleImageView.snp.makeConstraints { make in
            make.top.equalTo(userLabel.snp.bottom).offset(2.scale375Height())
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12.scale375())
            make.width.height.equalTo(14.scale375())
        }
        roleLabel.snp.makeConstraints { make in
            make.top.equalTo(userLabel.snp.bottom).offset(2.scale375Height())
            make.leading.equalTo(roleImageView.snp.trailing).offset(2.scale375())
            make.trailing.equalTo(81.scale375())
            make.height.equalTo(16.scale375())
        }
        downLineView.snp.makeConstraints { make in
            make.leading.equalTo(userLabel)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1.scale375())
        }
    }
    
    func bindInteraction() {
        backgroundColor = UIColor(0x17181F)
        setupViewState(item: attendeeModel)
        inviteStageButton.addTarget(self, action: #selector(inviteStageAction(sender:)), for: .touchUpInside)
    }
    
    func setupViewState(item: UserEntity) {
        let placeholder = UIImage(named: "room_default_user", in: tuiRoomKitBundle(), compatibleWith: nil)
        if let url = URL(string: item.avatarUrl) {
            avatarImageView.sd_setImage(with: url, placeholderImage: placeholder)
        } else {
            avatarImageView.image = placeholder
        }
        if item.userId == viewModel.currentUser.userId {
            userLabel.text = item.userName + "(" + .meText + ")"
        } else {
            userLabel.text = item.userName
        }
        if item.userId == viewModel.roomInfo.ownerId {
            roleImageView.image =  UIImage(named: "room_role_owner", in: tuiRoomKitBundle(), compatibleWith: nil)
            roleLabel.text = .ownerText
        } else {
            roleImageView.image =  nil
            roleLabel.text = ""
        }
        muteAudioButton.isSelected = !item.hasAudioStream
        muteVideoButton.isSelected = !item.hasVideoStream
        //判断是否显示邀请上台的按钮(房主在举手发言房间中可以邀请其他没有上台的用户)
        switch viewModel.roomInfo.speechMode {
        case .freeToSpeak:
            changeInviteStageButtonHidden(isHidden: true)
        case .applySpeakAfterTakingSeat:
            //房主可以邀请没有上麦的成员上麦
            if viewModel.currentUser.userId == viewModel.roomInfo.ownerId, attendeeModel.userId != viewModel.roomInfo.ownerId,
               !attendeeModel.isOnSeat {
                changeInviteStageButtonHidden(isHidden: false)
            } else {
                changeInviteStageButtonHidden(isHidden: true)
            }
        default: break
        }
    }
    
    @objc func inviteStageAction(sender: UIButton) {
        viewModel.userId = attendeeModel.userId
        viewModel.inviteSeatAction(sender: sender)
    }
    
    //是否显示邀请按钮（如果显示了邀请按钮，麦克风和摄像头按钮不会显示）
    private func changeInviteStageButtonHidden(isHidden: Bool) {
        inviteStageButton.isHidden = isHidden
        muteAudioButton.isHidden = !isHidden
        muteVideoButton.isHidden = !isHidden
    }
    
    deinit {
        debugPrint("deinit \(self)")
    }
}

private extension String {
    static var inviteText: String {
        localized("TUIRoom.invite")
    }
    static var allMuteAudioText: String {
        localized("TUIRoom.all.mute")
    }
    static var allMuteVideoText: String {
        localized("TUIRoom.all.mute.video")
    }
    static var allUnMuteAudioText: String {
        localized("TUIRoom.all.unmute")
    }
    static var allUnMuteVideoText: String {
        localized("TUIRoom.all.unmute.video")
    }
    static var moreText: String {
        localized("TUIRoom.more")
    }
    static var memberText: String {
        localized("TUIRoom.conference.member")
    }
    static var searchMemberText: String {
        localized("TUIRoom.search.meeting.member")
    }
    static var inviteSeatText: String {
        localized("TUIRoom.invite.seat")
    }
    static var meText: String {
        localized("TUIRoom.me")
    }
    static var ownerText: String {
        localized("TUIRoom.role.owner")
    }
    static var videoConferenceTitle: String {
        localized("TUIRoom.video.conference.title")
    }
}
