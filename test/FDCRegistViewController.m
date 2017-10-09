//
//  FDCRegistViewController.m
//  GameBox
//
//  Created by nyhx on 15/12/17.
//  Copyright © 2015年 Marco. All rights reserved.
//

#import "FDCRegistViewController.h"
#import "MacroMethod.h"
#import "FDCChooseBankViewController.h"
#import "FDCBankInfoViewController.h"
#import "LotteryDB.h"
#import "FDCObject.h"
//
#import "APITool.h"
#import "LanInternational.h"
#import "MainViewController.h"
@interface FDCRegistViewController ()<UITextFieldDelegate,FDCChooseBankViewDelegate,FDCBankInfoViewDelegate>
{
    NSMutableData *registData;
    FDCBankInfoViewController * bankinfo;
}
@property (weak, nonatomic) IBOutlet UILabel *labelRegist;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UITextField *count;
@property (weak, nonatomic) IBOutlet UITextField *mima;
@property (weak, nonatomic) IBOutlet UITextField *commitMima;
@property (weak, nonatomic) IBOutlet UIButton *chooseBankBtn;
@property (weak, nonatomic) IBOutlet UITextField *account;//银行帐户
@property (weak, nonatomic) IBOutlet UITextField *bankno;
@property (weak, nonatomic) IBOutlet UIButton *currencyBtn;
- (IBAction)registTap:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *telephone;
@property (weak, nonatomic) IBOutlet UITextField *reommendPepole;
@property (weak, nonatomic) IBOutlet UILabel *ramdonNumber;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengma;

//
@property(nonatomic,strong)NSString * bankid;
@property(nonatomic,strong)NSString * Currencyid;
@property (weak, nonatomic) IBOutlet UILabel *labelTipCount;
@property (weak, nonatomic) IBOutlet UILabel *labelTipMima;
@property (weak, nonatomic) IBOutlet UILabel *labelTipQuerenmima;
@property (weak, nonatomic) IBOutlet UILabel *labelTipYinhangzhanghu;
@property (weak, nonatomic) IBOutlet UILabel *labelTipBankNo;
@property (weak, nonatomic) IBOutlet UILabel *labelTipEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelTipPhone;
@property (weak, nonatomic) IBOutlet UITextField *adderssText;
@property (weak, nonatomic) IBOutlet UITextField *fullNameText;
@property (weak, nonatomic) IBOutlet UIButton *contryText;
@property (weak, nonatomic) IBOutlet UIButton *xingbieBu;
@property (weak, nonatomic) IBOutlet UIButton *yearBu;

@property (weak, nonatomic) IBOutlet UIButton *monthBu;
@property (weak, nonatomic) IBOutlet UIButton *dayBu;

@property (weak, nonatomic) IBOutlet UITableView *tableview1;

@property (weak, nonatomic) IBOutlet UITableView *tableView2;

@property (weak, nonatomic) IBOutlet UITableView *tabelview3;

@property (weak, nonatomic) IBOutlet UITableView *tabeView4;

@property (weak, nonatomic) IBOutlet UITableView *tableView5;



@end

@implementation FDCRegistViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    
}

