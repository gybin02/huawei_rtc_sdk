package io.agora.agorartcengine;

import android.os.Environment;

import com.huawei.rtc.models.LogInfo;
import com.huawei.rtc.models.UserInfo;

import java.io.File;
import java.util.Map;

/**
 * 工具类
 *
 * @author zhengxiaobin
 * @date 2020/6/5
 */
class RtcUtil {

    static UserInfo userInfoFromJson(Map<String, Object> json) {
        UserInfo userInfo = new UserInfo();
        userInfo.setUserId((String) json.get("userId"));
        userInfo.setCtime((int) json.get("ctime"));
        userInfo.setOptionalInfo((String) json.get("optionalInfo"));
        int role = (int) json.get("role");
        userInfo.setRole(UserInfo.RoleType.values()[role]);
        userInfo.setSignature((String) json.get("signature"));
        userInfo.setUserName((String) json.get("userName"));
        return userInfo;
    }

    static LogInfo logInfoFromJson(Map<String, Object> json) {
        LogInfo userInfo = new LogInfo();
        userInfo.setPath((String) json.get("path"));
        int level = (int) json.get("level");
        userInfo.setLevel(LogInfo.LogLevel.values()[level]);
        return userInfo;
    }

    public static String getLogPath(){
        File path = Environment.getExternalStorageDirectory();
        return path.getAbsolutePath()+"/rtcLog";
    }

}
