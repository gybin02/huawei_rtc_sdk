package io.agora.agorartcengine

import android.os.Environment
import com.huawei.rtc.models.LogInfo
import com.huawei.rtc.models.LogInfo.LogLevel
import com.huawei.rtc.models.UserInfo

/**
 * 工具类
 *
 * @author zhengxiaobin
 * @date 2020/6/5
 */
internal object RtcUtil {
    fun userInfoFromJson(json: Map<String, Any>): UserInfo {
        val userInfo = UserInfo()
        userInfo.userId = json["userId"] as String?
        userInfo.ctime = json["ctime"] as Int
        userInfo.optionalInfo = json["optionalInfo"] as String?
        val role = json["role"] as Int
        userInfo.role = UserInfo.RoleType.values()[role]
        userInfo.signature = json["signature"] as String?
        userInfo.userName = json["userName"] as String?
        return userInfo
    }

    fun logInfoFromJson(json: Map<String?, Any?>): LogInfo {
        val userInfo = LogInfo()
        userInfo.path = json["path"] as String?
        val level = json["level"] as Int
        userInfo.level = LogLevel.values()[level]
        return userInfo
    }

    val logPath: String
        get() {
            val path = Environment.getExternalStorageDirectory()
            return path.absolutePath + "/rtcLog"
        }
}