-(void)initData
{

    [self setBackButton:@""];
    
    self.title = LocalString(@"GBLoginPageRegister");
    
    
    self.ramdonNumber.text=[NSString stringWithFormat:@"%d%d%d%d%d",arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10];
    //语言设置
    _labelRegist.text=LocalString(@"DCPromotionRegRegister");
    [_registBtn setTitle:LocalString(@"DCPromotionRegRegister") forState:UIControlStateNormal];
    _count.placeholder=LocalString(@"DCPromotionRegAccount");
    _mima.placeholder=LocalString(@"DCPromotionRegMima");
    _commitMima.placeholder=LocalString(@"DCPromotionRegCommitMima");
    [_chooseBankBtn setTitle:LocalString(@"DCPromotionRegChooseBank") forState:UIControlStateNormal];
    _account.placeholder=LocalString(@"DCPromotionRegBankAccount");
    _bankno.placeholder=LocalString(@"DCPromotionRegBankNo");
    [_currencyBtn setTitle:LocalString(@"DCPromotionRegCurrency") forState:UIControlStateNormal];
    _email.placeholder=LocalString(@"DCPromotionRegEmail");
    _telephone.placeholder=LocalString(@"DCPromotionRegTelephone");
    _reommendPepole.placeholder=LocalString(@"DCPromotionRegRecommendPepole");
    if (_reommendPepoletext.length>0) {
        _reommendPepole.text=_reommendPepoletext;
    }
    _yanzhengma.placeholder=LocalString(@"DCPromotionRegYanzhengma");
    
    self.labelTipCount.text=LocalString(@"DCPromotionRegAccountTip");
    self.labelTipMima.text=LocalString(@"DCPromotionRegMimaTip");
    self.labelTipQuerenmima.text=LocalString(@"DCPromotionRegCommitMimaTip");
    self.labelTipYinhangzhanghu.text=LocalString(@"DCPromotionRegBankAccountTip");
    self.labelTipBankNo.text=LocalString(@"DCPromotionRegBankNoTip");
    self.labelTipEmail.text=LocalString(@"DCPromotionRegEmailTip");
    self.labelTipPhone.text=LocalString(@"DCPromotionRegTelephoneTip");
#if afbcash || afb1688 || wsands
    _registBtn.backgroundColor = color_RGB(11, 59, 26, 1);
#elif sbobet
    _registBtn.backgroundColor = color_RGB(89, 152, 255, 1);
#endif
}

-(void) clickNavigationButton:(UIButton *) button{

    if (_isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle  = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barTintColor = color_RGB(181, 20, 24, 1);
    
    //状态栏
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 20)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:178/255.0 green:24/255.0 blue:28/255.0 alpha:1];
    
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

