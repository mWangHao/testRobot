*** Variables ***
${KQ_login}       /v6/register.html    # 登陆
${KQ_check_today_kaoqin_info}    /v4/querySelfTodayRecord.html    # 查询用户当天考勤记录
${KQ_kaoqin}      /v5/officework.html    # 考勤
${KQ_Token}       /get/officework/token.html    # 获取打卡token
${KQ_changepassword}    /v2/register.html    # 修改密码
${KQ_check_current_unfinished_waiqin_info}    /querymobilework.html    # 查询当前未结束外勤
${KQ_ACertainDay_kaoqin}    /v2/queryworkrecord    # 1.1.47获取某人某天考勤列表
${KQ_OneOfTheMonths_kaoqin}    /statistic/v2/query/user/month    # 1.1.46查询指定员工月统计信息
${KQ_search_sites_1}    /mobileAddress.html    # 1.1.29获取一级外勤地点
${KQ_search_sites_2}    /querymobileaddress.html    # 1.1.37外勤地点搜索
${KQ_Initiate_FieldService}    /v3/requestmobilework.html    # 1.1.35请求外勤v3
${KQ_Finish_FieldService}    /v3/finishmobilework.html    # 1.1.36结束外勤v3
${KQ_inquire_leader}    /queryleaderlist.html    # 1.1.4查询领导人列表
${KQ_LeaveType}    /leave/queryTypelist    # 1.1.26获取请假类型列表
${KQ_LeaveRequest}    /leave/apply    # 1.1.21请假申请
${KQ_Overtimeapply}    /overtime/v1/apply    # 1.1.40临时加班申请
${KQ_overtime_queryMyApplylist}    /overtime/v1/queryMyApplylist    # 1.1.44获取我的临时加班申请单
${KQ_otleaveRevoke}    /overtime/otleaveRevoke.html    #1.1.53撤销临时加班申请
${KQ_queryApprovallist}    /overtime/v1/queryApprovallist    # 1.1.41审批人获取临时加班申请待审列表
${KQ_overtime_approval}    /overtime/v1/approval    # 1.1.42临时加班申请审批（审批）
${KQ_overtime_queryApprovedlist}    /overtime/v1/queryApprovedlist    # 1.1.43获取临时加班申请已审列表
${KQ_queryMyApplyfindByOtleaveId.html}    /v1/queryMyApplyfindByOtleaveId.html    # 1.1.61查询加班详细数据
${KQ_leave_queryLeaveMessage}    /leave/queryLeaveMessage    # 1.1.27获取请假信息接口(包含模糊查询)
${KQ_querySelfTodayRecord}    /v4/querySelfTodayRecord.html    # 1.1.8查询自己的当天考勤
${KQ_suggestFeedBack}    /suggestFeedBack.html    # 1.1.11意见反馈
${KQ_usersetconfigure}    /user/set/configure.html    # 1.1.32~用户配置
${KQ_queryuserconfigure}    /user/set/getconfigure.html    # 1.1.55用户配置-获取用户配置信息
${KQ_usersetreconfigure}    /user/set/reconfigure.html    # 1.1.56用户配置-重置用户配置信息（恢复默认）
${KQ_nearKqAddress}    /nearKqAddress.html    # 获取考勤最近地址
${KQ_getUserScore}    /score/getUserScore.html    # 获取用户积分接口
${KQ_getScoreRecord}    /score/getScoreRecord.html    # 获取用户积分详情接口
${KQ_getScoreFaq}    /faq/getScoreFaq.html    # 获取积分规则接口
${KQ_workAddress}    /workAddress.html    # 查询工作地点列表
${KQ_queryworkrecord}    /statistic/v2/queryworkrecord    # 获取某人某天考勤列表
${KQ_queryleaderlist}    /queryleaderlist.html    # 查询领导人列表
${KQ_alluserMonth}    /statistic/query/alluser/month    # 查询所有员工月统计信息
${KQ_userMonth}    /statistic/query/user/month    # 查询指定员工月统计信息
${KQ_queryTimeToday}    /queryTimeToday    # 查询当天时间信息
${KQ_queryAlluserDay}    /statistic/query/alluser/day    # 查询所有员工日统计信息
${KQ_rankingAlluserMonth}    /statistic/worktime/ranking/alluser/month    # 所有员平均工时统计
${KQ_requestMobileWork}    /v3/requestmobilework.html    # ~请求外勤v3
${KQ_getMobileType_Wq}    /waiqin/wqb/getMobileType.html    # 外勤B01获取的类型 v2.4.0
${KQ_getMobileSearchList_Wq}    /waiqin/wqb/getMobileSearchList.html    # 外勤B01获取地址历史记录 v2.4.0
${KQ_doMonbileSearch}    /waiqin/wqb/doMobileSearch.html    # 外勤B01新增地址/更新地址 v2.4.0
${KQ_vacationRemove.html}    /waiqin/wqb/vacationRemove.html    # 外勤B01获取时间段天数
${KQ_getUserAndHeaderAndDepts}    /waiqin/wqb/getUserAndHeaderAndDepts.html    # 外勤B01获取部门负责人 默认人/公司领导/一级部门
${KQ_getDeptById}    /waiqin/wqb/getDeptById.html    # 外勤B01获取部门的子部门 和 该部门的负责人 v2.4.0
${KQ_getThreeMonthDate}    /waiqin/wqb/getThreeMonthDate.html    # 外勤B01获取当前月/后一个月/后2个月的日历时间 特殊工作日/休
${KQ_searchUser}    /waiqin/wqb/searchUser.html    # 外勤B01搜索人（部门负责人) v2.4.0
${KQ_getMyApplyList_Wq}    /waiqin/wqb/getMyApplyList.html    # 外勤B01 待审核/审核通过/审核拒绝/已撤回 列表v2.4.0
${KQ_Wqb_MobileRevoke}    /waiqin/wqb/mobileRevoke.html    # 外勤B01 撤回外勤 v2.4.0
${KQ_Wqb_Apply}    /waiqin/wqb/apply.html    # 外勤B01申请外勤 v2.4.0
${KQ_wqb_getMobileDetail}    /waiqin/wqb/getMobileDetail.html    # 外勤B01 外勤详细 v2.4.0
${KQ_wqb_getJPushMobileDetail}    /waiqin/wqb/getJPushMobileDetail.html    # 外勤B01 推送外勤详细 v2.4.0
${KQ_wqb_queryHandlelist}    /waiqin/wqb/queryHandlelist.html    # 外勤B01 已审核/待审核外勤 v2.4.0
${KQ_mobileAddress}    /mobileAddress.html    # 获取一级外勤地点
${KQ_subMobileAddress}    /subMobileAddress    # 获取二级外勤地点
${KQ_querymobileaddress}    /querymobileaddress.html    # 外勤地点搜索
${KQ_WqA01_requestmobilework}    /v3/requestmobilework.html    # ~请求外勤v3
${KQ_WqA01_querymobilework}    /querymobilework.html    # 查询当前未结束外勤
${KQ_WqA01_revokeMobilework}    /revokeMobilework.html    # 撤销外勤
${KQ_WqA01_finishmobilework}    /v3/finishmobilework.html    # 结束外勤v3
${KQ_WqA01_queryCurrentmobilework}    /v2/querymobilework.html    # 查询当前外勤A01
${KQ_WqA01_queryreportlist}    /v1/queryreportlist.html    # 查询外勤信息
${KQ_WqB01_delMobileSearch}    /waiqin/wqb/delMobileSearch.html    # 外勤B01删除用户地址记录 v2.4.0
${KQ_WqB01_approval}    /waiqin/wqb/approval.html    # 外勤B01 审核外勤 v2.4.0
${KQ_Leave_QueryTypelist}    /leave/queryTypelist.html    # 获取请假类型列表
${KQ_Leave_QueryMyApplylist}    /leave/queryMyApplylist.html    # 获取我的请假单
${KQ_Leave_QueryApprovallist}    /leave/v1/queryApprovallist    # 请假审批（获取待审列表）
${KQ_leaveRevoke}    /leave/leaveRevoke.html    # 请假撤销（Tsg/comic）
${KQ_leaveApply}    /leave/apply    # 请假申请（tsg/comic）
${KQ_overtime_checkIsAllow}    /overtime/checkIsAllow.html    # 1.1.58    检测某人某日是否可以补临时加班申请
${KQ_overtime_mendApply}    /overtime/mendApply.html    # 补临时加班申请
${KQ_queryUnreadNum}    /queryUnreadNum.html    # 查询未读考勤外勤条数
${KQ_wqb_todayHasMobile}    /waiqin/wqb/todayHasMobile.html    # WQB01今天是否有外勤
${KQ_shenpi_getDictionaries}    /shenpi/getDictionaries.html    # 1.1.95获取审批字典(以动漫为例)v2.5.1
${KQ_shenpi_mycopyTypeDetail}    /shenpi/mycopy/typeDetail.html    # 1.1.96抄送我的 获取各类型数据详细v2.5.1
${KQ_shenpi_mycopyTypeAll}    /shenpi/mycopy/typeAll.html    # 1.1.97抄送我的获取各类型数据列表v2.5.1
${KQ_shenpi_mycreateGetList}    /shenpi/mycreate/getList.html    # 1.1.98我创建的 获取各类型数据列表（以补考勤为例）v2.5.1
${KQ_shenpi_mycreate_GetDetail}    /shenpi/mycreate/getDetail.html    # 1.1.99我创建的 获取各类型数据详细（以补考勤为例）v2.5.1
${KQ_shenpi_myhandle_GetList}    /shenpi/myhandle/getList.html    # 我处理的 获取各类型数据列表（以补考勤为例）v2.5.1
${KQ_shenpi_myhandle_GetDetail}    /shenpi/myhandle/getDetail.html    # 我处理的 获取各类型数据详细（以补考勤为例）v2.5.1
${KQ_user_doUserUntie}    /user/doUserUntie.html    # 1.1.104    解绑-(没有登录)v2.5.3
${KQ_set_isTel}    /user/set/isTel.html    # 短信开通验证
${KQ_overtime_video_getHours}    /overtime/video/getHours.html    # 1.1.82    加班JB-B01获取时间 v2.5.1
${KQ_overtimevideo_getUserAndHeaderAndDepts}    /overtime/video/getUserAndHeaderAndDepts.html    # 1.1.83    加班JB-B01获取部门负责人默认人/公司领导/一级部门 v2.5.1
${KQ_overtimevideo_getDeptById}    /overtime/video/getDeptById.html    # 1.1.84    加班JB-B01获取部门的子部门和该部门的负责人 v2.5.1
${KQ_overtimevideo_searchUser}    /overtime/video/searchUser.html    # 1.1.85    加班JB-B01搜索人（部门负责人) v2.5.1
${KQ_repair_searchUser}    /repair/searchUser.html    # 1.1.89    补考勤 搜索人（部门负责人) v2.5.1
${KQ_repair_getUserAndHeaderAndDepts}    /repair/getUserAndHeaderAndDepts.html    # 1.1.87    补考勤 获取部门负责人默认人/公司领导/一级部门 v2.5.1
${KQ_repair_getDeptById}    /repair/getDeptById.html    # 1.1.88    补考勤 获取部门的子部门和该部门的负责人 v2.5.1
${KQ_overtime_video_doApply}    /overtime/video/doApply.html    # 1.1.80    加班JB-B01申请 v2.5.1
${KQ_overtime_video_jpushDetail}    /overtime/video/jpushDetail.html    # 1.1.86    加班JB-B01推送详细 v2.5.1
${KQ_repair_isRepairWork}    /repair/isRepairWork.html    # 1.1.90补考勤是否可以补考勤
${KQ_repair_doApply}    /repair/doApply.html    # 1.1.91    补考勤 申请 v2.5.1
${KQ_repair_repairRevoke}    /repair/repairRevoke.html    # 1.1.94    补考勤 撤回 v2.5.1
${KQ_repair_jpushDetail}    /repair/jpushDetail.html    # 1.1.92    补考勤 推送详细 v2.5.1
${KQ_repair_approval}    /repair/approval.html    # 1.1.93 | 补考勤 审核 v2.5.1
${KQ_overtime_video_approval}    /overtime/video/approval.html    # 1.1.81    加班JB-B01审核 \ v2.5.1
${KQ_leave_queryApprovedlist}    /leave/v1/queryApprovedlist    # 1.1.24    请假审批（获取已审列表）v1
${KQ_leave_vacationRemove}    /leave/vacationRemove    # 1.1.48    请假时间去除节假日接口
${KQ_leave_v1_apply}    /leave/v1/apply    # 1.1.21    请假申请
${KQ_v1_queryMyApplyfindByLeaveId}    /v1/queryMyApplyfindByLeaveId.html    # 1.1.60    查询请假详细数据
${KQ_leave_v1_approval}    /leave/v1/approval.html    # 1.1.23    请假审批（审批）
${KQ_video_apply.html}    /leave/video/apply.html    # 视讯请假申请
${KQ_video_leaveRevoke.html}    /leave/video/leaveRevoke.html    # 视讯请假撤回
${KQ_cancel_apply.html}    /leave/video/cancel/apply.html    # 1.1.142视讯撤销请假 申请v2.5.4
${KQ_common_getTypeId.html}    /common/getTypeId.html    # 1.1.139    获取假种类型以及对应天数
${KQ_leave_video_all_allowDays.html}    /leave/video/all/allowDays.html    # 1.1.147    视讯获取可补请假申请日期接口
${KQ_mycreate_getMycreateAndCopyMeList.html}    /shenpi/mycreate/getMycreateAndCopyMeList.html    # 获取我申请各类型数据列表
${KQ_shenpi_mycreate_getMycreateAndCopyMeDetail.html}    /shenpi/mycreate/getMycreateAndCopyMeDetail.html    # 获取各类型数据详细 2.5.5
${KQ_shenpi_myhandle_getPendingList.html}    /shenpi/myhandle/getPendingList.html    # 我处理的（待处理）获取各类型数据列表
${KQ_shenpi_myhandle_getOneDetail.html}    /shenpi/myhandle/getOneDetail.html    # 我处理的（详细）获取各类型数据列表
${KQ_home_homePage.html}    /home/homePage.html    # 1.1.160    登陆成功后首页接口
${KQ_kqStat_getStat.html}    /kqStat/getStat.html    # 1.1.162    进入统计界面接口 \ 2.5.5
${KQ_activity_approval.html}    /activity/approval.html    # 1.1.137 | TSG 审核活动 \ v2.5.4
${KQ_activity_saveActivity.html}    /activity/saveActivity.html    # 1.1.136    TSG 新增/更新活动 \ v2.5.4
${KQ_doPublish.html}    /activity/doPublish.html    # 1.1.128    TSG 发布活动 v2.5.4
${KQ_activity_activityRevoke.html}    /activity/activityRevoke.html    # 1.1.126    TSG撤回活动 v2.5.4
${KQ_leave_video_all_apply.html}    /leave/video/all/apply.html    # 1.1.140    视讯请假 申请v2.5.4
${KQ_Leave_video_all_approval.html}    /leave/video/all/approval.html    # 1.1.141    视讯请假 审核 v2.5.4
${KQ_leave_video_cancel_apply}    /leave/video/cancel/apply.html    # 1.1.142	视讯撤销请假 申请v2.5.4
${KQ_leave_video_cancel_revoke.html}    /leave/video/cancel/revoke.html    # 1.1.144    视讯撤回销假接口 v2.5.4
${KQ_leave_video_cancel_jpushDetail.html}    /leave/video/cancel/jpushDetail.html    # 1.1.146    视讯销假推送详细接口 v2.5.4
${KQ_video_cancel_queryList}    /leave/video/cancel/queryList.html    # 1.1.143 | 视讯点击撤销后的列表接口 v2.5.4
${KQ_leave_video_cancel_revoke}    /leave/video/cancel/revoke.html    # 1.1.144 视讯撤回销假接口 v2.5.4
