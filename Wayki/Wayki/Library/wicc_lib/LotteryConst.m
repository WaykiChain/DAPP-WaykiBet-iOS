	#import "LotteryConst.h"


	//彩种
    //足彩
    Byte const lottery_football = 0x01;
    //篮彩
    Byte const lottery_basketball = 0x02;
    //时时彩
    Byte const lottery_ssc = 0x03;

    //足彩玩法

    //胜平负
    Byte const football_play_spf = 0x01;
    //让球胜平负
    Byte const football_play_rspf = 0x02;
    //总进球
    Byte const football_play_total = 0x03;
    //半全场
    Byte const football_play_half = 0x04;

    //足彩胜平负投注方案

    //主胜
    Byte const football_spf_win = 0x01;
    //平
    Byte const football_spf_even = 0x02;
    //主负
    Byte const football_spf_lost = 0x03;


    //足彩让球胜平负投注方案

    //主胜
    Byte const football_rspf_win = 0x01;
    //平
    Byte const football_rspf_even = 0x02;
    //主负
    Byte const football_rspf_lost = 0x03;

    //足彩总进球投注方案

    //0球
    Byte const football_total_0 = 0x01;
    //1球
    Byte const football_total_1 = 0x02;
    //2球
    Byte const football_total_2 = 0x03;
    //3球
    Byte const football_total_3 = 0x04;
    //4球
    Byte const football_total_4 = 0x05;
    //5球
    Byte const football_total_5 = 0x06;
    //6球
    Byte const football_total_6 = 0x07;
    //7球+
    Byte const football_total_7 = 0x08;


    //足彩半全场投注方案
    //胜胜
    Byte const football_half_winwin = 0x01;
    //胜平
    Byte const football_half_wineven = 0x02;
    //胜负
    Byte const football_half_winlost = 0x03;
    //平胜
    Byte const football_half_evenwin = 0x04;
    //平平
    Byte const football_half_eveneven = 0x05;
    //平负
    Byte const football_half_evenlost = 0x06;
    //负胜
    Byte const football_half_lostwin = 0x07;
    //负平
    Byte const football_half_losteven = 0x08;
    //负负
    Byte const football_half_lostlost = 0x09;


    //篮彩玩法
    //胜负
    Byte const basketball_play_sf = 0x01;
    //让分胜负
    Byte const basketball_play_rsf = 0x02;
    //胜分差
    Byte const basketball_play_score = 0x03;

    //篮彩胜负投注方案

    //胜
    Byte const basketball_sf_win = 0x01;
    //负
    Byte const basketball_sf_lost = 0x02;

    //篮彩让分胜负投注方案
    //胜
    Byte const basketball_rsf_win = 0x01;
    //负
    Byte const basketball_rsf_lost = 0x02;

    //篮彩胜分差投注方案
    //主胜1-5
    Byte const basketball_score_win_1_5 = 0x01;
    //主胜6-10
    Byte const basketball_score_win_6_10 = 0x02;
    //主胜11-15
    Byte const basketball_score_win_11_15 = 0x03;
    //主胜16-20
    Byte const basketball_score_win_16_20 = 0x04;
    //主胜21-25
    Byte const basketball_score_win_21_25 = 0x05;
    //主胜26+
    Byte const basketball_score_win_26 = 0x06;
    //主负1-5
    Byte const basketball_score_lost_1_5 = 0x07;
    //主负6-10
    Byte const basketball_score_lost_6_10 = 0x08;
    //主负11-15
    Byte const basketball_score_lost_11_15 = 0x09;
    //主负16-20
    Byte const basketball_score_lost_16_20 = 0x0a;
    //主负21-25
    Byte const basketball_score_lost_21_25 = 0x0b;
    //主负26+
    Byte const basketball_score_lost_26 = 0x0c;


    //时时彩玩法
    //一星
    Byte const ssc_play_1star = 0x01;
    //组三组六
    Byte const ssc_play_g3g6 = 0x02;
    //三星和值
    Byte const ssc_play_3star = 0x03;

    //时时彩一星投注方案
    //0
    Byte const ssc_1star_0 = 0x01;
    //1
    Byte const ssc_1star_1 = 0x02;
    //2
    Byte const ssc_1star_2 = 0x03;
    //3
    Byte const ssc_1star_3 = 0x04;
    //4
    Byte const ssc_1star_4 = 0x05;
    //5
    Byte const ssc_1star_5 = 0x06;
    //6
    Byte const ssc_1star_6 = 0x07;
    //7
    Byte const ssc_1star_7 = 0x08;
    //8
    Byte const ssc_1star_8 = 0x09;
    //9
    Byte const ssc_1star_9 = 0x0a;

    //时时彩组三组六投注方案
    //组三
    Byte const ssc_g3g6_g3 = 0x01;
    //组六
    Byte const ssc_g3g6_g6 = 0x02;

    //时时彩三星和值投注方案
    //0
    Byte const ssc_3star_0 = 0x01;
    //1
    Byte const ssc_3star_1 = 0x02;
    //2
    Byte const ssc_3star_2 = 0x03;
    //3
    Byte const ssc_3star_3 = 0x04;
    //4
    Byte const ssc_3star_4 = 0x05;
    //5
    Byte const ssc_3star_5 = 0x06;
    //6
    Byte const ssc_3star_6 = 0x07;
    //7
    Byte const ssc_3star_7 = 0x08;
    //8
    Byte const ssc_3star_8 = 0x09;
    //9
    Byte const ssc_3star_9 = 0x0a;
    //10
    Byte const ssc_3star_10 = 0x0b;

    //11
    Byte const ssc_3star_11 = 0x0c;
    //12
    Byte const ssc_3star_12 = 0x0d;
    //13
    Byte const ssc_3star_13 = 0x0e;
    //14
    Byte const ssc_3star_14 = 0x0f;
    //15
    Byte const ssc_3star_15 = 0x10;
    //16
    Byte const ssc_3star_16 = 0x11;
    //17
    Byte const ssc_3star_17 = 0x12;
    //18
    Byte const ssc_3star_18 = 0x13;
    //19
    Byte const ssc_3star_19 = 0x14;
    //20
    Byte const ssc_3star_20 = 0x15;
    //21
    Byte const ssc_3star_21 = 0x16;
    //22
    Byte const ssc_3star_22 = 0x17;
    //23
    Byte const ssc_3star_23 = 0x18;
    //24
    Byte const ssc_3star_24 = 0x19;
    //25
    Byte const ssc_3star_25 = 0x1a;
    //26
    Byte const ssc_3star_26 = 0x1b;
    //27
    Byte const ssc_3star_27 = 0x1c;