-(void)initView
{
    self.chooseBankBtn.layer.cornerRadius=5;
    [self.chooseBankBtn addTarget:self action:@selector(ChosseTap:) forControlEvents:UIControlEventTouchUpInside];
    
    self.currencyBtn.layer.cornerRadius=5;
    [self.currencyBtn addTarget:self action:@selector(currencyTap:) forControlEvents:UIControlEventTouchUpInside];
    
    self.registBtn.layer.cornerRadius=5;
    self.ramdonNumber.layer.cornerRadius=5;
    self.ramdonNumber.layer.masksToBounds=YES;
    //self.labelRegist.layer.cornerRadius=5;
    //self.labelRegist.layer.masksToBounds=YES;
    
    _count.delegate=self;
    _mima.delegate=self;
    _commitMima.delegate=self;
    _account.delegate=self;
    _bankno.delegate=self;
    _telephone.delegate=self;
    _email.delegate=self;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //去掉两边空格
    textField.text=[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //账号限制
    if (textField.tag==1&&textField.text.length>=6&&textField.text.length<=9) {
        const char *ch = [textField.text UTF8String];
        BOOL isright=NO;
        for (int i = 0; i < strlen(ch); i++) {
            if ((48<=ch[i]&&ch[i]<=57)||(65<=ch[i]&&ch[i]<=90)||(97<=ch[i]&&ch[i]<=122)) {
                isright=YES;
            }else
            {
                isright=NO;
                break;
            }
        }
        if (isright) {
            textField.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
            self.labelTipCount.hidden=YES;
        }else
        {
            textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
            self.labelTipCount.hidden=NO;
        }
        
    }
    else if (textField.tag==1&&textField.text.length==0)
    {
        textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
        self.labelTipCount.hidden=NO;
    }else if (textField.tag==1)
    {
        textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
        self.labelTipCount.hidden=NO;
    }
    
    //密码限制
    if (textField.tag==2&&textField.text.length>=8&&textField.text.length<=20) {
        const char *ch = [textField.text UTF8String];
        int MAX=0;
        int MIN=0;
        for (int i = 0; i < strlen(ch); i++) {
            MAX=ch[0];
            if (MAX<=ch[i]) {
                MAX=ch[i];
            }
            MIN=ch[0];
            if (MIN>=ch[i]) {
                MIN=ch[i];
            }
        }
        if (48<=MIN&&MIN<=57&&MAX<=122&&MAX>=65) {
            
            const char *ch = [textField.text UTF8String];
            BOOL isright=NO;
            for (int i = 0; i < strlen(ch); i++) {
                if ((48<=ch[i]&&ch[i]<=57)||(65<=ch[i]&&ch[i]<=90)||(97<=ch[i]&&ch[i]<=122)) {
                    isright=YES;
                }else
                {
                    isright=NO;
                    break;
                }
            }
            if (isright) {
                textField.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
                self.labelTipMima.hidden=YES;
            }else
            {
                textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
                self.labelTipMima.hidden=NO;
            }
            
            
        }else
        {
            textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
            self.labelTipMima.hidden=NO;
        }
    }
    else if (textField.tag==2&&textField.text.length==0)
    {
        textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
        self.labelTipMima.hidden=NO;
    }else if (textField.tag==2)
    {
        textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
        self.labelTipMima.hidden=NO;
    }
    //确认密码
    if (textField.tag==3&&![textField.text isEqualToString:_mima.text]) {
        textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
        self.labelTipQuerenmima.hidden=NO;
    }else if (textField.tag==3&&[textField.text isEqualToString:_mima.text])
    {
        textField.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        self.labelTipQuerenmima.hidden=YES;
    }else if(textField.tag==3)
    {
        textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
        self.labelTipQuerenmima.hidden=NO;
    }
    
    //银行帐户
    if (textField.tag==4&&textField.text.length>=2&&textField.text.length<=20) {
        const char *ch = [textField.text UTF8String];
        int MAX=0;
        for (int i = 0; i < strlen(ch); i++) {
            if((48<=ch[i]&&ch[i]<=57)||(65<=ch[i]&&ch[i]<=90)||(97<=ch[i]&&ch[i]<=122)||ch[i]==32){
                
            }else
            {
                MAX=+1;
            }
        }
        if (MAX!=0) {
            textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
            self.labelTipYinhangzhanghu.hidden=NO;
        }else
        {
            textField.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
            self.labelTipYinhangzhanghu.hidden=YES;
        }
    }else if (textField.tag==4&&textField.text.length==0)
    {
        textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
        self.labelTipYinhangzhanghu.hidden=NO;
    }else if (textField.tag==4)
    {
        textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
        self.labelTipYinhangzhanghu.hidden=NO;
    }
    
    //银行帐号
    if (textField.tag==5&&textField.text.length>=6&&textField.text.length<=20) {
        const char *ch = [textField.text UTF8String];
        int MAX=0;
        int MIN=0;
        for (int i = 0; i < strlen(ch); i++) {
            MAX=ch[0];
            if (MAX<=ch[i]) {
                MAX=ch[i];
            }
            MIN=ch[0];
            if (MIN>=ch[i]) {
                MIN=ch[i];
            }
        }
        if (48<=MIN&&MIN<=57&&MAX<=57&&MAX>=48) {
            textField.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
            self.labelTipBankNo.hidden=YES;
        }else
        {
            textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
            self.labelTipBankNo.hidden=NO;
        }
        
    }else if (textField.tag==5&&textField.text.length==0)
    {
        textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
        self.labelTipBankNo.hidden=NO;
    }else if (textField.tag==5)
    {
        textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
        self.labelTipBankNo.hidden=NO;
    }
    //邮件限制
    if (textField.tag==7) {
        NSRange rang1=[textField.text rangeOfString:@"@"];
        NSRange rang2=[textField.text rangeOfString:@"."];
        if (rang1.location>=2&&rang1.location<rang2.location&&rang2.location<50) {
            textField.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
            self.labelTipEmail.hidden=YES;
        }else
        {
            textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
            self.labelTipEmail.hidden=NO;
        }
    }
    //电话号码
    if (textField.tag==8&&textField.text.length>=6&&textField.text.length<=20) {
        const char *ch = [textField.text UTF8String];
        int MAX=0;
        int MIN=0;
        for (int i = 0; i < strlen(ch); i++) {
            MAX=ch[0];
            if (MAX<=ch[i]) {
                MAX=ch[i];
            }
            MIN=ch[0];
            if (MIN>=ch[i]) {
                MIN=ch[i];
            }
        }
        if (48<=MIN&&MIN<=57&&MAX<=57&&MAX>=48) {
            textField.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
            self.labelTipPhone.hidden=YES;
        }else
        {
            textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
            self.labelTipPhone.hidden=NO;
        }
    }else if (textField.tag==8&&textField.text.length==0)
    {
        textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
        self.labelTipPhone.hidden=NO;
    }else if (textField.tag==8)
    {
        textField.backgroundColor=[UIColor colorWithRed:255/255.0 green:241/255.0 blue:180/255.0 alpha:1];
        self.labelTipPhone.hidden=NO;
    }
}

-(void)ChosseTap:(UIButton *)sender
{
    bankinfo=[FDCBankInfoViewController shareInstance];
    [bankinfo  requestBankInfo];
    
    FDCChooseBankViewController * chooseView=[[FDCChooseBankViewController alloc]init];
    chooseView.delegate=self;
    chooseView.isNotNeedSetAccont = YES;
    [self.navigationController pushViewController:chooseView animated:YES];
    
}

-(void)setBankname:(NSString *)str andID:(NSString *)bankid
{
    [_chooseBankBtn setTitle:str forState:UIControlStateNormal];
    [_currencyBtn setTitle:LocalString(@"DCPromotionRegCurrency") forState:UIControlStateNormal];
    for (BankInfo * binfo in bankinfo.arr_banks) {
        if ([binfo.id_mod_bank isEqualToString:bankid]) {
            [_currencyBtn setTitle:bankinfo.Dic_currency[binfo.currency] forState:UIControlStateNormal];
            self.Currencyid=binfo.currency;
        }
    }
    
    self.bankid=bankid;
}


-(void)currencyTap:(UIButton *)sender
{
    bankinfo.delegate=self;
    bankinfo.bankid=self.bankid;
    [self.navigationController pushViewController:bankinfo animated:YES];
}

-(void)setCurrency:(NSString *)str andCurrencyid:(NSString *)Currencyid
{
    [_currencyBtn setTitle:str forState:UIControlStateNormal];
   // NSLog(@"str=%@,Currencyid=%@",str,Currencyid);
    self.Currencyid=Currencyid;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)registTap:(id)sender {

    if (!self.labelTipCount.isHidden) {
        ALERT(LocalString(@"DCPromotionRegAccount"), self.labelTipCount.text);
        return;
    }
    if (!self.labelTipMima.isHidden) {
        ALERT(LocalString(@"DCPromotionRegMima"), self.labelTipMima.text);
        return;
    }
    if (!self.labelTipQuerenmima.isHidden) {
        ALERT(LocalString(@"DCPromotionRegCommitMima"), self.labelTipQuerenmima.text);
        return;
    }
    if (!self.labelTipYinhangzhanghu.isHidden) {
        ALERT(LocalString(@"DCPromotionRegBankAccount"), self.labelTipYinhangzhanghu.text);
        return;
    }
    if (!self.labelTipBankNo.isHidden) {
        ALERT(LocalString(@"DCPromotionRegBankNo"), self.labelTipBankNo.text);
        return;
    }
    if (!self.labelTipEmail.isHidden) {
        ALERT(LocalString(@"DCPromotionRegEmail"), self.labelTipEmail.text);
        return;
    }
    if (!self.labelTipPhone.isHidden) {
        ALERT(LocalString(@"DCPromotionRegTelephone"), self.labelTipPhone.text);
        return;
    }
    
    if (![self.yanzhengma.text isEqualToString:self.ramdonNumber.text]) {
        ALERT(LocalString(@"DCNumberGameTishi"), LocalString(@"DCRegistTishiOne"));
        return;
    }
    else
    {
        //web_id=2&useracc=test001&password=11111111&email=123@123.com&captcha=1234&tel=45656&bank=BNK&bankaccount=qweqr&bankno=214324324&referrall_id=test000&currency=1
        registData=[[NSMutableData alloc]init];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", __SERVER_URL_NUMBER_, @"index.php?page=signup_submitter"];
      //  NSLog(@"注册url ：%@", urlStr);
        NSURL * url=[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];//默认为get请求
        request.timeoutInterval=20.0;//设置请求超时为5秒
        request.HTTPMethod=@"POST";//设置请求方法
        //设置请求体
        NSString *param=[NSString stringWithFormat:@"web_id=%@&useracc=%@&password=%@&email=%@&captcha=%@&tel=%@&bank=%@&bankaccount=%@&bankno=%@&referrall_id=%@&currency=%@",GWebID,self.count.text,self.mima.text,self.email.text,@"3355",self.telephone.text,self.bankid,self.account.text,self.bankno.text,self.reommendPepole.text,(self.Currencyid.length == 0 ? @"1":self.Currencyid)];
     //   NSLog(@"%@",param);
        //把拼接后的字符串转换为data，设置请求体
        request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
        //同步请求
        NSURLConnection * connect=[[NSURLConnection alloc]initWithRequest:request delegate:self];
        [connect start];
    }
    
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   // NSLog(@"接受到服务器回应");
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [registData appendData:data];
    
  //  NSLog(@"接受到数据");
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   // NSLog(@"完成数据接收");
    //处理数据
    NSMutableString * str=[[NSMutableString alloc]initWithData:registData encoding:NSUTF8StringEncoding];
    if (str.length>0) {
        NSRange rang=[str rangeOfString:@"{"];
        NSRange rang2={0,rang.location};
        [str deleteCharactersInRange:rang2];
    }
    NSData * data=[str dataUsingEncoding:NSUTF8StringEncoding];
    id responsed=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if ([responsed isKindOfClass:[NSDictionary class]]) {
        if ([responsed[@"msg"] isEqualToString:@"-1"]) {
            ALERT(LocalString(@"DCNumberGameTishi"), LocalString(@"DCRegistTishiTthree"));
        }else if ([responsed[@"msg"] isEqualToString:@"-2"]) {
            ALERT(LocalString(@"DCNumberGameTishi"), LocalString(@"DCRegistTishifour"));
        }else if ([responsed[@"msg"] isEqualToString:@"-3"]) {
            ALERT(LocalString(@"DCNumberGameTishi"), LocalString(@"DCRegistTishifive"));
        }else if ([responsed[@"msg"] isEqualToString:@"-4"]) {
            ALERT(LocalString(@"DCNumberGameTishi"), LocalString(@"DCRegistTishisix"));
        }else if ([responsed[@"msg"] isEqualToString:@"-5"]) {
            ALERT(LocalString(@"DCNumberGameTishi"), LocalString(@"DCRegistTishiseven"));
        }else if ([responsed[@"msg"] isEqualToString:@"1"]) {
            
            
            [[APITool shareInstance] ApiCreateNewMember:self.count.text password:GWebSiteName currency:[self.Currencyid integerValue] success:^(User *responseObject) {
                ALERT(LocalString(@"DCNumberGameTishi"), LocalString(@"DCRegistTishiOne1"));
                if (_isPresent) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } failure:^(NSDictionary *error) {
                ALERT(LocalString(@"DCNumberGameTishi"), LocalString(@"DCRegistTishiTthree"));
            }];
            
            
        }
    }
}


- (IBAction)chooseMessage:(UIButton *)sender {
}





-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    ALERT(LocalString(@"DCNumberGameTishi"), LocalString(@"DCRegistTishiOne2"));
  //  NSLog(@"%@",[error localizedDescription]);
}
@end
