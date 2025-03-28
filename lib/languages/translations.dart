import 'package:get/get.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'zh_CN': zhCN, 'en_US': enUS};

  static final Map<String, String> zhCN = {
    'appTitle': '挠痒痒游戏',
    'startGame': '开始游戏',
    'gameRules': '游戏规则',
    'leaderboard': '排行榜',
    'settings': '设置',
    'exitGame': '退出游戏',
    'gameRulesTitle': '抓痒痒游戏规则',
    'gameRulesContent':
        '1. 游戏目标：在规定时间内尽可能多地点击出现的痒痒点\n'
        '2. 难度说明：\n'
        '   - 简单：痒痒点移动速度慢，出现频率低\n'
        '   - 中等：痒痒点移动速度中等，出现频率中等\n'
        '   - 困难：痒痒点移动速度快，出现频率高\n'
        '3. 计分规则：\n'
        '   - 每次点击正确位置得10分\n'
        '   - 连续点击正确可获得连击加分\n'
        '4. 游戏时长：10秒/20秒/30秒可选\n'
        '5. 特殊效果：\n'
        '   - 开启人物摆动会增加游戏难度\n'
        '   - 显示辅助提示会帮助定位痒痒点',
    // Game Stats
    'scoreLabel': '得分',
    'timeLeftLabel': '剩余时间',
    'tapLabel': '点击部位',
    'difficultyLabel': '难度级别',
    'correctTapsLabel': '正确点击',
    'wrongTapsLabel': '错误点击',
    'accuracyLabel': '准确率',
    'preciseHitsLabel': '精准点击',
    'fastestResponseLabel': '最快反应',
    'slowestResponseLabel': '最慢反应',
    'averageResponseLabel': '平均反应',
    'homeButton': '回到首页',
    // New translations
    'chinese': '中文',
    'english': 'English',
    'enterNicknameHint': '输入昵称',
    // Game Settings
    'gameSettings': '游戏设置',
    'language': '语言',
    'difficultyLevel': '难度级别',
    'gameDuration': '游戏时长',
    'enableSwing': '开启人物摆动',
    'showHints': '显示辅助提示',
    'enableVibration': '开启震动反馈',
    'playerName': '玩家昵称',
    'easy': '简单',
    'medium': '中等',
    'hard': '困难',
    '10seconds': '10秒',
    '20seconds': '20秒',
    '30seconds': '30秒',
    'viewRules': '查看规则',
    // Leaderboard
    'rankLabel': '排名',
    'nameLabel': '玩家',
    'dateLabel': '日期',
    'noLeaderboardData': '暂无排行榜数据',
    'goChallenge': '去挑战',
    'scorePoints': '@points分',
    'unknown': '未知',
    'restartButton': '再来一次',
    'headPart': '头部',
    'bellyPart': '肚子',
    'leftHandPart': '左手',
    'rightHandPart': '右手',
    'leftFootPart': '左脚',
    'rightFootPart': '右脚',
    'challengeSuccess': '挑战成功!',
    'challengeFailure': '挑战失败',
  };

  static final Map<String, String> enUS = {
    'appTitle': 'Tickle Game',
    'startGame': 'Start Game',
    'gameRules': 'Game Rules',
    'leaderboard': 'Leaderboard',
    'settings': 'Settings',
    'exitGame': 'Exit Game',
    'gameRulesTitle': 'Tickle Game Rules',
    'gameRulesContent':
        '1. Game Objective: Click as many tickle spots as possible within the time limit\n'
        '2. Difficulty Levels:\n'
        '   - Easy: Slow moving spots, low frequency\n'
        '   - Medium: Moderate speed and frequency\n'
        '   - Hard: Fast moving spots, high frequency\n'
        '3. Scoring Rules:\n'
        '   - 10 points per correct click\n'
        '   - Combo bonus for consecutive hits\n'
        '4. Game Duration: 10s/20s/30s options\n'
        '5. Special Effects:\n'
        '   - Character wobble increases difficulty\n'
        '   - Visual hints help locate tickle spots',
    // Game Stats
    'scoreLabel': 'Score',
    'timeLeftLabel': 'Time Left',
    'tapLabel': 'Tap Target',
    'difficultyLabel': 'Difficulty',
    'correctTapsLabel': 'Correct Taps',
    'wrongTapsLabel': 'Wrong Taps',
    'accuracyLabel': 'Accuracy',
    'preciseHitsLabel': 'Precise Hits',
    'fastestResponseLabel': 'Fastest Response',
    'slowestResponseLabel': 'Slowest Response',
    'averageResponseLabel': 'Average Response',
    'homeButton': 'Back to Home',
    // New translations
    'chinese': 'Chinese',
    'english': 'English',
    'enterNicknameHint': 'Enter nickname',
    // Game Settings
    'gameSettings': 'Game Settings',
    'language': 'Language',
    'difficultyLevel': 'Difficulty Level',
    'gameDuration': 'Game Duration',
    'enableSwing': 'Enable Character Swing',
    'showHints': 'Show Hints',
    'enableVibration': 'Enable Vibration',
    'playerName': 'Player Name',
    'easy': 'Easy',
    'medium': 'Medium',
    'hard': 'Hard',
    '10seconds': '10 seconds',
    '20seconds': '20 seconds',
    '30seconds': '30 seconds',
    'viewRules': 'View Rules',
    // Leaderboard
    'rankLabel': 'Rank',
    'nameLabel': 'Player',
    'dateLabel': 'Date',
    'noLeaderboardData': 'No leaderboard data',
    'goChallenge': 'Go Challenge',
    'scorePoints': '@points points',
    'unknown': 'Unknown',
    'restartButton': 'Restart Button',
    'headPart': 'Head',
    'bellyPart': 'Belly',
    'leftHandPart': 'Left Hand',
    'rightHandPart': 'Right Hand',
    'leftFootPart': 'Left Foot',
    'rightFootPart': 'Right Foot',
    'challengeSuccess': 'Challenge Success!',
    'challengeFailure': 'Challenge Failed',
  };
}
