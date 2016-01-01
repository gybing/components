--------------------------------------------------
-- Export file for user TRADE_GNNT@SPOT.DEV.183 --
-- Created by hxx on 2015/11/17, 21:57:44 --------
--------------------------------------------------

set define off
spool spot.vendue.struct.log

prompt
prompt Creating table BI_BUSINESSRELATIONSHIP
prompt ======================================
prompt
create table BI_BUSINESSRELATIONSHIP
(
  stockid      VARCHAR2(16) not null,
  buyer        VARCHAR2(32) not null,
  seller       VARCHAR2(32) not null,
  received     CHAR(1),
  receiveddate DATE,
  selltime     DATE
)
;
comment on column BI_BUSINESSRELATIONSHIP.stockid
  is '仓单id';
comment on column BI_BUSINESSRELATIONSHIP.buyer
  is '买家';
comment on column BI_BUSINESSRELATIONSHIP.seller
  is '卖家';
comment on column BI_BUSINESSRELATIONSHIP.received
  is '收货状态0否1是';
comment on column BI_BUSINESSRELATIONSHIP.receiveddate
  is '收货时间';
comment on column BI_BUSINESSRELATIONSHIP.selltime
  is '卖出时间';

prompt
prompt Creating table BI_STOCK
prompt =======================
prompt
create table BI_STOCK
(
  stockid       VARCHAR2(16) not null,
  realstockcode VARCHAR2(30) not null,
  breedid       NUMBER(10) not null,
  warehouseid   VARCHAR2(30) default 0 not null,
  quantity      NUMBER(15,2) default 0 not null,
  unit          VARCHAR2(16) not null,
  ownerfirm     VARCHAR2(32) not null,
  lasttime      DATE,
  createtime    DATE,
  stockstatus   NUMBER(1) default 0 not null
)
;
comment on column BI_STOCK.lasttime
  is '最后一次修改时间';
comment on column BI_STOCK.stockstatus
  is '0:未注册仓单  1：注册仓单  2：已出库仓单  3：已拆单 4：拆仓单处理中 5：出库申请中';
alter table BI_STOCK
  add constraint PK_BI_STOCK primary key (STOCKID);

prompt
prompt Creating table BI_DISMANTLE
prompt ===========================
prompt
create table BI_DISMANTLE
(
  dismantleid   NUMBER(16) not null,
  stockid       VARCHAR2(16) not null,
  newstockid    VARCHAR2(16),
  realstockcode VARCHAR2(30),
  amount        NUMBER(15,2) default 0 not null,
  applytime     DATE not null,
  processtime   DATE,
  status        CHAR(1)
)
;
comment on column BI_DISMANTLE.status
  is '0:申请中 1：拆单成功 2：拆单失败';
alter table BI_DISMANTLE
  add constraint PK_BI_DISMANTLE primary key (DISMANTLEID);
alter table BI_DISMANTLE
  add constraint REFBI_STOCK84 foreign key (STOCKID)
  references BI_STOCK (STOCKID)
  disable
  novalidate;

prompt
prompt Creating table BI_FINANCINGSTOCK
prompt ================================
prompt
create table BI_FINANCINGSTOCK
(
  financingstockid NUMBER(10) not null,
  stockid          VARCHAR2(16),
  status           CHAR(1),
  createtime       DATE not null,
  releasetime      DATE
)
;
comment on column BI_FINANCINGSTOCK.status
  is '''Y'' 有效  ''N'' 无效';
alter table BI_FINANCINGSTOCK
  add constraint PK_BI_FINANNCINGSTOCK primary key (FINANCINGSTOCKID);

prompt
prompt Creating table BI_FIRM
prompt ======================
prompt
create table BI_FIRM
(
  firmid     VARCHAR2(32) not null,
  password   VARCHAR2(32) not null,
  createtime DATE
)
;
alter table BI_FIRM
  add constraint PK_BI_FIRM primary key (FIRMID);

prompt
prompt Creating table BI_FROZENSTOCK
prompt =============================
prompt
create table BI_FROZENSTOCK
(
  frozenstockid NUMBER(10) not null,
  stockid       VARCHAR2(16) not null,
  moduleid      NUMBER(2) not null,
  status        NUMBER(2) default 0 not null,
  createtime    DATE not null,
  releasetime   DATE
)
;
comment on column BI_FROZENSTOCK.moduleid
  is '10综合管理平台
11财务系统
12监管仓库管理系统
13仓单管理系统
14融资系统
15订单交易
18投资类大宗商品交易系统
19加盟会员管理系统
20做市商交易系统
21竞价系统
22银行接入及结算系统
23E现货
24单点登录系统
25实时行情分析系统
26交易客户端
98demo系统
99公用系统';
comment on column BI_FROZENSTOCK.status
  is '0:仓单使用中 1：仓单释放状态';
alter table BI_FROZENSTOCK
  add constraint PK_BI_FROZENSTOCK primary key (FROZENSTOCKID);
alter table BI_FROZENSTOCK
  add constraint REFBI_STOCK141 foreign key (STOCKID)
  references BI_STOCK (STOCKID)
  disable
  novalidate;

prompt
prompt Creating table BI_GOODSPROPERTY
prompt ===============================
prompt
create table BI_GOODSPROPERTY
(
  stockid        VARCHAR2(16) not null,
  propertyname   VARCHAR2(64) not null,
  propertyvalue  VARCHAR2(64),
  propertytypeid NUMBER(15) not null
)
;
alter table BI_GOODSPROPERTY
  add constraint PK_BI_GOODSPROPERTY primary key (STOCKID, PROPERTYNAME);
alter table BI_GOODSPROPERTY
  add constraint REFBI_STOCK82 foreign key (STOCKID)
  references BI_STOCK (STOCKID)
  disable
  novalidate;

prompt
prompt Creating table BI_INVOICEINFORM
prompt ===============================
prompt
create table BI_INVOICEINFORM
(
  stockid       VARCHAR2(16) not null,
  invoicetype   CHAR(1),
  companyname   VARCHAR2(100),
  address       VARCHAR2(200),
  dutyparagraph VARCHAR2(32),
  bank          VARCHAR2(32),
  bankaccount   VARCHAR2(32),
  name          VARCHAR2(32),
  phone         VARCHAR2(16)
)
;
comment on column BI_INVOICEINFORM.stockid
  is '仓单id';
comment on column BI_INVOICEINFORM.invoicetype
  is '发票类型,0/1个人（公司）';
comment on column BI_INVOICEINFORM.companyname
  is '公司名称/单位名称';
comment on column BI_INVOICEINFORM.address
  is '地址';
comment on column BI_INVOICEINFORM.dutyparagraph
  is '税号';
comment on column BI_INVOICEINFORM.bank
  is '开户银行';
comment on column BI_INVOICEINFORM.bankaccount
  is '开户账号';
comment on column BI_INVOICEINFORM.name
  is '收票人姓名';
comment on column BI_INVOICEINFORM.phone
  is '电话';

prompt
prompt Creating table BI_LOGISTICS
prompt ===========================
prompt
create table BI_LOGISTICS
(
  stockid        VARCHAR2(16) not null,
  logisticsorder VARCHAR2(16),
  company        VARCHAR2(32)
)
;
comment on column BI_LOGISTICS.stockid
  is '仓单id';
comment on column BI_LOGISTICS.logisticsorder
  is '物流订单';
comment on column BI_LOGISTICS.company
  is '物流公司';

prompt
prompt Creating table BI_OUTSTOCK
prompt ==========================
prompt
create table BI_OUTSTOCK
(
  outstockid     NUMBER(15) not null,
  stockid        VARCHAR2(16) not null,
  key            VARCHAR2(32) not null,
  deliveryperson VARCHAR2(64),
  idnumber       VARCHAR2(36),
  status         NUMBER(2) default 0 not null,
  createtime     DATE not null,
  processtime    DATE,
  address        VARCHAR2(32),
  phone          VARCHAR2(36),
  deliverystatus NUMBER(2) not null
)
;
comment on column BI_OUTSTOCK.status
  is '0 出库申请 1 撤销出库申请 2 出库完成';
alter table BI_OUTSTOCK
  add constraint PK_BI_OUTSTOCK primary key (OUTSTOCKID);
alter table BI_OUTSTOCK
  add constraint REFBI_STOCK144 foreign key (STOCKID)
  references BI_STOCK (STOCKID)
  disable
  novalidate;

prompt
prompt Creating table BI_PLEDGESTOCK
prompt =============================
prompt
create table BI_PLEDGESTOCK
(
  pledgestock NUMBER(10) not null,
  stockid     VARCHAR2(16) not null,
  orderid     VARCHAR2(20) not null,
  moduleid    NUMBER(2) not null,
  status      NUMBER(2),
  createtime  DATE not null,
  releasetime DATE
)
;
comment on column BI_PLEDGESTOCK.moduleid
  is '10综合管理平台
11财务系统
12监管仓库管理系统
13仓单管理系统
14融资系统
15订单交易
18投资类大宗商品交易系统
19加盟会员管理系统
20做市商交易系统
21竞价系统
22银行接入及结算系统
23E现货
24单点登录系统
25实时行情分析系统
26交易客户端
98demo系统
99公用系统';
comment on column BI_PLEDGESTOCK.status
  is '0:仓单使用中 1：交易成功仓单释放状态';
alter table BI_PLEDGESTOCK
  add constraint PK_BI_PLEDGESTOCK primary key (PLEDGESTOCK);
alter table BI_PLEDGESTOCK
  add constraint REFBI_STOCK135 foreign key (STOCKID)
  references BI_STOCK (STOCKID)
  disable
  novalidate;

prompt
prompt Creating table BI_STOCKCHGLOG
prompt =============================
prompt
create table BI_STOCKCHGLOG
(
  id         NUMBER(10) not null,
  stockid    VARCHAR2(16),
  srcfirm    VARCHAR2(16) not null,
  tarfirm    VARCHAR2(16) not null,
  createtime DATE
)
;
alter table BI_STOCKCHGLOG
  add constraint PK_BI_STOCKCHGLOG primary key (ID);
alter table BI_STOCKCHGLOG
  add constraint REFBI_STOCK137 foreign key (STOCKID)
  references BI_STOCK (STOCKID)
  disable
  novalidate;

prompt
prompt Creating table BI_STOCKOPERATION
prompt ================================
prompt
create table BI_STOCKOPERATION
(
  stockid     VARCHAR2(16) not null,
  operationid NUMBER(2) not null
)
;
comment on column BI_STOCKOPERATION.operationid
  is '0：拆单 1：融资2：卖仓单 3：交收 4：冻结仓单';
alter table BI_STOCKOPERATION
  add constraint PK_BI_STOCKOPERATION primary key (STOCKID, OPERATIONID);
alter table BI_STOCKOPERATION
  add constraint REFBI_STOCK52 foreign key (STOCKID)
  references BI_STOCK (STOCKID)
  disable
  novalidate;

prompt
prompt Creating table BI_SYSTEMPROPS
prompt =============================
prompt
create table BI_SYSTEMPROPS
(
  key          VARCHAR2(32) not null,
  value        VARCHAR2(64) not null,
  runtimevalue VARCHAR2(64),
  note         VARCHAR2(128)
)
;
comment on column BI_SYSTEMPROPS.value
  is '手续费、保证金等参数设置';
alter table BI_SYSTEMPROPS
  add constraint PK_BI_SYSTEMPROPS primary key (KEY);

prompt
prompt Creating table BI_TRADESTOCK
prompt ============================
prompt
create table BI_TRADESTOCK
(
  tradestockid NUMBER(10) not null,
  stockid      VARCHAR2(16) not null,
  tradeno      VARCHAR2(20) not null,
  moduleid     NUMBER(2) not null,
  createtime   DATE not null,
  releasetime  DATE,
  status       NUMBER(2)
)
;
comment on column BI_TRADESTOCK.moduleid
  is '10综合管理平台
11财务系统
12监管仓库管理系统
13仓单管理系统
14融资系统
15订单交易
18投资类大宗商品交易系统
19加盟会员管理系统
20做市商交易系统
21竞价系统
22银行接入及结算系统
23E现货
24单点登录系统
25实时行情分析系统
26交易客户端
98demo系统
99公用系统';
comment on column BI_TRADESTOCK.status
  is '0:仓单使用中 1：交易成功仓单释放状态';
alter table BI_TRADESTOCK
  add constraint PK_BI_TRADESTOCK primary key (TRADESTOCKID);
alter table BI_TRADESTOCK
  add constraint REFBI_STOCK51 foreign key (STOCKID)
  references BI_STOCK (STOCKID)
  disable
  novalidate;

prompt
prompt Creating table BI_WAREHOUSE
prompt ===========================
prompt
create table BI_WAREHOUSE
(
  id                      NUMBER(10) default 0 not null,
  warehouseid             VARCHAR2(30) default 0 not null,
  warehousename           VARCHAR2(128) default 0 not null,
  status                  NUMBER(2) default 0 not null,
  ownershipunits          VARCHAR2(128),
  registeredcapital       NUMBER(15,2) default 0 not null,
  investmentamount        NUMBER(15,2) default 0 not null,
  address                 VARCHAR2(128),
  coordinate              VARCHAR2(128),
  environmental           VARCHAR2(256),
  rank                    NUMBER(2) default 1 not null,
  testconditions          VARCHAR2(256),
  agreementdate           DATE,
  province                VARCHAR2(128),
  city                    VARCHAR2(128),
  postcode                VARCHAR2(10),
  corporaterepresentative VARCHAR2(128),
  representativephone     VARCHAR2(32),
  contactman              VARCHAR2(128),
  phone                   VARCHAR2(32),
  mobile                  VARCHAR2(32),
  fax                     VARCHAR2(32),
  hasdock                 NUMBER(2) default 1 not null,
  docktonnage             NUMBER(15,2) default 0,
  dockdailythroughput     NUMBER(15,2) default 0,
  shiptype                NUMBER(2) default 3,
  hasrailway              NUMBER(2) default 1 not null,
  railwaydailythroughput  NUMBER(15,2) default 0,
  hastanker               NUMBER(2) default 1 not null,
  tankerdailythroughput   NUMBER(15,2) default 0,
  createtime              DATE not null
)
;
comment on column BI_WAREHOUSE.status
  is '0 可用 1 不可用';
comment on column BI_WAREHOUSE.rank
  is '1 一星级 2 二星级 3 三星级 4 四星级 5 五星级';
comment on column BI_WAREHOUSE.hasdock
  is '0 有码头 1 没有码头';
comment on column BI_WAREHOUSE.shiptype
  is '0 海伦 1 江轮 2 全部 3 不支持';
comment on column BI_WAREHOUSE.hasrailway
  is '0 有铁路专线 1 没有铁路专线';
comment on column BI_WAREHOUSE.hastanker
  is '0 支持 1 不支持';
alter table BI_WAREHOUSE
  add constraint PK_BI_WAREHOUSE primary key (ID);

prompt
prompt Creating table BR_BROKER
prompt ========================
prompt
create table BR_BROKER
(
  brokerid      VARCHAR2(16) not null,
  password      VARCHAR2(64) not null,
  name          VARCHAR2(64) not null,
  telephone     VARCHAR2(20),
  mobile        VARCHAR2(20),
  email         VARCHAR2(20),
  address       VARCHAR2(64),
  note          CLOB,
  firmid        VARCHAR2(32),
  areaid        NUMBER(3),
  membertype    NUMBER(2) not null,
  timelimit     DATE,
  marketmanager VARCHAR2(20),
  modifytime    DATE
)
;
alter table BR_BROKER
  add constraint PK_BR_BROKER primary key (BROKERID);

prompt
prompt Creating table BR_BROKERAGE
prompt ===========================
prompt
create table BR_BROKERAGE
(
  brokerageid  VARCHAR2(32) not null,
  name         VARCHAR2(64) not null,
  idcard       VARCHAR2(32) not null,
  password     VARCHAR2(64) not null,
  telephone    VARCHAR2(20),
  mobile       VARCHAR2(20),
  email        VARCHAR2(20),
  address      VARCHAR2(64),
  postcode     VARCHAR2(16),
  note         CLOB,
  brokerid     VARCHAR2(16) not null,
  pbrokerageid VARCHAR2(32),
  creattime    DATE not null
)
;
alter table BR_BROKERAGE
  add constraint PK_BR_BROKERAGE primary key (BROKERAGEID);

prompt
prompt Creating table BR_BROKERAGEANDFIRM
prompt ==================================
prompt
create table BR_BROKERAGEANDFIRM
(
  brokerageid VARCHAR2(32) not null,
  firmid      VARCHAR2(32) not null,
  bindtype    NUMBER(2) not null,
  bindtime    DATE not null
)
;
alter table BR_BROKERAGEANDFIRM
  add constraint PK_BR_BROKERAGEANDFIRM primary key (BROKERAGEID, FIRMID);

prompt
prompt Creating table BR_BROKERAREA
prompt ============================
prompt
create table BR_BROKERAREA
(
  areaid NUMBER(3) not null,
  name   VARCHAR2(64) not null
)
;
alter table BR_BROKERAREA
  add constraint PK_BR_BROKERAREA primary key (AREAID);

prompt
prompt Creating table BR_BROKERMENU
prompt ============================
prompt
create table BR_BROKERMENU
(
  id             NUMBER(10) not null,
  parentid       NUMBER(10),
  name           VARCHAR2(128),
  icon           VARCHAR2(128),
  authorityurl   VARCHAR2(512),
  visiturl       VARCHAR2(512),
  moduleid       NUMBER(2) not null,
  seq            NUMBER(3),
  visible        NUMBER(1),
  type           NUMBER(1) not null,
  catalogid      NUMBER(4),
  iswritelog     VARCHAR2(1) default 'N',
  onlymember     NUMBER(2) default 0 not null,
  menubrokertype NUMBER(2) default 0 not null
)
;
alter table BR_BROKERMENU
  add constraint PK_BR_BROKERMENU primary key (ID);
alter table BR_BROKERMENU
  add constraint CHECK_BR_BROKERMENU_TYPE
  check (TYPE in (-3,-2,-1,0,1));
alter table BR_BROKERMENU
  add constraint CHECK_BR_BROKERMENU_VISIBLE
  check (VISIBLE in (-1,0));

prompt
prompt Creating table BR_BROKERREWARD
prompt ==============================
prompt
create table BR_BROKERREWARD
(
  brokerid   VARCHAR2(16) not null,
  occurdate  DATE not null,
  moduleid   NUMBER(2) not null,
  amount     NUMBER(15,2) not null,
  paidamount NUMBER(15,5) not null,
  paydate    DATE not null
)
;
alter table BR_BROKERREWARD
  add constraint PK_BR_BROKERREWARD primary key (BROKERID, OCCURDATE, MODULEID);

prompt
prompt Creating table BR_BROKERREWARDPROPS
prompt ===================================
prompt
create table BR_BROKERREWARDPROPS
(
  moduleid      NUMBER(2) not null,
  rewardtype    NUMBER(2) not null,
  brokerid      VARCHAR2(16) not null,
  commodityid   VARCHAR2(64) not null,
  rewardrate    NUMBER(6,4) not null,
  firstpayrate  NUMBER(6,4) default 0 not null,
  secondpayrate NUMBER(6,4) default 0 not null
)
;
alter table BR_BROKERREWARDPROPS
  add constraint PK_BR_BROKERREWARDPROPS primary key (MODULEID, REWARDTYPE, BROKERID, COMMODITYID);

prompt
prompt Creating table BR_BROKERRIGHT
prompt =============================
prompt
create table BR_BROKERRIGHT
(
  id       NUMBER(10) not null,
  brokerid VARCHAR2(16) not null
)
;
alter table BR_BROKERRIGHT
  add constraint PK_BR_BROKERRIGHT primary key (ID, BROKERID);

prompt
prompt Creating table BR_BROKERTYPE
prompt ============================
prompt
create table BR_BROKERTYPE
(
  borkertype NUMBER(2) not null,
  brokername VARCHAR2(64) not null
)
;
alter table BR_BROKERTYPE
  add constraint PK_BR_BROKERTYPE primary key (BORKERTYPE);

prompt
prompt Creating table BR_FIRMANDBROKER
prompt ===============================
prompt
create table BR_FIRMANDBROKER
(
  firmid   VARCHAR2(32) not null,
  brokerid VARCHAR2(16) not null,
  bindtime DATE not null
)
;
alter table BR_FIRMANDBROKER
  add constraint PK_BR_FIRMANDBROKER primary key (FIRMID);

prompt
prompt Creating table BR_FIRMAPPLY
prompt ===========================
prompt
create table BR_FIRMAPPLY
(
  applyid     NUMBER(10) not null,
  userid      VARCHAR2(32) not null,
  brokerageid VARCHAR2(32),
  brokerid    VARCHAR2(16) not null,
  applydate   DATE default sysdate
)
;
alter table BR_FIRMAPPLY
  add constraint PK_BR_FIRMAPPLY primary key (APPLYID);

prompt
prompt Creating table BR_REWARDPARAMETERPROPS
prompt ======================================
prompt
create table BR_REWARDPARAMETERPROPS
(
  autopay       CHAR(1),
  payperiod     NUMBER(1),
  payperioddate NUMBER(3)
)
;

prompt
prompt Creating table BR_TRADEMODULE
prompt =============================
prompt
create table BR_TRADEMODULE
(
  moduleid  NUMBER(2) not null,
  cnname    VARCHAR2(64) not null,
  enname    VARCHAR2(64),
  shortname VARCHAR2(16)
)
;
alter table BR_TRADEMODULE
  add constraint PK_BR_TRADEMODULE primary key (MODULEID);

prompt
prompt Creating table C_APPLY
prompt ======================
prompt
create table C_APPLY
(
  id          NUMBER(10) not null,
  applytype   VARCHAR2(32) not null,
  status      NUMBER(3) not null,
  content     VARCHAR2(2000) not null,
  note        VARCHAR2(1024),
  discribe    VARCHAR2(512),
  modtime     DATE,
  createtime  DATE not null,
  applyuser   VARCHAR2(32) not null,
  operatetype VARCHAR2(50) not null,
  entityclass VARCHAR2(1024) not null
)
;
comment on column C_APPLY.id
  is 'ID';
comment on column C_APPLY.applytype
  is '申请类型';
comment on column C_APPLY.status
  is '当前状态 0：待审核 1：审核通过 2：审核驳回 3：撤销申请';
comment on column C_APPLY.content
  is '内容';
comment on column C_APPLY.note
  is '备注';
comment on column C_APPLY.discribe
  is '描述';
comment on column C_APPLY.modtime
  is '修改时间';
comment on column C_APPLY.createtime
  is '创建时间';
comment on column C_APPLY.applyuser
  is '申请人';
comment on column C_APPLY.operatetype
  is '操作类型 update;add;delete;deleteCollection';
comment on column C_APPLY.entityclass
  is '业务对象类';
alter table C_APPLY
  add constraint PK_C_APPLY primary key (ID);

prompt
prompt Creating table C_AUDIT
prompt ======================
prompt
create table C_AUDIT
(
  id        NUMBER(10) not null,
  applyid   NUMBER(10) not null,
  status    NUMBER(3) not null,
  audituser VARCHAR2(32) not null,
  modtime   DATE default sysdate not null
)
;
comment on column C_AUDIT.id
  is 'ID';
comment on column C_AUDIT.applyid
  is '申请单ID';
comment on column C_AUDIT.status
  is '状态 1：审核通过 2：驳回申请';
comment on column C_AUDIT.audituser
  is '审核人';
comment on column C_AUDIT.modtime
  is '修改时间';
alter table C_AUDIT
  add constraint PK_C_AUDIT primary key (ID);

prompt
prompt Creating table C_DEPLOY_CONFIG
prompt ==============================
prompt
create table C_DEPLOY_CONFIG
(
  moduleid       NUMBER(2) not null,
  contextname    VARCHAR2(64) not null,
  serverpic      VARCHAR2(64) not null,
  serverpath     VARCHAR2(128),
  relativepath   VARCHAR2(128) not null,
  homepageaction VARCHAR2(128),
  welcomepage    VARCHAR2(128),
  welcomepic     VARCHAR2(64),
  systype        VARCHAR2(32) not null,
  sortno         NUMBER(2) default 1 not null
)
;
comment on column C_DEPLOY_CONFIG.moduleid
  is '角色Id';
comment on column C_DEPLOY_CONFIG.contextname
  is '系统名称';
comment on column C_DEPLOY_CONFIG.serverpic
  is '首页点击进入各个系统管理平台的点击图片';
comment on column C_DEPLOY_CONFIG.serverpath
  is '服务地址：eg  http://127.0.0.1:8080';
comment on column C_DEPLOY_CONFIG.relativepath
  is '公用系统点击进入各个系统管理平台的地相对址';
comment on column C_DEPLOY_CONFIG.homepageaction
  is '各个系统平台主页的Action';
comment on column C_DEPLOY_CONFIG.welcomepage
  is '跳转到各个系统首页的相对地址(只有前台才有主页)';
comment on column C_DEPLOY_CONFIG.welcomepic
  is '公用系统头部点击进入各个系统首页的图标展示(只有前台才有首页图标)';
comment on column C_DEPLOY_CONFIG.systype
  is '系统类型，mgr：后台  front：前台';
alter table C_DEPLOY_CONFIG
  add constraint PK_C_DELOY_CONFIG primary key (MODULEID, CONTEXTNAME);

prompt
prompt Creating table C_FRONT_MYMENU
prompt =============================
prompt
create table C_FRONT_MYMENU
(
  userid  VARCHAR2(12) not null,
  rightid NUMBER(10) not null
)
;
comment on column C_FRONT_MYMENU.userid
  is '管理员Id';
alter table C_FRONT_MYMENU
  add constraint PK_C_FRONT_MYMENU primary key (USERID, RIGHTID);

prompt
prompt Creating table C_FRONT_RIGHT
prompt ============================
prompt
create table C_FRONT_RIGHT
(
  id           NUMBER(10) not null,
  parentid     NUMBER(10),
  name         VARCHAR2(128),
  icon         VARCHAR2(128),
  authorityurl VARCHAR2(512),
  visiturl     VARCHAR2(512),
  moduleid     NUMBER(3),
  seq          NUMBER(3),
  visible      NUMBER(1),
  type         NUMBER(1) not null,
  catalogid    NUMBER(10),
  iswritelog   VARCHAR2(1) default 'N'
)
;
comment on column C_FRONT_RIGHT.id
  is ' 规范：
1：开头两位为系统模块号
2: 第三四位为一级菜单
3：第五六位为二级菜单
4：第七八位为三级菜单
5：第九十位为页面中的增删改查
';
comment on column C_FRONT_RIGHT.parentid
  is '父关联';
comment on column C_FRONT_RIGHT.name
  is '权限名称';
comment on column C_FRONT_RIGHT.icon
  is '图标';
comment on column C_FRONT_RIGHT.authorityurl
  is '权限路径';
comment on column C_FRONT_RIGHT.visiturl
  is '真实路径';
comment on column C_FRONT_RIGHT.moduleid
  is '模块Id';
comment on column C_FRONT_RIGHT.seq
  is '序号';
comment on column C_FRONT_RIGHT.visible
  is '是否可见-1 不可见0 可见';
comment on column C_FRONT_RIGHT.type
  is '类型-3:只检查session不检查权限的url -2：无需判断权限的URL -1： 父菜单类型 0：子菜单类型 1：页面内增删改查权限';
comment on column C_FRONT_RIGHT.catalogid
  is '日志类型 0不写日志 其它对应表c_logcatalog 的CATALOGID字段';
comment on column C_FRONT_RIGHT.iswritelog
  is '''Y''：写日志、''N''：不写日志';
alter table C_FRONT_RIGHT
  add constraint PK_C_FRONT_RIGHT primary key (ID);
alter table C_FRONT_RIGHT
  add constraint CHECK_C_FRONT_RIGHT_TYPE
  check (TYPE in (-3,-2,-1,0,1));
alter table C_FRONT_RIGHT
  add constraint CHECK_C_FRONT_RIGHT_VISIBLE
  check (VISIBLE in (-1,0));

prompt
prompt Creating table C_FRONT_ROLE
prompt ===========================
prompt
create table C_FRONT_ROLE
(
  id          NUMBER(10) not null,
  name        VARCHAR2(32) not null,
  description VARCHAR2(256)
)
;
comment on column C_FRONT_ROLE.id
  is '角色Id';
comment on column C_FRONT_ROLE.name
  is '角色名称';
comment on column C_FRONT_ROLE.description
  is '描述';
alter table C_FRONT_ROLE
  add constraint PK_C_FRONT_ROLE primary key (ID);

prompt
prompt Creating table C_FRONT_ROLE_RIGHT
prompt =================================
prompt
create table C_FRONT_ROLE_RIGHT
(
  rightid NUMBER(10) not null,
  roleid  NUMBER(10) not null
)
;
comment on column C_FRONT_ROLE_RIGHT.rightid
  is '权限Id
权限Id';
comment on column C_FRONT_ROLE_RIGHT.roleid
  is '角色Id';
alter table C_FRONT_ROLE_RIGHT
  add constraint PK_C_FRONT_ROLE_RIGHT primary key (RIGHTID, ROLEID);

prompt
prompt Creating table C_FRONT_USER_RIGHT
prompt =================================
prompt
create table C_FRONT_USER_RIGHT
(
  rightid NUMBER(10) not null,
  userid  VARCHAR2(12) not null
)
;
comment on column C_FRONT_USER_RIGHT.rightid
  is '权限Id
权限Id';
comment on column C_FRONT_USER_RIGHT.userid
  is '管理员Id';
alter table C_FRONT_USER_RIGHT
  add constraint PK_C_FRONT_USER_RIGHT primary key (RIGHTID, USERID);

prompt
prompt Creating table C_FRONT_USER_ROLE
prompt ================================
prompt
create table C_FRONT_USER_ROLE
(
  userid VARCHAR2(12) not null,
  roleid NUMBER(10) not null
)
;
comment on column C_FRONT_USER_ROLE.userid
  is '管理员Id';
comment on column C_FRONT_USER_ROLE.roleid
  is '角色Id
角色Id';
alter table C_FRONT_USER_ROLE
  add constraint PK_C_FRONT_USER_ROLE primary key (USERID, ROLEID);

prompt
prompt Creating table C_GLOBALLOG_ALL
prompt ==============================
prompt
create table C_GLOBALLOG_ALL
(
  id             NUMBER(15) not null,
  operator       VARCHAR2(32),
  operatetime    DATE default sysdate,
  operatetype    NUMBER(4),
  operateip      VARCHAR2(32),
  operatortype   VARCHAR2(32),
  mark           VARCHAR2(4000),
  operatecontent VARCHAR2(4000),
  currentvalue   VARCHAR2(4000),
  operateresult  NUMBER(1) default 0,
  logtype        NUMBER(2) default 0
)
;
comment on column C_GLOBALLOG_ALL.id
  is 'ID';
comment on column C_GLOBALLOG_ALL.operator
  is '操作人';
comment on column C_GLOBALLOG_ALL.operatetime
  is '操作时间';
comment on column C_GLOBALLOG_ALL.operatetype
  is '操作类型';
comment on column C_GLOBALLOG_ALL.operateip
  is '操作IP';
comment on column C_GLOBALLOG_ALL.operatortype
  is '操作人种类';
comment on column C_GLOBALLOG_ALL.mark
  is '标示';
comment on column C_GLOBALLOG_ALL.operatecontent
  is '操作内容';
comment on column C_GLOBALLOG_ALL.currentvalue
  is '当前值';
comment on column C_GLOBALLOG_ALL.operateresult
  is '操作结果 1 成功  0 失败';
comment on column C_GLOBALLOG_ALL.logtype
  is '0 其他，1 后台，2 前台，3 核心';
alter table C_GLOBALLOG_ALL
  add constraint PK_C_GLOBALLOG_ALL primary key (ID);
alter table C_GLOBALLOG_ALL
  add constraint GLBLOGALL
  check (operateresult in(0,1));

prompt
prompt Creating table C_GLOBALLOG_ALL_H
prompt ================================
prompt
create table C_GLOBALLOG_ALL_H
(
  id             NUMBER(15) not null,
  operator       VARCHAR2(32),
  operatetime    DATE,
  operatetype    NUMBER(4),
  operateip      VARCHAR2(32),
  operatortype   VARCHAR2(32),
  mark           VARCHAR2(4000),
  operatecontent VARCHAR2(4000),
  currentvalue   VARCHAR2(4000),
  operateresult  NUMBER(1) default 0,
  logtype        NUMBER(2)
)
;
comment on column C_GLOBALLOG_ALL_H.id
  is 'ID';
comment on column C_GLOBALLOG_ALL_H.operator
  is '操作人';
comment on column C_GLOBALLOG_ALL_H.operatetime
  is '操作时间';
comment on column C_GLOBALLOG_ALL_H.operatetype
  is '操作类型';
comment on column C_GLOBALLOG_ALL_H.operateip
  is '操作IP';
comment on column C_GLOBALLOG_ALL_H.operatortype
  is '操作人种类';
comment on column C_GLOBALLOG_ALL_H.mark
  is '标示';
comment on column C_GLOBALLOG_ALL_H.operatecontent
  is '操作内容';
comment on column C_GLOBALLOG_ALL_H.currentvalue
  is '当前值';
comment on column C_GLOBALLOG_ALL_H.operateresult
  is '操作结果 1 成功  0 失败';
comment on column C_GLOBALLOG_ALL_H.logtype
  is '0 其他，1 后台，2 前台，3 核心';
alter table C_GLOBALLOG_ALL_H
  add constraint GLBLOGALL_1
  check (operateresult in(0,1));

prompt
prompt Creating table C_LOGCATALOG
prompt ===========================
prompt
create table C_LOGCATALOG
(
  catalogid   NUMBER(4) not null,
  moduleid    NUMBER(2) not null,
  catalogname VARCHAR2(32)
)
;
comment on table C_LOGCATALOG
  is '日志分类，4位数字的编码，以日志模块ID开头。';
comment on column C_LOGCATALOG.catalogid
  is '日志分类ID：4位数字的编码，详见备注Notes。';
comment on column C_LOGCATALOG.moduleid
  is '10综合管理平台
11财务系统
12监管仓库管理系统
13仓单管理系统
14融资系统
15订单交易
18投资类大宗商品交易系统
19加盟会员管理系统
20做市商交易系统
21竞价系统
22银行接入及结算系统
23E现货
24单点登录系统
25实时行情分析系统
26交易客户端
98demo系统
99公用系统';
comment on column C_LOGCATALOG.catalogname
  is '日志分类名';
alter table C_LOGCATALOG
  add constraint PK_C_LOGCATALOG primary key (CATALOGID);

prompt
prompt Creating table C_MARKETINFO
prompt ===========================
prompt
create table C_MARKETINFO
(
  infoname  VARCHAR2(128) not null,
  infovalue VARCHAR2(128) not null
)
;
alter table C_MARKETINFO
  add constraint PK_C_MARKETINFO primary key (INFONAME, INFOVALUE);

prompt
prompt Creating table C_MYMENU
prompt =======================
prompt
create table C_MYMENU
(
  userid  VARCHAR2(32) not null,
  rightid NUMBER(10) not null
)
;
alter table C_MYMENU
  add constraint PK_C_MYMENU primary key (USERID, RIGHTID);

prompt
prompt Creating table C_RIGHT
prompt ======================
prompt
create table C_RIGHT
(
  id           NUMBER(10) not null,
  parentid     NUMBER(10),
  name         VARCHAR2(128),
  icon         VARCHAR2(128),
  authorityurl VARCHAR2(512),
  visiturl     VARCHAR2(512),
  moduleid     NUMBER(2) not null,
  seq          NUMBER(3),
  visible      NUMBER(1),
  type         NUMBER(1) not null,
  catalogid    NUMBER(4),
  iswritelog   VARCHAR2(1) default 'N'
)
;
comment on column C_RIGHT.id
  is ' 规范：
1：开头两位为系统模块号
2: 第三四位为一级菜单
3：第五六位为二级菜单
4：第七八位为三级菜单
5：第九十位为页面中的增删改查
';
comment on column C_RIGHT.parentid
  is '父关联';
comment on column C_RIGHT.name
  is '权限名称';
comment on column C_RIGHT.icon
  is '图标';
comment on column C_RIGHT.authorityurl
  is '权限路径';
comment on column C_RIGHT.visiturl
  is '真实路径';
comment on column C_RIGHT.moduleid
  is '10综合管理平台
11财务系统
12监管仓库管理系统
13仓单管理系统
14融资系统
15订单交易
18投资类大宗商品交易系统
19加盟会员管理系统
20做市商交易系统
21竞价系统
22银行接入及结算系统
23E现货
24单点登录系统
25实时行情分析系统
26交易客户端
98demo系统
99公用系统';
comment on column C_RIGHT.seq
  is '序号';
comment on column C_RIGHT.visible
  is '是否可见-1 不可见0 可见';
comment on column C_RIGHT.type
  is '类型-3:只检查session不检查权限的url -2：无需判断权限的URL -1： 父菜单类型 0：子菜单类型 1：页面内增删改查权限';
comment on column C_RIGHT.catalogid
  is '日志类型 0不写日志 其它对应表c_logcatalog 的CATALOGID字段';
comment on column C_RIGHT.iswritelog
  is '''Y''：写日志、''N''：不写日志';
alter table C_RIGHT
  add constraint PK_C_RIGHT primary key (ID);
alter table C_RIGHT
  add constraint CHECK_C_RIGHT_TYPE
  check (TYPE in (-3,-2,-1,0,1));
alter table C_RIGHT
  add constraint CHECK_C_RIGHT_VISIBLE
  check (VISIBLE in (-1,0));

prompt
prompt Creating table C_ROLE
prompt =====================
prompt
create table C_ROLE
(
  id          NUMBER(10) not null,
  name        VARCHAR2(32) not null,
  description VARCHAR2(256)
)
;
comment on column C_ROLE.id
  is '角色Id';
comment on column C_ROLE.name
  is '角色名称';
comment on column C_ROLE.description
  is '描述';
alter table C_ROLE
  add constraint PK_C_ROLE primary key (ID);

prompt
prompt Creating table C_ROLE_RIGHT
prompt ===========================
prompt
create table C_ROLE_RIGHT
(
  rightid NUMBER(10) not null,
  roleid  NUMBER(10) not null
)
;
comment on column C_ROLE_RIGHT.rightid
  is '权限Id';
comment on column C_ROLE_RIGHT.roleid
  is '角色Id';
alter table C_ROLE_RIGHT
  add constraint PK_C_ROLE_RIGHT primary key (RIGHTID, ROLEID);

prompt
prompt Creating table C_SUBMODULE
prompt ==========================
prompt
create table C_SUBMODULE
(
  moduleid       NUMBER(4) not null,
  cnname         VARCHAR2(64) not null,
  enname         VARCHAR2(64),
  shortname      VARCHAR2(16),
  hostip         VARCHAR2(16),
  port           NUMBER(6),
  rmidataport    NUMBER(6),
  parentmoduleid NUMBER(2) not null,
  remark         VARCHAR2(128)
)
;
comment on column C_SUBMODULE.moduleid
  is '此表为c_trademodule中的子模块配置表，模块ID不要与c_trademodule表中的模块ID重复';
alter table C_SUBMODULE
  add constraint PK_C_TRADEMODULE_1 primary key (MODULEID);

prompt
prompt Creating table C_TRADEMODULE
prompt ============================
prompt
create table C_TRADEMODULE
(
  moduleid           NUMBER(2) not null,
  cnname             VARCHAR2(64) not null,
  enname             VARCHAR2(64),
  shortname          VARCHAR2(16),
  addfirmfn          VARCHAR2(36),
  updatefirmstatusfn VARCHAR2(36),
  delfirmfn          VARCHAR2(36),
  isfirmset          CHAR(1) default 'N' not null,
  hostip             VARCHAR2(16),
  port               NUMBER(6),
  rmidataport        NUMBER(6),
  isbalancecheck     CHAR(1) default 'N' not null,
  isneedbreed        CHAR(1) not null
)
;
comment on column C_TRADEMODULE.moduleid
  is '10综合管理平台
11财务系统
12监管仓库管理系统
13仓单管理系统
14融资系统
15订单交易
18投资类大宗商品交易系统
19加盟会员管理系统
20做市商交易系统
21竞价系统
22银行接入及结算系统
23E现货
24单点登录系统
25实时行情分析系统
26交易客户端
98demo系统
99公用系统';
comment on column C_TRADEMODULE.isfirmset
  is '‘Y’ 是 ‘N’ 否 (如果需要在公用前台我的平台中显示本系统，还需要在公用系统的 spring_sys_msg.xml 中配置上本系统的配置信息)';
comment on column C_TRADEMODULE.isbalancecheck
  is 'Y：是 N：否';
comment on column C_TRADEMODULE.isneedbreed
  is '本系统是否需要综合管理平台增加的商品   Y:是   N:否';
alter table C_TRADEMODULE
  add constraint PK_C_TRADEMODULE primary key (MODULEID);

prompt
prompt Creating table C_USER
prompt =====================
prompt
create table C_USER
(
  id          VARCHAR2(32) not null,
  name        VARCHAR2(32),
  password    VARCHAR2(32),
  type        VARCHAR2(20) default 'ADMIN' not null,
  description VARCHAR2(256),
  isforbid    CHAR(1) default 'N' not null,
  skin        VARCHAR2(16) default 'default' not null,
  keycode     VARCHAR2(128) default '0123456789ABCDE' not null
)
;
comment on column C_USER.id
  is '管理员Id';
comment on column C_USER.name
  is '管理员名称';
comment on column C_USER.password
  is '密码';
comment on column C_USER.type
  is 'ADMIN：普通管理员角色DEFAULT_ADMIN：高级管理员角色DEFAULT_SUPER_ADMIN：默认超级管理员角色';
comment on column C_USER.description
  is '描述';
comment on column C_USER.isforbid
  is 'Y：禁用
N：不禁用
';
comment on column C_USER.skin
  is '皮肤';
comment on column C_USER.keycode
  is 'key';
alter table C_USER
  add constraint PK_C_USER primary key (ID);

prompt
prompt Creating table C_USER_RIGHT
prompt ===========================
prompt
create table C_USER_RIGHT
(
  rightid NUMBER(10) not null,
  userid  VARCHAR2(32) not null
)
;
comment on column C_USER_RIGHT.rightid
  is '权限Id
权限Id';
comment on column C_USER_RIGHT.userid
  is '管理员Id';
alter table C_USER_RIGHT
  add constraint PK_C_USER_RIGHT primary key (RIGHTID, USERID);

prompt
prompt Creating table C_USER_ROLE
prompt ==========================
prompt
create table C_USER_ROLE
(
  userid VARCHAR2(32) not null,
  roleid NUMBER(10) not null
)
;
comment on column C_USER_ROLE.userid
  is '管理员Id';
comment on column C_USER_ROLE.roleid
  is '角色Id';
alter table C_USER_ROLE
  add constraint PK_C_USER_ROLE primary key (USERID, ROLEID);

prompt
prompt Creating table C_XMLTEMPLATE
prompt ============================
prompt
create table C_XMLTEMPLATE
(
  id   NUMBER(12) not null,
  clob CLOB not null
)
;
alter table C_XMLTEMPLATE
  add primary key (ID);

prompt
prompt Creating table F_ACCOUNT
prompt ========================
prompt
create table F_ACCOUNT
(
  code         VARCHAR2(38) not null,
  name         VARCHAR2(64) not null,
  accountlevel NUMBER(2) not null,
  dcflag       CHAR(1) not null,
  isinit       CHAR(1) default 'Y' not null
)
;
comment on column F_ACCOUNT.dcflag
  is 'D:Debit 借
C:Credit 贷
';
comment on column F_ACCOUNT.isinit
  is 'Y:是初始化数据,页面不允许删除和修改
N:不是初始化数据';
alter table F_ACCOUNT
  add constraint PK_F_ACCOUNT primary key (CODE);

prompt
prompt Creating table F_ACCOUNTBOOK
prompt ============================
prompt
create table F_ACCOUNTBOOK
(
  b_date     DATE not null,
  summaryno  CHAR(5) not null,
  summary    VARCHAR2(32),
  voucherno  NUMBER(10) not null,
  contractno VARCHAR2(16),
  debitcode  VARCHAR2(38) not null,
  creditcode VARCHAR2(38) not null,
  amount     NUMBER(15,2) default 0 not null
)
;
create index IX_F_ACCOUNTBOOK_BD on F_ACCOUNTBOOK (B_DATE);
create index IX_F_ACCOUNTBOOK_C on F_ACCOUNTBOOK (CREDITCODE);
create index IX_F_ACCOUNTBOOK_D on F_ACCOUNTBOOK (DEBITCODE);

prompt
prompt Creating table F_BANKCLEARLEDGERCONFIG
prompt ======================================
prompt
create table F_BANKCLEARLEDGERCONFIG
(
  ledgercode VARCHAR2(16) not null,
  feetype    NUMBER(2) not null,
  fieldsign  NUMBER(1) not null
)
;
alter table F_BANKCLEARLEDGERCONFIG
  add constraint PK_F_BANKCLEARLEDGERCONFIG primary key (LEDGERCODE);

prompt
prompt Creating table F_B_BANKACCOUNT
prompt ==============================
prompt
create table F_B_BANKACCOUNT
(
  bankid       VARCHAR2(32) not null,
  account      VARCHAR2(32) not null,
  status       NUMBER(1) default 0 not null,
  accountname  VARCHAR2(100),
  bankname     VARCHAR2(128),
  bankprovince VARCHAR2(128),
  bankcity     VARCHAR2(128),
  mobile       VARCHAR2(32),
  email        VARCHAR2(128),
  cardtype     VARCHAR2(2) default 1 not null,
  card         VARCHAR2(32)
)
;
comment on table F_B_BANKACCOUNT
  is '工行银行帐户表';
comment on column F_B_BANKACCOUNT.bankid
  is '银行编号';
comment on column F_B_BANKACCOUNT.account
  is '银行帐号';
comment on column F_B_BANKACCOUNT.status
  is '状态(0 可用,1 冻结)';
comment on column F_B_BANKACCOUNT.accountname
  is '账户名';
comment on column F_B_BANKACCOUNT.bankname
  is '银行名称';
comment on column F_B_BANKACCOUNT.bankprovince
  is '银行省份';
comment on column F_B_BANKACCOUNT.bankcity
  is '银行所在市';
comment on column F_B_BANKACCOUNT.mobile
  is '电话号码';
comment on column F_B_BANKACCOUNT.email
  is '邮箱';
comment on column F_B_BANKACCOUNT.cardtype
  is '帐户类型(1 身份证,2军官证,3国内护照,4户口本,5学员证,6退休证,7临时身份证,8组织机构代码,9营业执照,A警官证,B解放军士兵证,C回乡证,D外国护照,E港澳台居民身份证,F台湾通行证及其他有效旅行证,G海外客户编号,H解放军文职干部证,I武警文职干部证,J武警士兵证,X其他有效证件,Z重号身份证)(主要用的是 1、8,有用 9 的 其它还没有用的';
comment on column F_B_BANKACCOUNT.card
  is '证件号码';

prompt
prompt Creating table F_B_BANKCAPITALRESULT
prompt ====================================
prompt
create table F_B_BANKCAPITALRESULT
(
  bankid     VARCHAR2(20) not null,
  firmid     VARCHAR2(20) not null,
  bankright  NUMBER(10,2) not null,
  maketright NUMBER(10,2) not null,
  reason     NUMBER,
  bdate      TIMESTAMP(6) not null
)
;
comment on table F_B_BANKCAPITALRESULT
  is '分分核对表';
comment on column F_B_BANKCAPITALRESULT.bankid
  is '银行编号';
comment on column F_B_BANKCAPITALRESULT.firmid
  is '交易商代码';
comment on column F_B_BANKCAPITALRESULT.bankright
  is '银行权益';
comment on column F_B_BANKCAPITALRESULT.maketright
  is '市场权益';
comment on column F_B_BANKCAPITALRESULT.reason
  is '不平原因(0金额不平 1银行端账户未建立 2机构端账户未建立)';
comment on column F_B_BANKCAPITALRESULT.bdate
  is '日期时间';
alter table F_B_BANKCAPITALRESULT
  add constraint PK_F_B_BANKCAPITALRESULT primary key (BANKID, FIRMID, BDATE);

prompt
prompt Creating table F_B_BANKCOMPAREINFO
prompt ==================================
prompt
create table F_B_BANKCOMPAREINFO
(
  id          NUMBER(12) not null,
  funid       VARCHAR2(100) not null,
  firmid      VARCHAR2(32),
  account     VARCHAR2(32) not null,
  type        NUMBER(1) not null,
  money       NUMBER(12,2) not null,
  comparedate DATE not null,
  note        VARCHAR2(128),
  createtime  DATE not null,
  status      NUMBER(1) not null,
  bankid      VARCHAR2(32) not null
)
;
comment on table F_B_BANKCOMPAREINFO
  is '银行对账信息表';
comment on column F_B_BANKCOMPAREINFO.id
  is '银行对账信息ID';
comment on column F_B_BANKCOMPAREINFO.funid
  is '银行流水号';
comment on column F_B_BANKCOMPAREINFO.firmid
  is '交易商代码';
comment on column F_B_BANKCOMPAREINFO.account
  is '交易商账号';
comment on column F_B_BANKCOMPAREINFO.type
  is '操作类型(0 入金,1 出金)';
comment on column F_B_BANKCOMPAREINFO.money
  is '金额';
comment on column F_B_BANKCOMPAREINFO.comparedate
  is '对账日期';
comment on column F_B_BANKCOMPAREINFO.note
  is '备注';
comment on column F_B_BANKCOMPAREINFO.createtime
  is '创建日期';
comment on column F_B_BANKCOMPAREINFO.status
  is '操作状态';
comment on column F_B_BANKCOMPAREINFO.bankid
  is '银行编号';
alter table F_B_BANKCOMPAREINFO
  add constraint PK_F_B_BANKCOMPAREINFO primary key (FUNID, BANKID, COMPAREDATE);

prompt
prompt Creating table F_B_BANKQSDATE
prompt =============================
prompt
create table F_B_BANKQSDATE
(
  bankid      VARCHAR2(32) not null,
  tradedate   DATE not null,
  tradetype   NUMBER(2),
  tradestatus NUMBER(2),
  note        VARCHAR2(32),
  createdate  DATE default sysdate not null
)
;
comment on table F_B_BANKQSDATE
  is '银行清算时间表';
comment on column F_B_BANKQSDATE.bankid
  is '银行编号';
comment on column F_B_BANKQSDATE.tradedate
  is '清算日期';
comment on column F_B_BANKQSDATE.tradetype
  is '清算类型';
comment on column F_B_BANKQSDATE.tradestatus
  is '清算状态(0 成功,1 失败)';
comment on column F_B_BANKQSDATE.note
  is '备注信息';
comment on column F_B_BANKQSDATE.createdate
  is '记录创建时间';

prompt
prompt Creating table F_B_BANKS
prompt ========================
prompt
create table F_B_BANKS
(
  bankid              VARCHAR2(32) not null,
  bankname            VARCHAR2(64) not null,
  maxpersgltransmoney NUMBER(12,2) not null,
  maxpertransmoney    NUMBER(12,2) not null,
  maxpertranscount    NUMBER(7) not null,
  adapterclassname    VARCHAR2(50) not null,
  validflag           NUMBER(1) not null,
  maxauditmoney       NUMBER(12,2),
  begintime           VARCHAR2(8) default '00:00:00',
  endtime             VARCHAR2(8) default '23:59:59',
  control             NUMBER(2) default 0
)
;
comment on table F_B_BANKS
  is '银行表';
comment on column F_B_BANKS.bankid
  is '银行编号';
comment on column F_B_BANKS.bankname
  is '银行名称';
comment on column F_B_BANKS.maxpersgltransmoney
  is '单笔最大转账金额';
comment on column F_B_BANKS.maxpertransmoney
  is '每日最大转账金额';
comment on column F_B_BANKS.maxpertranscount
  is '每日最大转账次数';
comment on column F_B_BANKS.adapterclassname
  is '适配器实现类名称';
comment on column F_B_BANKS.validflag
  is '银行状态(0 可用,1 不可用)';
comment on column F_B_BANKS.maxauditmoney
  is '当个银行出金审核额度';
comment on column F_B_BANKS.begintime
  is '银行起始转账时间';
comment on column F_B_BANKS.endtime
  is '银行结束转账时间';
comment on column F_B_BANKS.control
  is '是否受到交易日和交易时间的约束 (0 受双重约束,1 不受约束,2 受交易日约束,3 受交易时间约束)';
alter table F_B_BANKS
  add constraint PK_F_B_BANKS primary key (BANKID);

prompt
prompt Creating table F_B_BANKTRANSFER
prompt ===============================
prompt
create table F_B_BANKTRANSFER
(
  id         NUMBER(12) not null,
  paybankid  VARCHAR2(32) not null,
  recbankid  VARCHAR2(32) not null,
  money      NUMBER(15,2) default 0.00 not null,
  moneytype  VARCHAR2(2) default 0,
  funid      VARCHAR2(100),
  maerketid  VARCHAR2(100),
  note       VARCHAR2(100),
  status     NUMBER(2) not null,
  createtime TIMESTAMP(6) not null,
  updatetime TIMESTAMP(6) not null
)
;
comment on table F_B_BANKTRANSFER
  is '工行银行转账表';
comment on column F_B_BANKTRANSFER.paybankid
  is '转出银行ID银行编号';
comment on column F_B_BANKTRANSFER.recbankid
  is '转转入银行ID银行编号';
comment on column F_B_BANKTRANSFER.money
  is '冻结资金';
comment on column F_B_BANKTRANSFER.moneytype
  is '0为人民币';
comment on column F_B_BANKTRANSFER.funid
  is '银行流水号';
comment on column F_B_BANKTRANSFER.maerketid
  is '银行流水号';
comment on column F_B_BANKTRANSFER.status
  is '0 成功,1 失败,2 处理中,3 一次审核,4 二次审核,5 银行返回信息为空,6 银行返回市场流水号和市场保存流水号不一致,13 市场假银行出入金待审核状态';

prompt
prompt Creating table F_B_BATCUSTFILE
prompt ==============================
prompt
create table F_B_BATCUSTFILE
(
  custacctid   VARCHAR2(32) not null,
  custname     VARCHAR2(120),
  thirdcustid  VARCHAR2(32),
  bankbalance  NUMBER(18,2),
  bankfrozen   NUMBER(18,2),
  maketbalance NUMBER(18,2),
  maketfrozen  NUMBER(18,2),
  balanceerror NUMBER(18,2),
  frozenerror  NUMBER(18,2),
  tradedate    DATE not null,
  bankid       VARCHAR2(32),
  createdate   DATE default sysdate,
  note         VARCHAR2(120)
)
;
comment on table F_B_BATCUSTFILE
  is '对账不平记录';
comment on column F_B_BATCUSTFILE.custacctid
  is '子账号';
comment on column F_B_BATCUSTFILE.custname
  is '名称';
comment on column F_B_BATCUSTFILE.thirdcustid
  is '会员代码';
comment on column F_B_BATCUSTFILE.bankbalance
  is '银行清算后可用余额';
comment on column F_B_BATCUSTFILE.bankfrozen
  is '银行清算后冻结余额';
comment on column F_B_BATCUSTFILE.maketbalance
  is '交易网可用余额';
comment on column F_B_BATCUSTFILE.maketfrozen
  is '交易网冻结余额';
comment on column F_B_BATCUSTFILE.balanceerror
  is '可用余额差额（银行可用余额-交易网可用余额）';
comment on column F_B_BATCUSTFILE.frozenerror
  is '冻结余额差额（银行冻结余额-交易网冻结余额）';
comment on column F_B_BATCUSTFILE.tradedate
  is '交易时间';
comment on column F_B_BATCUSTFILE.bankid
  is '银行编号';
comment on column F_B_BATCUSTFILE.createdate
  is '创建日期';
comment on column F_B_BATCUSTFILE.note
  is '备注信息';
alter table F_B_BATCUSTFILE
  add constraint PK_F_B_BATCUSTFILE primary key (CUSTACCTID, TRADEDATE);

prompt
prompt Creating table F_B_CAPITALINFO
prompt ==============================
prompt
create table F_B_CAPITALINFO
(
  id         NUMBER(12) not null,
  firmid     VARCHAR2(32) not null,
  funid      VARCHAR2(100),
  bankid     VARCHAR2(32) not null,
  debitid    VARCHAR2(32) not null,
  creditid   VARCHAR2(32) not null,
  type       NUMBER(2) not null,
  money      NUMBER(12,2) not null,
  operator   VARCHAR2(32),
  createtime DATE not null,
  banktime   DATE,
  status     NUMBER(2) not null,
  note       VARCHAR2(128),
  actionid   NUMBER(12) not null,
  express    NUMBER(1) default 0,
  bankname   VARCHAR2(50),
  account    VARCHAR2(21),
  createdate VARCHAR2(32) not null,
  funid2     VARCHAR2(100) not null
)
;
comment on table F_B_CAPITALINFO
  is '市场流水表';
comment on column F_B_CAPITALINFO.id
  is '流水ID';
comment on column F_B_CAPITALINFO.firmid
  is '交易商代码';
comment on column F_B_CAPITALINFO.funid
  is '银行流水号';
comment on column F_B_CAPITALINFO.bankid
  is '银行编号';
comment on column F_B_CAPITALINFO.debitid
  is '贷方代码';
comment on column F_B_CAPITALINFO.creditid
  is '借方代码';
comment on column F_B_CAPITALINFO.type
  is '流水类型(0 入金,1 出金,2出入金手续费';
comment on column F_B_CAPITALINFO.money
  is '流水金额';
comment on column F_B_CAPITALINFO.operator
  is '业务代码';
comment on column F_B_CAPITALINFO.createtime
  is '创建时间';
comment on column F_B_CAPITALINFO.banktime
  is '银行事件';
comment on column F_B_CAPITALINFO.status
  is '状态(0 成功,1 失败,2 处理中,3 一次审核,4 二次审核,5 银行返回信息为空,6 银行返回市场流水号和市场保存流水号不一致,13 市场假银行出入金待审核状态)';
comment on column F_B_CAPITALINFO.note
  is '备注信息';
comment on column F_B_CAPITALINFO.actionid
  is '业务流水';
comment on column F_B_CAPITALINFO.express
  is '是否加急';
comment on column F_B_CAPITALINFO.bankname
  is '特殊加的(银行名称)';
comment on column F_B_CAPITALINFO.account
  is '特殊加的(银行账号)';
comment on column F_B_CAPITALINFO.createdate
  is '创建时间';
comment on column F_B_CAPITALINFO.funid2
  is '流水2';
alter table F_B_CAPITALINFO
  add constraint PK_F_B_CAPITALINFO primary key (BANKID, TYPE, CREATEDATE, FUNID2);

prompt
prompt Creating table F_B_DICTIONARY
prompt =============================
prompt
create table F_B_DICTIONARY
(
  id     NUMBER(5) not null,
  type   NUMBER(5) not null,
  bankid VARCHAR2(32),
  name   VARCHAR2(128) not null,
  value  VARCHAR2(128),
  note   VARCHAR2(256) not null
)
;
comment on table F_B_DICTIONARY
  is '字典表';
comment on column F_B_DICTIONARY.id
  is '字典ID';
comment on column F_B_DICTIONARY.type
  is '类型';
comment on column F_B_DICTIONARY.bankid
  is '银行编号';
comment on column F_B_DICTIONARY.name
  is '字典名';
comment on column F_B_DICTIONARY.value
  is '字典值';
comment on column F_B_DICTIONARY.note
  is '备注';
alter table F_B_DICTIONARY
  add constraint PK_F_B_DICTIONARY primary key (ID);

prompt
prompt Creating table F_B_FEEINFO
prompt ==========================
prompt
create table F_B_FEEINFO
(
  id           NUMBER(12) not null,
  uplimit      NUMBER(12,2) not null,
  downlimit    NUMBER(12,2) not null,
  tmode        NUMBER(1) not null,
  rate         NUMBER not null,
  type         VARCHAR2(128) not null,
  createtime   DATE default SYSDATE,
  updatetime   DATE,
  userid       VARCHAR2(12) not null,
  maxratevalue NUMBER,
  minratevalue NUMBER
)
;
comment on table F_B_FEEINFO
  is '标准费用表';
comment on column F_B_FEEINFO.id
  is '费用列表ID';
comment on column F_B_FEEINFO.uplimit
  is '结束金额';
comment on column F_B_FEEINFO.downlimit
  is '起始金额';
comment on column F_B_FEEINFO.tmode
  is '计算放肆(0 百分比,2 绝对值)';
comment on column F_B_FEEINFO.rate
  is '手续费';
comment on column F_B_FEEINFO.type
  is '收费类型';
comment on column F_B_FEEINFO.createtime
  is '记录时间';
comment on column F_B_FEEINFO.updatetime
  is '修改时间';
comment on column F_B_FEEINFO.userid
  is '用户ID(记录人,交易商,银行)';
comment on column F_B_FEEINFO.maxratevalue
  is '最大金额';
comment on column F_B_FEEINFO.minratevalue
  is '最小金额';
alter table F_B_FEEINFO
  add constraint PK_F_B_FEEINFO primary key (UPLIMIT, DOWNLIMIT, USERID, TYPE);

prompt
prompt Creating table F_B_FFHD
prompt =======================
prompt
create table F_B_FFHD
(
  bankid      VARCHAR2(32) not null,
  tradedate   DATE not null,
  firmid      VARCHAR2(32) not null,
  account     VARCHAR2(32) not null,
  currency    VARCHAR2(10) default '001' not null,
  type        NUMBER(2) default 0 not null,
  reasion     NUMBER(2) default 0 not null,
  balancem    NUMBER(15,2),
  cashm       NUMBER(15,2),
  billm       NUMBER(15,2),
  usebalancem NUMBER(15,2),
  frozencashm NUMBER(15,2),
  frozenloanm NUMBER(15,2),
  balanceb    NUMBER(15,2),
  cashb       NUMBER(15,2),
  billb       NUMBER(15,2),
  usebalanceb NUMBER(15,2),
  frozencashb NUMBER(15,2),
  frozenloanb NUMBER(15,2),
  createdate  DATE default sysdate not null
)
;
comment on table F_B_FFHD
  is '分分核对表';
comment on column F_B_FFHD.bankid
  is '银行编号';
comment on column F_B_FFHD.tradedate
  is '交易日期';
comment on column F_B_FFHD.firmid
  is '交易商编号';
comment on column F_B_FFHD.account
  is '交易商银行账号';
comment on column F_B_FFHD.currency
  is '币别 (001：人民币 013：港币 014：美元)';
comment on column F_B_FFHD.type
  is '钞汇标识 (0：钞 1：汇)';
comment on column F_B_FFHD.reasion
  is '不平原因 (0:金额不平 1:银行端资金存管账户未建立 2:市场端交易商代码不存在)';
comment on column F_B_FFHD.balancem
  is '市场总权益';
comment on column F_B_FFHD.cashm
  is '市场现金权益';
comment on column F_B_FFHD.billm
  is '市场票据权益';
comment on column F_B_FFHD.usebalancem
  is '市场可用资金';
comment on column F_B_FFHD.frozencashm
  is '市场占用现金';
comment on column F_B_FFHD.frozenloanm
  is '市场占用贷款金额';
comment on column F_B_FFHD.balanceb
  is '银行总权益';
comment on column F_B_FFHD.cashb
  is '银行现金权益';
comment on column F_B_FFHD.billb
  is '银行票据权益';
comment on column F_B_FFHD.usebalanceb
  is '银行可用资金';
comment on column F_B_FFHD.frozencashb
  is '银行占用现金';
comment on column F_B_FFHD.frozenloanb
  is '银行占用贷款金额';
comment on column F_B_FFHD.createdate
  is '创建时间';
alter table F_B_FFHD
  add constraint PK_F_B_FFHD primary key (BANKID, TRADEDATE, FIRMID);

prompt
prompt Creating table F_B_FIRMBALANCE
prompt ==============================
prompt
create table F_B_FIRMBALANCE
(
  custacctid    VARCHAR2(32) not null,
  custname      VARCHAR2(120),
  thirdcustid   VARCHAR2(32),
  status        NUMBER(2),
  type          NUMBER(2),
  istruecont    NUMBER(2),
  balance       NUMBER(18,2),
  usrbalance    NUMBER(18,2),
  frozenbalance NUMBER(18,2),
  interest      NUMBER(18,2),
  bankid        VARCHAR2(32),
  tradedate     DATE not null,
  createdate    DATE
)
;
comment on table F_B_FIRMBALANCE
  is '会员余额记录';
comment on column F_B_FIRMBALANCE.custacctid
  is '子账号';
comment on column F_B_FIRMBALANCE.custname
  is '账户名';
comment on column F_B_FIRMBALANCE.thirdcustid
  is '会员代码';
comment on column F_B_FIRMBALANCE.status
  is '状态(1：正常  2：退出  3：待确定)';
comment on column F_B_FIRMBALANCE.type
  is '账号属性(1：普通会员子账号  2：挂账子账号  3：手续费子账号  4：利息子账号  6：清算子账号)';
comment on column F_B_FIRMBALANCE.istruecont
  is '是否实子账号(默认为 1：虚子账号)';
comment on column F_B_FIRMBALANCE.balance
  is '总额';
comment on column F_B_FIRMBALANCE.usrbalance
  is '可用余额';
comment on column F_B_FIRMBALANCE.frozenbalance
  is '冻结资金';
comment on column F_B_FIRMBALANCE.interest
  is '利息基数';
comment on column F_B_FIRMBALANCE.bankid
  is '银行代码';
comment on column F_B_FIRMBALANCE.tradedate
  is '交易日期';
comment on column F_B_FIRMBALANCE.createdate
  is '信息创建时间';
alter table F_B_FIRMBALANCE
  add constraint PK_F_B_FIRMBALANCE primary key (CUSTACCTID, TRADEDATE);

prompt
prompt Creating table F_B_FIRMBALANCEERROR
prompt ===================================
prompt
create table F_B_FIRMBALANCEERROR
(
  trandatetime    DATE not null,
  counterid       VARCHAR2(12),
  supacctid       VARCHAR2(32),
  funccode        VARCHAR2(4),
  custacctid      VARCHAR2(32) not null,
  custname        VARCHAR2(120),
  thirdcustid     VARCHAR2(32),
  thirdlogno      VARCHAR2(20),
  ccycode         VARCHAR2(3),
  freezeamount    NUMBER(18,2),
  unfreezeamount  NUMBER(18,2),
  addtranamount   NUMBER(18,2),
  cuttranamount   NUMBER(18,2),
  profitamount    NUMBER(18,2),
  lossamount      NUMBER(18,2),
  tranhandfee     NUMBER(18,2),
  trancount       NUMBER(30),
  newbalance      NUMBER(18,2),
  newfreezeamount NUMBER(18,2),
  note            VARCHAR2(120),
  reserve         VARCHAR2(120),
  rspcode         VARCHAR2(6),
  rspmsg          VARCHAR2(256),
  bankid          VARCHAR2(32),
  createtime      DATE
)
;
comment on table F_B_FIRMBALANCEERROR
  is '银行对账失败文件';
comment on column F_B_FIRMBALANCEERROR.trandatetime
  is '交易时间';
comment on column F_B_FIRMBALANCEERROR.counterid
  is '操作员';
comment on column F_B_FIRMBALANCEERROR.supacctid
  is '资金汇总帐号';
comment on column F_B_FIRMBALANCEERROR.funccode
  is '功能代码';
comment on column F_B_FIRMBALANCEERROR.custacctid
  is '子账户账号';
comment on column F_B_FIRMBALANCEERROR.custname
  is '子账户名称';
comment on column F_B_FIRMBALANCEERROR.thirdcustid
  is '交易网会员代码';
comment on column F_B_FIRMBALANCEERROR.thirdlogno
  is '交易网流水号';
comment on column F_B_FIRMBALANCEERROR.ccycode
  is '币种';
comment on column F_B_FIRMBALANCEERROR.freezeamount
  is '当天总冻结资金';
comment on column F_B_FIRMBALANCEERROR.unfreezeamount
  is '当天总解冻资金';
comment on column F_B_FIRMBALANCEERROR.addtranamount
  is '当天成交的总货款(卖方)';
comment on column F_B_FIRMBALANCEERROR.cuttranamount
  is '当天成交的总货款(买方)';
comment on column F_B_FIRMBALANCEERROR.profitamount
  is '盈利总金额';
comment on column F_B_FIRMBALANCEERROR.lossamount
  is '亏损总金额';
comment on column F_B_FIRMBALANCEERROR.tranhandfee
  is '交易商当天应付给交易网的手续费';
comment on column F_B_FIRMBALANCEERROR.trancount
  is '当天交易总比数';
comment on column F_B_FIRMBALANCEERROR.newbalance
  is '交易网端最新的交易商可用金额';
comment on column F_B_FIRMBALANCEERROR.newfreezeamount
  is '交易网端最新的冻结资金';
comment on column F_B_FIRMBALANCEERROR.note
  is '说明';
comment on column F_B_FIRMBALANCEERROR.reserve
  is '保留域';
comment on column F_B_FIRMBALANCEERROR.rspcode
  is '错误码';
comment on column F_B_FIRMBALANCEERROR.rspmsg
  is '应答描述';
comment on column F_B_FIRMBALANCEERROR.bankid
  is '银行代码';
comment on column F_B_FIRMBALANCEERROR.createtime
  is '信息创建时间';
alter table F_B_FIRMBALANCEERROR
  add constraint PK_F_B_FIRMBALANCEERROR primary key (TRANDATETIME, CUSTACCTID);

prompt
prompt Creating table F_B_FIRMIDANDACCOUNT
prompt ===================================
prompt
create table F_B_FIRMIDANDACCOUNT
(
  bankid       VARCHAR2(32) not null,
  firmid       VARCHAR2(32) not null,
  account      VARCHAR2(32) not null,
  account1     VARCHAR2(32),
  status       NUMBER(1) default 0 not null,
  accountname  VARCHAR2(100),
  bankname     VARCHAR2(128),
  bankprovince VARCHAR2(128),
  bankcity     VARCHAR2(128),
  mobile       VARCHAR2(32),
  email        VARCHAR2(128),
  isopen       NUMBER(1) default 1 not null,
  cardtype     VARCHAR2(2) default 1 not null,
  card         VARCHAR2(32),
  frozenfuns   NUMBER(15,2) default 0.00 not null,
  accountname1 VARCHAR2(100),
  opentime     DATE,
  deltime      DATE,
  inmarketcode VARCHAR2(120)
)
;
comment on table F_B_FIRMIDANDACCOUNT
  is '交易商银行账号对应表';
comment on column F_B_FIRMIDANDACCOUNT.bankid
  is '银行编号';
comment on column F_B_FIRMIDANDACCOUNT.firmid
  is '交易商代码';
comment on column F_B_FIRMIDANDACCOUNT.account
  is '银行帐号';
comment on column F_B_FIRMIDANDACCOUNT.account1
  is '银行内部账号';
comment on column F_B_FIRMIDANDACCOUNT.status
  is '状态(0 可用,1 冻结)';
comment on column F_B_FIRMIDANDACCOUNT.accountname
  is '账户名';
comment on column F_B_FIRMIDANDACCOUNT.bankname
  is '银行名称';
comment on column F_B_FIRMIDANDACCOUNT.bankprovince
  is '银行省份';
comment on column F_B_FIRMIDANDACCOUNT.bankcity
  is '银行所在市';
comment on column F_B_FIRMIDANDACCOUNT.mobile
  is '电话号码';
comment on column F_B_FIRMIDANDACCOUNT.email
  is '邮箱';
comment on column F_B_FIRMIDANDACCOUNT.isopen
  is '是否已签约(0 未签约,1 已签约)';
comment on column F_B_FIRMIDANDACCOUNT.cardtype
  is '--帐户类型(1 身份证,2军官证,3国内护照,4户口本,5学员证,6退休证,7临时身份证,8组织机构代码,9营业执照,A警官证,B解放军士兵证,C回乡证,D外国护照,E港澳台居民身份证,F台湾通行证及其他有效旅行证,G海外客户编号,H解放军文职干部证,I武警文职干部证,J武警士兵证,X其他有效证件,Z重号身份证)(主要用的是 1、8,有用 9 的 其它还没有用的)';
comment on column F_B_FIRMIDANDACCOUNT.card
  is '证件号码';
comment on column F_B_FIRMIDANDACCOUNT.frozenfuns
  is '冻结资金';
comment on column F_B_FIRMIDANDACCOUNT.accountname1
  is '银行内部账户名称';
comment on column F_B_FIRMIDANDACCOUNT.opentime
  is '开户时间';
comment on column F_B_FIRMIDANDACCOUNT.inmarketcode
  is '交易商入世协议号';
alter table F_B_FIRMIDANDACCOUNT
  add constraint PK_F_B_FIRMIDANDACCOUNT primary key (BANKID, FIRMID);

prompt
prompt Creating table F_B_FIRMKXH
prompt ==========================
prompt
create table F_B_FIRMKXH
(
  funid        VARCHAR2(32) not null,
  status       NUMBER(2) not null,
  account1     VARCHAR2(32) not null,
  type         NUMBER(1) not null,
  account1name VARCHAR2(120) not null,
  firmid       VARCHAR2(32) not null,
  tradedate    DATE not null,
  counterid    VARCHAR2(12),
  bankid       VARCHAR2(32),
  createdate   DATE default sysdate    --记录创建日期
)
;
comment on table F_B_FIRMKXH
  is '当天会员开销户信息表';
comment on column F_B_FIRMKXH.funid
  is '银行前置流水号';
comment on column F_B_FIRMKXH.status
  is '交易状态(1：开户 2：销户 3：待确认)';
comment on column F_B_FIRMKXH.account1
  is '会员子账号';
comment on column F_B_FIRMKXH.type
  is '子账户性质';
comment on column F_B_FIRMKXH.account1name
  is '子账户名称';
comment on column F_B_FIRMKXH.firmid
  is '交易商代码';
comment on column F_B_FIRMKXH.tradedate
  is '交易日期';
comment on column F_B_FIRMKXH.counterid
  is '操作柜员号';
comment on column F_B_FIRMKXH.bankid
  is '银行代码';
comment on column F_B_FIRMKXH.createdate
  is '记录创建日期';
alter table F_B_FIRMKXH
  add constraint PK_F_B_FIRMKXH primary key (FUNID, TRADEDATE);

prompt
prompt Creating table F_B_FIRMTRADESTATUS
prompt ==================================
prompt
create table F_B_FIRMTRADESTATUS
(
  bankid      VARCHAR2(20) not null,
  dealid      VARCHAR2(20) not null,
  cobrn       VARCHAR2(20),
  txdate      VARCHAR2(20) not null,
  bankacc     VARCHAR2(32) not null,
  fundacc     VARCHAR2(32) not null,
  custname    VARCHAR2(100) not null,
  curcode     VARCHAR2(10) not null,
  status      VARCHAR2(10) not null,
  comparedate DATE not null
)
;
comment on table F_B_FIRMTRADESTATUS
  is '客户协议状态（增量）对账表';
comment on column F_B_FIRMTRADESTATUS.bankid
  is '银行id';
comment on column F_B_FIRMTRADESTATUS.dealid
  is '市场组织机构代码';
comment on column F_B_FIRMTRADESTATUS.cobrn
  is '合作方机构号';
comment on column F_B_FIRMTRADESTATUS.txdate
  is '交易日期';
comment on column F_B_FIRMTRADESTATUS.bankacc
  is '银行账号';
comment on column F_B_FIRMTRADESTATUS.fundacc
  is '交易商代码';
comment on column F_B_FIRMTRADESTATUS.custname
  is '交易商姓名';
comment on column F_B_FIRMTRADESTATUS.curcode
  is '币种';
comment on column F_B_FIRMTRADESTATUS.status
  is '状态';
comment on column F_B_FIRMTRADESTATUS.comparedate
  is '对账日期';
alter table F_B_FIRMTRADESTATUS
  add constraint F_B_FIRMTRADESTATUS primary key (BANKID, BANKACC, COMPAREDATE);

prompt
prompt Creating table F_B_FIRMUSER
prompt ===========================
prompt
create table F_B_FIRMUSER
(
  firmid              VARCHAR2(32) not null,
  name                VARCHAR2(64),
  maxpersgltransmoney NUMBER(12,2),
  maxpertransmoney    NUMBER(12,2),
  maxpertranscount    NUMBER(7),
  status              NUMBER(1) not null,
  registerdate        DATE not null,
  logoutdate          DATE,
  maxauditmoney       NUMBER(12,2),
  password            VARCHAR2(64)
)
;
comment on table F_B_FIRMUSER
  is '银行接口部分用户表';
comment on column F_B_FIRMUSER.firmid
  is '交易商代码';
comment on column F_B_FIRMUSER.name
  is '交易商名称';
comment on column F_B_FIRMUSER.maxpersgltransmoney
  is '单笔最大转账金额';
comment on column F_B_FIRMUSER.maxpertransmoney
  is '每天最大转账金额';
comment on column F_B_FIRMUSER.maxpertranscount
  is '每天最大转账次数';
comment on column F_B_FIRMUSER.status
  is '交易商状态(0 已注册,1 禁用或未注册,2注销)';
comment on column F_B_FIRMUSER.registerdate
  is '注册日期';
comment on column F_B_FIRMUSER.logoutdate
  is '注销日期';
comment on column F_B_FIRMUSER.maxauditmoney
  is '审核额度';
comment on column F_B_FIRMUSER.password
  is '密码';
alter table F_B_FIRMUSER
  add constraint PK_F_B_FIRMUSER primary key (FIRMID);

prompt
prompt Creating table F_B_HXQS
prompt =======================
prompt
create table F_B_HXQS
(
  bankid     VARCHAR2(32) not null,
  firmid     VARCHAR2(32) not null,
  tradedate  DATE not null,
  money      NUMBER(15,2) not null,
  type       NUMBER(2) not null,
  tradetype  NUMBER(2) not null,
  note       VARCHAR2(120),
  createdate DATE default sysdate not null,
  status     NUMBER(2)
)
;
comment on table F_B_HXQS
  is '添加华夏清算表';
comment on column F_B_HXQS.bankid
  is '银行编号';
comment on column F_B_HXQS.firmid
  is '交易商编号';
comment on column F_B_HXQS.tradedate
  is '清算日期';
comment on column F_B_HXQS.money
  is '金额';
comment on column F_B_HXQS.type
  is '借贷标示 (1:借，资金减少 2:贷，资金增减)';
comment on column F_B_HXQS.tradetype
  is '资金类型';
comment on column F_B_HXQS.note
  is '备注信息';
comment on column F_B_HXQS.createdate
  is '数据写入时间';
comment on column F_B_HXQS.status
  is '当前状态(0:成功 1:失败 2:情况未知)';
alter table F_B_HXQS
  add constraint PK_F_B_HXQS primary key (BANKID, FIRMID, TRADEDATE);

prompt
prompt Creating table F_B_INTERFACELOG
prompt ===============================
prompt
create table F_B_INTERFACELOG
(
  logid      NUMBER(12) not null,
  bankid     VARCHAR2(32) not null,
  launcher   NUMBER(2) not null,
  type       NUMBER(2) not null,
  contact    VARCHAR2(32),
  account    VARCHAR2(32),
  beginmsg   VARCHAR2(512),
  endmsg     VARCHAR2(512),
  result     NUMBER(2) default 0 not null,
  createtime DATE default sysdate not null
)
;
comment on column F_B_INTERFACELOG.bankid
  is '银行代码
银行代码';
comment on column F_B_INTERFACELOG.launcher
  is '发起方
0 市场
1 银行';
comment on column F_B_INTERFACELOG.type
  is '交易类型
1 签到
2 签退
3 签约
4 解约
5 查询余额
6 出金
7 入金
8 冲正';
alter table F_B_INTERFACELOG
  add constraint PK_F_B_INTERFACELOG primary key (LOGID);
alter table F_B_INTERFACELOG
  add constraint REFF_B_BANKS235 foreign key (BANKID)
  references F_B_BANKS (BANKID)
  disable
  novalidate;

prompt
prompt Creating table F_B_LOG
prompt ======================
prompt
create table F_B_LOG
(
  logid      NUMBER not null,
  logopr     VARCHAR2(50) not null,
  logcontent VARCHAR2(4000) not null,
  logdate    DATE not null,
  logip      VARCHAR2(20)
)
;
comment on table F_B_LOG
  is '银行接口部分操作日指标';
comment on column F_B_LOG.logid
  is '日志编号';
comment on column F_B_LOG.logopr
  is '操作员';
comment on column F_B_LOG.logcontent
  is '操作内容';
comment on column F_B_LOG.logdate
  is '日志记录日期';
comment on column F_B_LOG.logip
  is '日志记录登录机器';
alter table F_B_LOG
  add constraint PK_F_B_LOG primary key (LOGID);

prompt
prompt Creating table F_B_MAKETMONEY
prompt =============================
prompt
create table F_B_MAKETMONEY
(
  id         NUMBER(15) not null,
  bankid     VARCHAR2(32) not null,
  banknumber VARCHAR2(50),
  type       NUMBER(2) not null,
  adddelt    NUMBER(2) not null,
  money      NUMBER(15,2) not null,
  note       VARCHAR2(120),
  createtime DATE default sysdate   --创建时间
)
;
comment on table F_B_MAKETMONEY
  is '添加市场自有资金利息表';
comment on column F_B_MAKETMONEY.id
  is '自有资金编号';
comment on column F_B_MAKETMONEY.bankid
  is '银行编号';
comment on column F_B_MAKETMONEY.banknumber
  is ' 银行转账号';
comment on column F_B_MAKETMONEY.type
  is '资金类型 (1:手续费,2:利息)';
comment on column F_B_MAKETMONEY.adddelt
  is '增加、减少资金(1:增加 2:减少)';
comment on column F_B_MAKETMONEY.money
  is '增加、减少金额额度';
comment on column F_B_MAKETMONEY.note
  is '备注信息';
comment on column F_B_MAKETMONEY.createtime
  is '创建时间';
alter table F_B_MAKETMONEY
  add constraint PK_F_B_MAKETMONEY primary key (ID);

prompt
prompt Creating table F_B_MARGINS
prompt ==========================
prompt
create table F_B_MARGINS
(
  serial_id     VARCHAR2(15) not null,
  bargain_code  VARCHAR2(10) not null,
  trade_type    VARCHAR2(1),
  trade_money   NUMBER(15,2),
  member_code   VARCHAR2(32),
  member_name   VARCHAR2(120),
  trade_date    DATE,
  good_code     VARCHAR2(10),
  good_name     VARCHAR2(120),
  good_quantity NUMBER(15),
  flag          VARCHAR2(1),
  bankid        VARCHAR2(32) not null,
  createdate    DATE,
  note          VARCHAR2(120)
)
;
comment on table F_B_MARGINS
  is '交易商资金冻结解冻表';
comment on column F_B_MARGINS.serial_id
  is '业务流水号';
comment on column F_B_MARGINS.bargain_code
  is '成交合同号';
comment on column F_B_MARGINS.trade_type
  is '交易类型 (1 冻结；2 解冻)';
comment on column F_B_MARGINS.trade_money
  is '交易金额';
comment on column F_B_MARGINS.member_code
  is '交易会员号';
comment on column F_B_MARGINS.member_name
  is '交易会员名称';
comment on column F_B_MARGINS.trade_date
  is '交易日期';
comment on column F_B_MARGINS.good_code
  is '商品编号';
comment on column F_B_MARGINS.good_name
  is '商品名称';
comment on column F_B_MARGINS.good_quantity
  is '商品数量';
comment on column F_B_MARGINS.flag
  is '发送状态 (N 未发送；F 银行处理失败；Y 银行处理成功)';
comment on column F_B_MARGINS.bankid
  is '银行编号';
comment on column F_B_MARGINS.createdate
  is '创建时间';
comment on column F_B_MARGINS.note
  is '资金冻结解冻表备注字段';
alter table F_B_MARGINS
  add constraint PK_F_B_MARGINS primary key (SERIAL_ID, BARGAIN_CODE, BANKID);

prompt
prompt Creating table F_B_PLATFORMMSG
prompt ==============================
prompt
create table F_B_PLATFORMMSG
(
  firmid     VARCHAR2(15) not null,
  platfirmid VARCHAR2(15) not null
)
;
alter table F_B_PLATFORMMSG
  add constraint F_B_PLATFORMMSG_PRIMARY primary key (FIRMID);

prompt
prompt Creating table F_B_PROPERBALANCE
prompt ================================
prompt
create table F_B_PROPERBALANCE
(
  bankid     VARCHAR2(20) not null,
  allmoney   NUMBER not null,
  gongmoney  NUMBER not null,
  othermoney NUMBER not null,
  bdate      TIMESTAMP(6) not null
)
;
comment on table F_B_PROPERBALANCE
  is '总分平衡表';
comment on column F_B_PROPERBALANCE.bankid
  is '银行编号';
comment on column F_B_PROPERBALANCE.allmoney
  is '总资金';
comment on column F_B_PROPERBALANCE.gongmoney
  is '工行总资金';
comment on column F_B_PROPERBALANCE.othermoney
  is '其他行资金';
comment on column F_B_PROPERBALANCE.bdate
  is '日期时间';

prompt
prompt Creating table F_B_QSRESULT
prompt ===========================
prompt
create table F_B_QSRESULT
(
  resultid   NUMBER(12) not null,
  bankid     VARCHAR2(32) not null,
  bankname   VARCHAR2(120),
  firmid     VARCHAR2(32),
  firmname   VARCHAR2(120),
  account    VARCHAR2(20),
  account1   VARCHAR2(20),
  kymoneym   NUMBER(18,2),
  kymoneyb   NUMBER(18,2),
  djmoneym   NUMBER(18,2),
  djmoneyb   NUMBER(18,2),
  zckymoney  NUMBER(18,2),
  zcdjmoney  NUMBER(18,2),
  moneym     NUMBER(18,2),
  moneyb     NUMBER(18,2),
  zcmoney    NUMBER(18,2),
  createdate DATE default sysdate,
  tradedate  DATE not null,
  status     NUMBER(2) not null,
  note       VARCHAR2(120)
)
;
comment on table F_B_QSRESULT
  is '对账不平纪录信息';
comment on column F_B_QSRESULT.resultid
  is '流水编号';
comment on column F_B_QSRESULT.bankid
  is '银行编号';
comment on column F_B_QSRESULT.bankname
  is '银行名称';
comment on column F_B_QSRESULT.firmid
  is '交易商代码';
comment on column F_B_QSRESULT.firmname
  is '交易商名称';
comment on column F_B_QSRESULT.account
  is '银行账号';
comment on column F_B_QSRESULT.account1
  is '子账号';
comment on column F_B_QSRESULT.kymoneym
  is '市场可用余额';
comment on column F_B_QSRESULT.kymoneyb
  is '银行可用余额';
comment on column F_B_QSRESULT.djmoneym
  is '市场冻结资金';
comment on column F_B_QSRESULT.djmoneyb
  is '银行冻结资金';
comment on column F_B_QSRESULT.zckymoney
  is '可用资金扎差';
comment on column F_B_QSRESULT.zcdjmoney
  is '冻结资金扎差';
comment on column F_B_QSRESULT.moneym
  is '市场权益';
comment on column F_B_QSRESULT.moneyb
  is '银行权益';
comment on column F_B_QSRESULT.zcmoney
  is '权益扎差';
comment on column F_B_QSRESULT.createdate
  is '记录创建时间';
comment on column F_B_QSRESULT.tradedate
  is '交易日期';
comment on column F_B_QSRESULT.status
  is '清算状态(0:成功、1:失败、2:可用余额不等、3:冻结余额不等、4:总余额不等、6:账号资金异常)';
comment on column F_B_QSRESULT.note
  is '备注信息';
alter table F_B_QSRESULT
  add constraint PK_F_B_QSRESULT primary key (RESULTID);

prompt
prompt Creating table F_B_QUANYI
prompt =========================
prompt
create table F_B_QUANYI
(
  id                 NUMBER(12) not null,
  firmid             VARCHAR2(32) not null,
  venduebalance      NUMBER(12,2) not null,
  zcjsbalance        NUMBER(12,2) not null,
  timebargainbalance NUMBER(12,2) not null,
  avilablebalance    NUMBER(12,2) not null,
  bankbalance        NUMBER(12,2) not null,
  payment            NUMBER(12,2) not null,
  income             NUMBER(12,2) not null,
  fee                NUMBER(12,2) not null,
  jie                NUMBER(12,2) not null,
  dai                NUMBER(12,2) not null,
  dealtime           DATE not null
)
;
comment on table F_B_QUANYI
  is '交易权益表';
comment on column F_B_QUANYI.id
  is '表单ID';
comment on column F_B_QUANYI.firmid
  is '交易商代码';
comment on column F_B_QUANYI.venduebalance
  is '竞价部分占用保证金';
comment on column F_B_QUANYI.zcjsbalance
  is '挂牌部分占用保证金';
comment on column F_B_QUANYI.timebargainbalance
  is '中远期部分权益';
comment on column F_B_QUANYI.avilablebalance
  is '财务余额';
comment on column F_B_QUANYI.bankbalance
  is '银行余额';
comment on column F_B_QUANYI.payment
  is '收货款';
comment on column F_B_QUANYI.income
  is '付货款';
comment on column F_B_QUANYI.fee
  is '手续费';
comment on column F_B_QUANYI.jie
  is '接触金额';
comment on column F_B_QUANYI.dai
  is '贷入金额';
comment on column F_B_QUANYI.dealtime
  is '记录日期';
alter table F_B_QUANYI
  add primary key (ID);

prompt
prompt Creating table F_B_RGSTCAPITALVALUE
prompt ===================================
prompt
create table F_B_RGSTCAPITALVALUE
(
  id          NUMBER(12) not null,
  actionid    NUMBER(12) not null,
  firmid      VARCHAR2(32) not null,
  account     VARCHAR2(32) not null,
  bankid      VARCHAR2(32) not null,
  type        NUMBER(2) not null,
  createtime  DATE not null,
  banktime    DATE,
  status      NUMBER(2) not null,
  accountname VARCHAR2(32) not null,
  cardtype    VARCHAR2(2) default 1 not null,
  card        VARCHAR2(32),
  note        VARCHAR2(128)
)
;
comment on column F_B_RGSTCAPITALVALUE.id
  is '记录流水号';
comment on column F_B_RGSTCAPITALVALUE.actionid
  is '市场流水号';
comment on column F_B_RGSTCAPITALVALUE.firmid
  is '交易商代码';
comment on column F_B_RGSTCAPITALVALUE.account
  is '签约协议号';
comment on column F_B_RGSTCAPITALVALUE.bankid
  is '银行代码';
comment on column F_B_RGSTCAPITALVALUE.type
  is '流水类型 1签约  2解约';
comment on column F_B_RGSTCAPITALVALUE.createtime
  is '创建时间';
comment on column F_B_RGSTCAPITALVALUE.banktime
  is '完成时间';
comment on column F_B_RGSTCAPITALVALUE.status
  is '流水状态 0成功 1失败 2处理中';
comment on column F_B_RGSTCAPITALVALUE.accountname
  is '户名';
comment on column F_B_RGSTCAPITALVALUE.cardtype
  is '证件类型';
comment on column F_B_RGSTCAPITALVALUE.card
  is '证件号';
comment on column F_B_RGSTCAPITALVALUE.note
  is '备注';
alter table F_B_RGSTCAPITALVALUE
  add constraint PK_F_B_RGSTCAPITALVALUE primary key (FIRMID, BANKID, TYPE, CREATETIME);

prompt
prompt Creating table F_B_TRADEDATA
prompt ============================
prompt
create table F_B_TRADEDATA
(
  firmid           VARCHAR2(32) not null,
  account1         VARCHAR2(32),
  money            NUMBER(12,2) default 1 not null,
  type             NUMBER(2) not null,
  status           NUMBER(2) not null,
  transferdate     DATE not null,
  accountname1     VARCHAR2(100),
  actionid         VARCHAR2(32) not null,
  funid            VARCHAR2(32),
  compareresult    NUMBER(1) default 2 not null,
  banktime         VARCHAR2(32),
  realtransferdate VARCHAR2(32),
  sendperson       VARCHAR2(32)
)
;
comment on table F_B_TRADEDATA
  is '交易数据表';
comment on column F_B_TRADEDATA.firmid
  is '交易商id';
comment on column F_B_TRADEDATA.account1
  is '交易账号 [对应交易商银行帐号对应表的内部帐号]';
comment on column F_B_TRADEDATA.money
  is '变动金额';
comment on column F_B_TRADEDATA.type
  is '类型(0：权益增  1：权益减  2：收货款  3：付货款   4：手续费 5正 资金误差 6负 资金误差)';
comment on column F_B_TRADEDATA.status
  is '发送结果(1：未发送   0：发送成功)';
comment on column F_B_TRADEDATA.transferdate
  is '应发送时间';
comment on column F_B_TRADEDATA.accountname1
  is '交易账号名称';
comment on column F_B_TRADEDATA.actionid
  is '市场流水号';
comment on column F_B_TRADEDATA.funid
  is '银行流水号';
comment on column F_B_TRADEDATA.compareresult
  is '银行转账';
comment on column F_B_TRADEDATA.banktime
  is '对账时间';
comment on column F_B_TRADEDATA.realtransferdate
  is '实际发送时间';
comment on column F_B_TRADEDATA.sendperson
  is '发送人';
alter table F_B_TRADEDATA
  add primary key (ACTIONID);

prompt
prompt Creating table F_B_TRADEDETAILACC
prompt =================================
prompt
create table F_B_TRADEDETAILACC
(
  batchno     VARCHAR2(20) not null,
  bankid      VARCHAR2(20) not null,
  dealid      VARCHAR2(20) not null,
  cobrn       VARCHAR2(20),
  txdate      VARCHAR2(20),
  txtime      VARCHAR2(20),
  bkserial    VARCHAR2(32) not null,
  coserial    VARCHAR2(32) not null,
  bankacc     VARCHAR2(32) not null,
  fundacc     VARCHAR2(32) not null,
  custname    VARCHAR2(100) not null,
  txopt       VARCHAR2(20) not null,
  txcode      VARCHAR2(20) not null,
  curcode     VARCHAR2(20) not null,
  comparedate DATE not null
)
;
comment on table F_B_TRADEDETAILACC
  is '账户类交易对账明细表';
comment on column F_B_TRADEDETAILACC.batchno
  is '交易序号';
comment on column F_B_TRADEDETAILACC.bankid
  is '银行id';
comment on column F_B_TRADEDETAILACC.dealid
  is '市场组织机构代码';
comment on column F_B_TRADEDETAILACC.cobrn
  is '合作方机构代码';
comment on column F_B_TRADEDETAILACC.txdate
  is '交易日期';
comment on column F_B_TRADEDETAILACC.txtime
  is '交易时间';
comment on column F_B_TRADEDETAILACC.bkserial
  is '银行流水';
comment on column F_B_TRADEDETAILACC.coserial
  is '市场流水';
comment on column F_B_TRADEDETAILACC.bankacc
  is '银行账号';
comment on column F_B_TRADEDETAILACC.fundacc
  is '交易商代码';
comment on column F_B_TRADEDETAILACC.custname
  is '交易商姓名';
comment on column F_B_TRADEDETAILACC.txopt
  is '交易发起方';
comment on column F_B_TRADEDETAILACC.txcode
  is '交易类型';
comment on column F_B_TRADEDETAILACC.curcode
  is '币种';
comment on column F_B_TRADEDETAILACC.comparedate
  is '对账日期';
alter table F_B_TRADEDETAILACC
  add constraint F_B_TRADEDETAILACC primary key (BANKID, BKSERIAL, COMPAREDATE);

prompt
prompt Creating table F_B_TRADELIST
prompt ============================
prompt
create table F_B_TRADELIST
(
  trade_money   NUMBER(15,2),
  trade_type    VARCHAR2(2),
  b_member_code VARCHAR2(6),
  b_member_name VARCHAR2(120),
  s_member_code VARCHAR2(6),
  s_member_name VARCHAR2(120),
  trade_date    DATE,
  bargain_code  VARCHAR2(20) not null,
  serial_id     VARCHAR2(15) not null,
  good_code     VARCHAR2(10),
  good_name     VARCHAR2(100),
  good_quantity NUMBER(15),
  flag          VARCHAR2(1),
  bankid        VARCHAR2(32) not null,
  createdate    DATE,
  note          VARCHAR2(120)
)
;
comment on table F_B_TRADELIST
  is '交易商权益变更表';
comment on column F_B_TRADELIST.trade_money
  is '变更金额';
comment on column F_B_TRADELIST.trade_type
  is '交易类型(1 货款、盈亏、补偿费；2 交易手续费；3 交收手续费；4 浮亏；5 其他手续费)';
comment on column F_B_TRADELIST.b_member_code
  is '买方会员号';
comment on column F_B_TRADELIST.b_member_name
  is '买方会员名称';
comment on column F_B_TRADELIST.s_member_code
  is '卖方会员号';
comment on column F_B_TRADELIST.s_member_name
  is '买方会员名称';
comment on column F_B_TRADELIST.trade_date
  is '交易日期';
comment on column F_B_TRADELIST.bargain_code
  is '成交合同号';
comment on column F_B_TRADELIST.serial_id
  is '交易流水号';
comment on column F_B_TRADELIST.good_code
  is '货物编号';
comment on column F_B_TRADELIST.good_name
  is '货物名称';
comment on column F_B_TRADELIST.good_quantity
  is '货物数量';
comment on column F_B_TRADELIST.flag
  is '发送状态 (N 未发送；F 银行处理失败；Y 银行处理成功)';
comment on column F_B_TRADELIST.bankid
  is '银行编号';
comment on column F_B_TRADELIST.createdate
  is '创建时间';
comment on column F_B_TRADELIST.note
  is '交易商权益变更表备注字段';
alter table F_B_TRADELIST
  add constraint PK_F_B_TRADELIST primary key (BARGAIN_CODE, SERIAL_ID, BANKID);

prompt
prompt Creating table F_B_TRANSMONEYOBJ
prompt ================================
prompt
create table F_B_TRANSMONEYOBJ
(
  id        NUMBER(5) not null,
  classname VARCHAR2(32) not null,
  note      VARCHAR2(256) not null
)
;
comment on table F_B_TRANSMONEYOBJ
  is '资金划转对象表';
comment on column F_B_TRANSMONEYOBJ.id
  is '序号';
comment on column F_B_TRANSMONEYOBJ.classname
  is '业务实现类';
comment on column F_B_TRANSMONEYOBJ.note
  is '备注';

prompt
prompt Creating table F_B_ZFPH
prompt =======================
prompt
create table F_B_ZFPH
(
  bankid             VARCHAR2(32) not null,
  tradedate          DATE default sysdate not null,
  currency           VARCHAR2(10) default '001' not null,
  type               NUMBER(2) default 0 not null,
  lastaccountbalance NUMBER(15,2) default 0 not null,
  accountbalance     NUMBER(15,2) default 0 not null,
  result             NUMBER(2) default 0 not null,
  createdate         DATE default sysdate not null
)
;
comment on table F_B_ZFPH
  is '总分平衡表';
comment on column F_B_ZFPH.bankid
  is '银行编号';
comment on column F_B_ZFPH.tradedate
  is '交易日期';
comment on column F_B_ZFPH.currency
  is '币别 (001：人民币 013：港币 014：美元)';
comment on column F_B_ZFPH.type
  is ' 钞汇标识（0：钞 1：汇）';
comment on column F_B_ZFPH.lastaccountbalance
  is '资金存管明细账户余额汇总';
comment on column F_B_ZFPH.accountbalance
  is '资金汇总账号金额';
comment on column F_B_ZFPH.result
  is '总分对账结果(0：平 1：不平)';
comment on column F_B_ZFPH.createdate
  is '创建时间';
alter table F_B_ZFPH
  add constraint PK_F_B_ZFPH primary key (BANKID, TRADEDATE);

prompt
prompt Creating table F_CLEARSTATUS
prompt ============================
prompt
create table F_CLEARSTATUS
(
  actionid   NUMBER(3) not null,
  actionnote VARCHAR2(32) not null,
  status     CHAR(1) not null,
  finishtime DATE
)
;
comment on column F_CLEARSTATUS.status
  is 'Y:完成
N:未执行';
alter table F_CLEARSTATUS
  add constraint PK_F_CLEARSTATUS primary key (ACTIONID);

prompt
prompt Creating table F_CLIENTLEDGER
prompt =============================
prompt
create table F_CLIENTLEDGER
(
  b_date DATE not null,
  firmid VARCHAR2(32) not null,
  code   VARCHAR2(16) not null,
  value  NUMBER(15,2) not null
)
;
alter table F_CLIENTLEDGER
  add constraint PK_F_CLIENTLEDGER primary key (B_DATE, FIRMID, CODE);

prompt
prompt Creating table F_DAILYBALANCE
prompt =============================
prompt
create table F_DAILYBALANCE
(
  b_date         DATE not null,
  accountcode    VARCHAR2(38) not null,
  lastdaybalance NUMBER(15,2),
  debitamount    NUMBER(15,2),
  creditamount   NUMBER(15,2),
  todaybalance   NUMBER(15,2)
)
;
alter table F_DAILYBALANCE
  add constraint PK_F_DAILYBALANCE primary key (B_DATE, ACCOUNTCODE);

prompt
prompt Creating table F_FIRMBALANCE
prompt ============================
prompt
create table F_FIRMBALANCE
(
  b_date           DATE not null,
  firmid           VARCHAR2(32) not null,
  lastbalance      NUMBER(15,2) default 0 not null,
  todaybalance     NUMBER(15,2) default 0 not null,
  lastwarranty     NUMBER(15,2) not null,
  todaywarranty    NUMBER(15,2) not null,
  lastsettlemargin NUMBER(15,2) default 0 not null,
  settlemargin     NUMBER(15,2) default 0 not null
)
;
alter table F_FIRMBALANCE
  add constraint PK_F_H_FIRMBALANCE primary key (B_DATE, FIRMID);

prompt
prompt Creating table F_FIRMCLEARFUNDS
prompt ===============================
prompt
create table F_FIRMCLEARFUNDS
(
  b_date            DATE not null,
  firmid            VARCHAR2(32) not null,
  balance           NUMBER(15,2) default 0 not null,
  rightsfrozenfunds NUMBER(15,2) default 0 not null,
  rights            NUMBER(15,2) default 0 not null,
  firmfee           NUMBER(15,2) default 0 not null,
  marketfee         NUMBER(15,2) default 0 not null
)
;
alter table F_FIRMCLEARFUNDS
  add constraint PK_F_FIRMCLEARFUNDS primary key (B_DATE, FIRMID);

prompt
prompt Creating table F_FIRMFUNDS
prompt ==========================
prompt
create table F_FIRMFUNDS
(
  firmid           VARCHAR2(32) not null,
  balance          NUMBER(15,2) default 0 not null,
  frozenfunds      NUMBER(15,2) default 0 not null,
  lastbalance      NUMBER(15,2) default 0 not null,
  lastwarranty     NUMBER(15,2) default 0 not null,
  settlemargin     NUMBER(15,2) default 0 not null,
  lastsettlemargin NUMBER(15,2) default 0 not null
)
;
alter table F_FIRMFUNDS
  add constraint PK_F_FIRMFUNDS primary key (FIRMID);

prompt
prompt Creating table F_FIRMRIGHTSCOMPUTEFUNDS
prompt =======================================
prompt
create table F_FIRMRIGHTSCOMPUTEFUNDS
(
  b_date      DATE not null,
  firmid      VARCHAR2(32) not null,
  code        VARCHAR2(16) not null,
  lastbalance NUMBER(15,2) default 0 not null,
  balance     NUMBER(15,2) default 0 not null
)
;
alter table F_FIRMRIGHTSCOMPUTEFUNDS
  add constraint PK_F_FIRMRIGHTSCOMPUTEFUNDS primary key (B_DATE, FIRMID, CODE);

prompt
prompt Creating table F_FROZENFUNDFLOW
prompt ===============================
prompt
create table F_FROZENFUNDFLOW
(
  fundflowid NUMBER(10) not null,
  firmid     VARCHAR2(32) not null,
  amount     NUMBER(15,2) default 0 not null,
  moduleid   CHAR(2) not null,
  createtime DATE not null
)
;
comment on column F_FROZENFUNDFLOW.moduleid
  is '10综合管理平台
11财务系统
13仓单管理系统
14融资系统
15订单交易
18投资类大宗商品交易系统
20做市商交易系统
21竞价系统
22银行接入及结算系统
23E现货';
comment on column F_FROZENFUNDFLOW.createtime
  is '创建时间';
alter table F_FROZENFUNDFLOW
  add constraint PK_FROZENFUNDFLOW primary key (FUNDFLOWID);

prompt
prompt Creating table F_FROZENFUNDS
prompt ============================
prompt
create table F_FROZENFUNDS
(
  moduleid    CHAR(2) not null,
  firmid      VARCHAR2(32) not null,
  frozenfunds NUMBER(15,2) not null
)
;
comment on column F_FROZENFUNDS.moduleid
  is '10综合管理平台
11财务系统
13仓单管理系统
14融资系统
15订单交易
18投资类大宗商品交易系统
20做市商交易系统
21竞价系统
22银行接入及结算系统
23E现货';
alter table F_FROZENFUNDS
  add constraint PK_F_FROZENFUNDS primary key (MODULEID, FIRMID);

prompt
prompt Creating table F_FUNDFLOW
prompt =========================
prompt
create table F_FUNDFLOW
(
  fundflowid   NUMBER(10) not null,
  firmid       VARCHAR2(32) not null,
  oprcode      CHAR(5) not null,
  contractno   VARCHAR2(16),
  commodityid  VARCHAR2(16),
  amount       NUMBER(15,2) default 0 not null,
  balance      NUMBER(15,2) default 0 not null,
  appendamount NUMBER(15,2),
  voucherno    NUMBER(10),
  createtime   DATE not null,
  b_date       DATE
)
;
comment on column F_FUNDFLOW.createtime
  is '创建时间';
alter table F_FUNDFLOW
  add constraint PK_F_FUNDFLOW primary key (FUNDFLOWID);

prompt
prompt Creating table F_H_FROZENFUNDFLOW
prompt =================================
prompt
create table F_H_FROZENFUNDFLOW
(
  fundflowid NUMBER(10) not null,
  firmid     VARCHAR2(32) not null,
  amount     NUMBER(15,2) default 0 not null,
  moduleid   CHAR(2) not null,
  createtime DATE not null
)
;
comment on column F_H_FROZENFUNDFLOW.moduleid
  is '10综合管理平台
11财务系统
13仓单管理系统
14融资系统
15订单交易
18投资类大宗商品交易系统
20做市商交易系统
21竞价系统
22银行接入及结算系统
23E现货';
comment on column F_H_FROZENFUNDFLOW.createtime
  is '创建时间';
alter table F_H_FROZENFUNDFLOW
  add constraint PK_H_FROZENFUNDFLOW primary key (FUNDFLOWID);

prompt
prompt Creating table F_H_FUNDFLOW
prompt ===========================
prompt
create table F_H_FUNDFLOW
(
  fundflowid   NUMBER(10) not null,
  firmid       VARCHAR2(32) not null,
  oprcode      CHAR(5) not null,
  contractno   VARCHAR2(16),
  commodityid  VARCHAR2(16),
  amount       NUMBER(15,2) default 0 not null,
  balance      NUMBER(15,2) default 0 not null,
  appendamount NUMBER(15,2),
  voucherno    NUMBER(10) not null,
  createtime   DATE not null,
  b_date       DATE not null
)
;
comment on column F_H_FUNDFLOW.balance
  is '当前帐户资金余额（不考虑浮亏）';
comment on column F_H_FUNDFLOW.createtime
  is '创建时间';
alter table F_H_FUNDFLOW
  add constraint PK_F_H_FUNDFLOW primary key (FUNDFLOWID);

prompt
prompt Creating table F_LEDGERFIELD
prompt ============================
prompt
create table F_LEDGERFIELD
(
  code      VARCHAR2(16) not null,
  name      VARCHAR2(32) not null,
  fieldsign NUMBER(1) not null,
  moduleid  CHAR(2) not null,
  ordernum  NUMBER(5) not null,
  isinit    CHAR(1) default 'Y' not null
)
;
comment on column F_LEDGERFIELD.fieldsign
  is '1：增项 -1：减项';
comment on column F_LEDGERFIELD.moduleid
  is '10综合管理平台
11财务系统
13仓单管理系统
14融资系统
15订单交易
18投资类大宗商品交易系统
20做市商交易系统
21竞价系统
22银行接入及结算系统
23E现货';
comment on column F_LEDGERFIELD.ordernum
  is '前两位模块号后三位排序号
';
comment on column F_LEDGERFIELD.isinit
  is 'Y:是初始化数据,页面不允许删除和修改
N:不是初始化数据';
alter table F_LEDGERFIELD
  add constraint PK_F_LEDGERFIELD primary key (CODE);

prompt
prompt Creating table F_LOG
prompt ====================
prompt
create table F_LOG
(
  occurtime   DATE not null,
  type        VARCHAR2(8) not null,
  userid      VARCHAR2(16) not null,
  description VARCHAR2(128) not null
)
;
comment on table F_LOG
  is '财务日志表';
comment on column F_LOG.type
  is 'info：信息
alert：警告
error：错误
sysinfo：系统信息';

prompt
prompt Creating table F_SUMMARY
prompt ========================
prompt
create table F_SUMMARY
(
  summaryno      CHAR(5) not null,
  summary        VARCHAR2(32) not null,
  ledgeritem     VARCHAR2(16),
  funddcflag     CHAR(1) default 'N' not null,
  accountcodeopp VARCHAR2(16),
  appendaccount  CHAR(1) default 'N' not null,
  isinit         CHAR(1) default 'Y' not null
)
;
comment on column F_SUMMARY.funddcflag
  is '该凭证如果涉及交易商资金，增加资金记贷方 C，减少资金记借方 D。
不涉及交易商资金：N';
comment on column F_SUMMARY.accountcodeopp
  is '用于电脑凭证';
comment on column F_SUMMARY.appendaccount
  is '除了资金发生变动外，还有附加的财务账户变动。
T：增值税 Tax
W：担保金 Warranty
S：交收保证金 SettleMargin
N：无附加';
comment on column F_SUMMARY.isinit
  is 'Y:是初始化数据,页面不允许删除和修改
N:不是初始化数据';
alter table F_SUMMARY
  add constraint PK_F_SUMMARY primary key (SUMMARYNO);

prompt
prompt Creating table F_SYSTEMSTATUS
prompt =============================
prompt
create table F_SYSTEMSTATUS
(
  b_date    DATE not null,
  status    NUMBER(2) not null,
  note      VARCHAR2(256),
  cleartime DATE,
  isclear   NUMBER(2) default 0 not null
)
;
comment on column F_SYSTEMSTATUS.status
  is '0:未结算状态
1:结算中
2:结算完成';
alter table F_SYSTEMSTATUS
  add constraint PK_F_SYSTEMSTATUS primary key (B_DATE);

prompt
prompt Creating table F_VOUCHER
prompt ========================
prompt
create table F_VOUCHER
(
  voucherno  NUMBER(10) not null,
  b_date     DATE,
  summaryno  CHAR(5) not null,
  summary    VARCHAR2(32),
  note       VARCHAR2(128),
  inputuser  VARCHAR2(16) not null,
  inputtime  TIMESTAMP(6),
  auditor    VARCHAR2(16),
  audittime  TIMESTAMP(6),
  auditnote  VARCHAR2(128),
  status     VARCHAR2(16),
  contractno VARCHAR2(16),
  fundflowid NUMBER(10)
)
;
comment on column F_VOUCHER.status
  is 'editing   编辑状态
auditing  待审核
audited   已审核
accounted 已记账';
create index IX_F_VOUCHER_CONTRACTNO on F_VOUCHER (CONTRACTNO);
create index IX_F_VOUCHER_STATUS on F_VOUCHER (STATUS);
create unique index UK_F_VOUCHER on F_VOUCHER (FUNDFLOWID);
alter table F_VOUCHER
  add constraint PK_F_VOUCHER primary key (VOUCHERNO);

prompt
prompt Creating table F_VOUCHERENTRY
prompt =============================
prompt
create table F_VOUCHERENTRY
(
  entryid      NUMBER(10) not null,
  entrysummary VARCHAR2(32),
  voucherno    NUMBER(10) not null,
  accountcode  VARCHAR2(38) not null,
  debitamount  NUMBER(15,2) not null,
  creditamount NUMBER(15,2) not null
)
;
create index IX_F_VOUCHERENTRY on F_VOUCHERENTRY (VOUCHERNO);
alter table F_VOUCHERENTRY
  add constraint PK_F_VOUCHERENTRY primary key (ENTRYID);

prompt
prompt Creating table F_VOUCHERMODEL
prompt =============================
prompt
create table F_VOUCHERMODEL
(
  code           VARCHAR2(16) not null,
  name           VARCHAR2(64),
  summaryno      CHAR(5) not null,
  debitcode      VARCHAR2(38) not null,
  creditcode     VARCHAR2(38) not null,
  needcontractno CHAR(1) not null,
  note           VARCHAR2(128)
)
;
comment on table F_VOUCHERMODEL
  is '用于快捷创建手工凭证的模板';
alter table F_VOUCHERMODEL
  add constraint PK_F_VOUCHERMODEL primary key (CODE);

prompt
prompt Creating table IPO_BALLOTNO_INFO
prompt ================================
prompt
create table IPO_BALLOTNO_INFO
(
  id               NUMBER not null,
  commodityid      VARCHAR2(32) not null,
  ballotnostartlen NUMBER not null,
  ballotnoendlen   NUMBER not null,
  ballotno         VARCHAR2(32),
  createtime       DATE not null
)
;
comment on table IPO_BALLOTNO_INFO
  is '????????????';
alter table IPO_BALLOTNO_INFO
  add constraint PK_IPO_BALLOTNO_INFO primary key (ID);

prompt
prompt Creating table IPO_COMMODITY
prompt ============================
prompt
create table IPO_COMMODITY
(
  id              NUMBER(8) not null,
  commodityid     VARCHAR2(32) not null,
  commodityname   VARCHAR2(32) not null,
  price           NUMBER(11,3) not null,
  units           NUMBER not null,
  counts          NUMBER not null,
  starttime       DATE not null,
  endtime         DATE not null,
  purchasecredits NUMBER
)
;
comment on table IPO_COMMODITY
  is '商品列表';
comment on column IPO_COMMODITY.commodityid
  is '商品编号';
comment on column IPO_COMMODITY.commodityname
  is '商品名称';
comment on column IPO_COMMODITY.price
  is '发售价';
comment on column IPO_COMMODITY.units
  is '发售单位';
comment on column IPO_COMMODITY.counts
  is '发售数量';
comment on column IPO_COMMODITY.starttime
  is '起始时间';
comment on column IPO_COMMODITY.endtime
  is '结束时间';
comment on column IPO_COMMODITY.purchasecredits
  is '申购额度';
alter table IPO_COMMODITY
  add constraint PK_IPO_COMMODITY primary key (ID);

prompt
prompt Creating table IPO_DISTRIBUTION
prompt ===============================
prompt
create table IPO_DISTRIBUTION
(
  id            NUMBER(8) not null,
  userid        VARCHAR2(32) not null,
  commodityname VARCHAR2(32) not null,
  startnumber   NUMBER not null,
  pcounts       NUMBER(8) not null,
  ptime         TIMESTAMP(6) not null,
  zcounts       NUMBER(8),
  numbers       BLOB,
  commodityid   VARCHAR2(32)
)
;
comment on table IPO_DISTRIBUTION
  is '配号，中签结果';
comment on column IPO_DISTRIBUTION.userid
  is '客户编号';
comment on column IPO_DISTRIBUTION.commodityname
  is '商品名称';
comment on column IPO_DISTRIBUTION.startnumber
  is '起始配号';
comment on column IPO_DISTRIBUTION.pcounts
  is '配号数量';
comment on column IPO_DISTRIBUTION.ptime
  is '配号时间';
comment on column IPO_DISTRIBUTION.zcounts
  is '中签数量';
comment on column IPO_DISTRIBUTION.numbers
  is '中签号码';
comment on column IPO_DISTRIBUTION.commodityid
  is '商品编号';
alter table IPO_DISTRIBUTION
  add constraint PK_IPO_DISTRIBUTION primary key (ID);

prompt
prompt Creating table IPO_NUMBEROFRECORDS
prompt ==================================
prompt
create table IPO_NUMBEROFRECORDS
(
  id          NUMBER(8) not null,
  commodityid VARCHAR2(32),
  counts      NUMBER,
  nowtime     TIMESTAMP(6)
)
;
comment on column IPO_NUMBEROFRECORDS.commodityid
  is '商品编号';
comment on column IPO_NUMBEROFRECORDS.counts
  is '已配个数';
comment on column IPO_NUMBEROFRECORDS.nowtime
  is '时间';
alter table IPO_NUMBEROFRECORDS
  add constraint PK_IPO_NUMBEROFRECORDS primary key (ID);

prompt
prompt Creating table IPO_NUMBEROFRECORDS_H
prompt ====================================
prompt
create table IPO_NUMBEROFRECORDS_H
(
  id          NUMBER(8) not null,
  commodityid VARCHAR2(32),
  counts      NUMBER,
  nowtime     TIMESTAMP(6)
)
;
comment on column IPO_NUMBEROFRECORDS_H.id
  is 'ID';
comment on column IPO_NUMBEROFRECORDS_H.commodityid
  is '商品编码';
comment on column IPO_NUMBEROFRECORDS_H.nowtime
  is '时间';
alter table IPO_NUMBEROFRECORDS_H
  add constraint PK_IPO_NUMBEROFRECORDS_H primary key (ID);

prompt
prompt Creating table IPO_ORDER
prompt ========================
prompt
create table IPO_ORDER
(
  orderid       NUMBER not null,
  userid        VARCHAR2(32) not null,
  username      VARCHAR2(12),
  commodityid   VARCHAR2(12) not null,
  commodityname VARCHAR2(12) not null,
  counts        NUMBER not null,
  createtime    TIMESTAMP(6) not null,
  frozenfunds   NUMBER(15,2) not null
)
;
comment on table IPO_ORDER
  is '订单表';
comment on column IPO_ORDER.userid
  is '客户编号';
comment on column IPO_ORDER.username
  is '客户姓名';
comment on column IPO_ORDER.commodityid
  is '商品编号';
comment on column IPO_ORDER.commodityname
  is '商品名称';
comment on column IPO_ORDER.counts
  is '客户申购数';
comment on column IPO_ORDER.createtime
  is '申购时间';
comment on column IPO_ORDER.frozenfunds
  is '资金冻结';
alter table IPO_ORDER
  add constraint PK_IPO_ORDER primary key (ORDERID);

prompt
prompt Creating table IPO_ORDER_H
prompt ==========================
prompt
create table IPO_ORDER_H
(
  orderid       NUMBER not null,
  userid        VARCHAR2(32) not null,
  username      VARCHAR2(12),
  commodityid   VARCHAR2(12) not null,
  commodityname VARCHAR2(12) not null,
  counts        NUMBER not null,
  createtime    TIMESTAMP(6) not null,
  frozenfunds   NUMBER(15,2) not null
)
;
comment on column IPO_ORDER_H.userid
  is '客户编号';
comment on column IPO_ORDER_H.username
  is '客户姓名';
comment on column IPO_ORDER_H.commodityid
  is '商品编号';
comment on column IPO_ORDER_H.commodityname
  is '商品名称';
comment on column IPO_ORDER_H.counts
  is '客户申购数';
comment on column IPO_ORDER_H.createtime
  is '申购时间';
comment on column IPO_ORDER_H.frozenfunds
  is '资金冻结';
alter table IPO_ORDER_H
  add constraint PK_IPO_ORDER_H primary key (ORDERID);

prompt
prompt Creating table IPO_TRADETIME
prompt ============================
prompt
create table IPO_TRADETIME
(
  sectionid    NUMBER(4) not null,
  name         VARCHAR2(20),
  starttime    VARCHAR2(10) not null,
  endtime      VARCHAR2(10) not null,
  status       NUMBER(2) not null,
  gatherbid    NUMBER(1) default 0 not null,
  bidstarttime VARCHAR2(10),
  bidendtime   VARCHAR2(10),
  modifytime   DATE not null,
  startdate    VARCHAR2(16),
  enddate      VARCHAR2(16),
  bidstartdate VARCHAR2(16),
  bidenddate   VARCHAR2(16)
)
;
alter table IPO_TRADETIME
  add primary key (SECTIONID);

prompt
prompt Creating table L_AUCONFIG
prompt =========================
prompt
create table L_AUCONFIG
(
  configid    NUMBER(6) not null,
  hostip      VARCHAR2(20),
  port        NUMBER(6) not null,
  dataport    NUMBER(6),
  servicename VARCHAR2(32) not null,
  logonmode   NUMBER(2) default 1 not null,
  sysname     VARCHAR2(32) not null
)
;
comment on column L_AUCONFIG.logonmode
  is '1 互踢;2 不互踢';
comment on column L_AUCONFIG.sysname
  is '前台：front
后台：mgr
仓库端：warehouse
会员端：broker';
alter table L_AUCONFIG
  add constraint PK_L_AUCONFIG primary key (CONFIGID);

prompt
prompt Creating table L_DICTIONARY
prompt ===========================
prompt
create table L_DICTIONARY
(
  key   VARCHAR2(32) not null,
  name  VARCHAR2(128),
  value VARCHAR2(64) not null,
  note  VARCHAR2(1924)
)
;
alter table L_DICTIONARY
  add constraint PK_L_DICTIONARY primary key (KEY);

prompt
prompt Creating table L_MODULEANDAU
prompt ============================
prompt
create table L_MODULEANDAU
(
  moduleid NUMBER(2) not null,
  configid NUMBER(6) not null
)
;
alter table L_MODULEANDAU
  add constraint PK_L_MODULEANDAU primary key (MODULEID, CONFIGID);

prompt
prompt Creating table M_AGENTTRADER
prompt ============================
prompt
create table M_AGENTTRADER
(
  agenttraderid VARCHAR2(40) not null,
  name          VARCHAR2(16),
  password      VARCHAR2(64) not null,
  type          NUMBER(2) default 0 not null,
  status        NUMBER(2) default 0 not null,
  operatefirm   CLOB,
  createtime    DATE default sysdate,
  modifytime    DATE
)
;
comment on table M_AGENTTRADER
  is '代为委托员表';
comment on column M_AGENTTRADER.type
  is '0 代为委托员
1 强平员';
comment on column M_AGENTTRADER.status
  is '0 正常
1 禁止登陆';
comment on column M_AGENTTRADER.operatefirm
  is '空表示所有
否则交易商用逗号分隔，如 0001,0002,0003';
comment on column M_AGENTTRADER.modifytime
  is '最后一次修改时间';
alter table M_AGENTTRADER
  add constraint PK_M_CONSIGNER primary key (AGENTTRADERID);

prompt
prompt Creating table M_CATEGORY
prompt =========================
prompt
create table M_CATEGORY
(
  categoryid       NUMBER(10) not null,
  categoryname     VARCHAR2(64) not null,
  note             VARCHAR2(256),
  type             VARCHAR2(64) not null,
  sortno           NUMBER(10) not null,
  parentcategoryid NUMBER(10),
  status           NUMBER(1) default 1,
  isoffset         CHAR(1) default 'Y' not null,
  offsetrate       NUMBER(5,4) default 0.05 not null,
  belongmodule     VARCHAR2(30)
)
;
comment on column M_CATEGORY.type
  is 'breed：品种
category：分类
leaf：叶子节点';
comment on column M_CATEGORY.status
  is '1：正常 2：已删除';
comment on column M_CATEGORY.isoffset
  is 'Y:此品种可能出现损溢 N:此品种不可能出现损溢';
comment on column M_CATEGORY.offsetrate
  is '申请损益万分比<1';
comment on column M_CATEGORY.belongmodule
  is '分类所属模块 以|分割';
alter table M_CATEGORY
  add constraint PK_M_CATEGORY primary key (CATEGORYID);

prompt
prompt Creating table M_BREED
prompt ======================
prompt
create table M_BREED
(
  breedid      NUMBER(10) not null,
  breedname    VARCHAR2(32) not null,
  unit         VARCHAR2(16) not null,
  trademode    NUMBER(1) default 1 not null,
  categoryid   NUMBER(10) not null,
  status       NUMBER(1) default 1,
  picture      BLOB,
  belongmodule VARCHAR2(30),
  sortno       NUMBER(10)
)
;
comment on column M_BREED.trademode
  is '交易模式 1：诚信保障金模式 2：保证金模式';
comment on column M_BREED.status
  is '1：正常 2：已删除';
comment on column M_BREED.belongmodule
  is '分类所属模块 以|分割';
alter table M_BREED
  add constraint PK_M_BREED primary key (BREEDID);
alter table M_BREED
  add constraint REFM_CATEGORY22 foreign key (CATEGORYID)
  references M_CATEGORY (CATEGORYID)
  disable
  novalidate;

prompt
prompt Creating table M_PROPERTYTYPE
prompt =============================
prompt
create table M_PROPERTYTYPE
(
  propertytypeid NUMBER(15) not null,
  name           VARCHAR2(64) not null,
  status         NUMBER(2) default 0 not null,
  sortno         NUMBER(2) not null
)
;
comment on column M_PROPERTYTYPE.status
  is '0 可见 1 不可见';
alter table M_PROPERTYTYPE
  add constraint PK_M_PROPERTYTYPE primary key (PROPERTYTYPEID);

prompt
prompt Creating table M_PROPERTY
prompt =========================
prompt
create table M_PROPERTY
(
  propertyid     NUMBER(10) not null,
  categoryid     NUMBER(10) not null,
  propertyname   VARCHAR2(64) not null,
  hasvaluedict   CHAR(1) not null,
  stockcheck     CHAR(1) not null,
  searchable     CHAR(1) not null,
  sortno         NUMBER(10) not null,
  isnecessary    CHAR(1) default 'Y' not null,
  fieldtype      NUMBER(2) default 0 not null,
  propertytypeid NUMBER(15) not null
)
;
comment on column M_PROPERTY.hasvaluedict
  is 'Y：有值字典  N：无值字典';
comment on column M_PROPERTY.stockcheck
  is 'Y：检查  N：不检查 M：不完全检查(选择多个值，匹配其中之一)';
comment on column M_PROPERTY.searchable
  is 'Y：用于列表搜索 N：不用于搜索';
comment on column M_PROPERTY.isnecessary
  is 'Y：必填项；N：选填项';
comment on column M_PROPERTY.fieldtype
  is '0：字符串；1：数字';
create index UK_M_PROPERTY on M_PROPERTY (CATEGORYID, PROPERTYNAME);
alter table M_PROPERTY
  add constraint PK_M_PROPERTY primary key (PROPERTYID);
alter table M_PROPERTY
  add constraint REFM_CATEGORY25 foreign key (CATEGORYID)
  references M_CATEGORY (CATEGORYID)
  disable
  novalidate;
alter table M_PROPERTY
  add constraint REFM_PROPERTYTYPE32 foreign key (PROPERTYTYPEID)
  references M_PROPERTYTYPE (PROPERTYTYPEID)
  disable
  novalidate;

prompt
prompt Creating table M_BREEDPROPS
prompt ===========================
prompt
create table M_BREEDPROPS
(
  breedid       NUMBER(10) not null,
  propertyid    NUMBER(10) not null,
  propertyvalue VARCHAR2(64) not null,
  sortno        NUMBER(10) not null
)
;
comment on table M_BREEDPROPS
  is '品名对应的属性值列表，有哪些属性来自商品分类属性表
';
alter table M_BREEDPROPS
  add constraint PK_M_BREEDPROPS primary key (BREEDID, PROPERTYID, PROPERTYVALUE);
alter table M_BREEDPROPS
  add constraint REFM_BREED24 foreign key (BREEDID)
  references M_BREED (BREEDID)
  disable
  novalidate;
alter table M_BREEDPROPS
  add constraint REFM_PROPERTY23 foreign key (PROPERTYID)
  references M_PROPERTY (PROPERTYID)
  disable
  novalidate;

prompt
prompt Creating table M_CERTIFICATETYPE
prompt ================================
prompt
create table M_CERTIFICATETYPE
(
  code      NUMBER(2) not null,
  name      VARCHAR2(32) not null,
  isvisibal CHAR(1) default 'Y' not null,
  sortno    NUMBER(2) default 0 not null
)
;
comment on column M_CERTIFICATETYPE.isvisibal
  is 'Y 显示 N 不显示';
alter table M_CERTIFICATETYPE
  add constraint PK_M_CERTIFICATETYPE primary key (CODE);

prompt
prompt Creating table M_ERRORLOGINLOG
prompt ==============================
prompt
create table M_ERRORLOGINLOG
(
  traderid  VARCHAR2(40) not null,
  logindate DATE not null,
  moduleid  NUMBER(2) not null,
  ip        VARCHAR2(32) not null
)
;
comment on column M_ERRORLOGINLOG.moduleid
  is '10综合管理平台
11财务系统
12监管仓库管理系统
13仓单管理系统
14融资系统
15订单交易
18投资类大宗商品交易系统
19加盟会员管理系统
20做市商交易系统
21竞价系统
22银行接入及结算系统
23E现货
24单点登录系统
25实时行情分析系统
26交易客户端
98demo系统
99公用系统';

prompt
prompt Creating table M_FIRM
prompt =====================
prompt
create table M_FIRM
(
  firmid                  VARCHAR2(32) not null,
  name                    VARCHAR2(32) not null,
  fullname                VARCHAR2(128),
  type                    NUMBER(2) not null,
  contactman              VARCHAR2(32) not null,
  certificatetype         NUMBER(2) not null,
  certificateno           VARCHAR2(32) not null,
  phone                   VARCHAR2(32),
  mobile                  NUMBER(12) not null,
  fax                     VARCHAR2(16),
  address                 VARCHAR2(128),
  postcode                VARCHAR2(16),
  email                   VARCHAR2(64),
  zonecode                VARCHAR2(16) default 'none',
  industrycode            VARCHAR2(16) default 'none',
  firmcategoryid          NUMBER(10) default -1 not null,
  organizationcode        VARCHAR2(9),
  corporaterepresentative VARCHAR2(32),
  note                    VARCHAR2(1024),
  extenddata              VARCHAR2(4000),
  createtime              DATE default sysdate not null,
  modifytime              DATE,
  status                  CHAR(1) default 'N' not null,
  applyid                 NUMBER(10)
)
;
comment on column M_FIRM.type
  is '1：法人
2：代理
3：个人';
comment on column M_FIRM.firmcategoryid
  is '-1 表示未分类';
comment on column M_FIRM.status
  is 'N：正常 Normal
D：冻结 Disable
E：注销 Erase';
alter table M_FIRM
  add constraint PK_M_FIRM primary key (FIRMID);

prompt
prompt Creating table M_FIRMCATEGORY
prompt =============================
prompt
create table M_FIRMCATEGORY
(
  id        NUMBER(10) not null,
  name      VARCHAR2(128) default '未分类' not null,
  note      VARCHAR2(128),
  isvisibal CHAR(1) default 'Y' not null,
  sortno    NUMBER(2) default 0 not null
)
;
comment on column M_FIRMCATEGORY.isvisibal
  is 'Y 显示 N 不显示';
alter table M_FIRMCATEGORY
  add constraint PK_M_FIRMCATEGORY primary key (ID);

prompt
prompt Creating table M_FIRMMODULE
prompt ===========================
prompt
create table M_FIRMMODULE
(
  moduleid NUMBER(2) not null,
  firmid   VARCHAR2(32) not null,
  enabled  CHAR(1) default 'N' not null
)
;
comment on table M_FIRMMODULE
  is '交易商在各个交易模块是否可用';
comment on column M_FIRMMODULE.moduleid
  is '10综合管理平台
11财务系统
12监管仓库管理系统
13仓单管理系统
14融资系统
15订单交易
18投资类大宗商品交易系统
19加盟会员管理系统
20做市商交易系统
21竞价系统
22银行接入及结算系统
23E现货
24单点登录系统
25实时行情分析系统
26交易客户端
98demo系统
99公用系统';
comment on column M_FIRMMODULE.enabled
  is 'Y：启用  N：禁用';
alter table M_FIRMMODULE
  add constraint PK_M_FIRMMODULE primary key (MODULEID, FIRMID);

prompt
prompt Creating table M_FIRM_APPLY
prompt ===========================
prompt
create table M_FIRM_APPLY
(
  applyid                 NUMBER(10) not null,
  userid                  VARCHAR2(32) not null,
  password                VARCHAR2(32),
  name                    VARCHAR2(32) not null,
  fullname                VARCHAR2(128),
  type                    NUMBER(2),
  contactman              VARCHAR2(32),
  certificatetype         NUMBER(2),
  certificateno           VARCHAR2(32),
  phone                   VARCHAR2(32),
  mobile                  NUMBER(12),
  fax                     VARCHAR2(16),
  address                 VARCHAR2(128),
  postcode                VARCHAR2(16),
  email                   VARCHAR2(64),
  zonecode                VARCHAR2(16) default 'none',
  industrycode            VARCHAR2(16) default 'none',
  organizationcode        VARCHAR2(9),
  corporaterepresentative VARCHAR2(32),
  note                    VARCHAR2(1024),
  extenddata              VARCHAR2(4000),
  createtime              DATE default sysdate not null,
  modifytime              DATE,
  status                  NUMBER(1) default 0 not null,
  auditnote               VARCHAR2(256),
  brokerid                VARCHAR2(32),
  picture                 BLOB,
  picturecs               BLOB,
  pictureos               BLOB,
  yingyepic               BLOB,
  shuiwupic               BLOB,
  zuzhipic                BLOB,
  kaihupic                BLOB
)
;
comment on column M_FIRM_APPLY.type
  is '1：法人
2：代理
3：个人';
comment on column M_FIRM_APPLY.status
  is '0：待审核
1：审核通过
2：审核不通过';
alter table M_FIRM_APPLY
  add constraint PK_M_FIRM_APPLY primary key (APPLYID);

prompt
prompt Creating table M_INDUSTRY
prompt =========================
prompt
create table M_INDUSTRY
(
  code      VARCHAR2(16) not null,
  name      VARCHAR2(32) not null,
  isvisibal CHAR(1) default 'Y' not null,
  sortno    NUMBER(2) default 0 not null
)
;
comment on column M_INDUSTRY.isvisibal
  is 'Y 显示 N 不显示';
alter table M_INDUSTRY
  add constraint PK_M_INDUSTRY primary key (CODE);

prompt
prompt Creating table M_MESSAGE
prompt ========================
prompt
create table M_MESSAGE
(
  messageid    NUMBER(10) not null,
  message      VARCHAR2(256) not null,
  recievertype NUMBER(2) not null,
  traderid     VARCHAR2(40),
  createtime   DATE,
  userid       VARCHAR2(32) not null
)
;
comment on column M_MESSAGE.recievertype
  is '接收人类型：1 在线交易员 2 在线管理员 3 在线用户 4 指定交易员 5 指定管理员';
comment on column M_MESSAGE.userid
  is '管理员Id';
alter table M_MESSAGE
  add constraint PK_M_MESSAGE primary key (MESSAGEID);

prompt
prompt Creating table M_NOTICE
prompt =======================
prompt
create table M_NOTICE
(
  noticeid   NUMBER(10) not null,
  title      VARCHAR2(64) not null,
  content    VARCHAR2(4000),
  createtime DATE,
  userid     VARCHAR2(32) not null
)
;
comment on column M_NOTICE.userid
  is '管理员Id';
alter table M_NOTICE
  add constraint PK_M_NOTICE primary key (NOTICEID);

prompt
prompt Creating table M_PROCEDURES_ERRORCODE
prompt =====================================
prompt
create table M_PROCEDURES_ERRORCODE
(
  moduleid  NUMBER(2) not null,
  errorcode NUMBER(12) not null,
  errorinfo VARCHAR2(1024)
)
;
comment on table M_PROCEDURES_ERRORCODE
  is '交易商添加修改删除存储的错误码记录';
comment on column M_PROCEDURES_ERRORCODE.moduleid
  is '10综合管理平台
11财务系统
12监管仓库管理系统
13仓单管理系统
14融资系统
15订单交易
18投资类大宗商品交易系统
19加盟会员管理系统
20做市商交易系统
21竞价系统
22银行接入及结算系统
23E现货
24单点登录系统
25实时行情分析系统
26交易客户端
98demo系统
99公用系统';
alter table M_PROCEDURES_ERRORCODE
  add constraint PK_M_TRADERMODULE_1 primary key (MODULEID, ERRORCODE);

prompt
prompt Creating table M_SYSTEMPROPS
prompt ============================
prompt
create table M_SYSTEMPROPS
(
  key          VARCHAR2(32) not null,
  value        VARCHAR2(64) not null,
  runtimevalue VARCHAR2(64),
  note         VARCHAR2(128),
  firmidlength VARCHAR2(32) default '15' not null
)
;
comment on column M_SYSTEMPROPS.value
  is '手续费、保证金等参数设置';
alter table M_SYSTEMPROPS
  add constraint PK_M_SYSTEMPROPS primary key (KEY);

prompt
prompt Creating table M_TRADER
prompt =======================
prompt
create table M_TRADER
(
  traderid       VARCHAR2(40) not null,
  firmid         VARCHAR2(32) not null,
  name           VARCHAR2(32) not null,
  userid         VARCHAR2(32),
  password       VARCHAR2(32) not null,
  forcechangepwd NUMBER(1) default 1 not null,
  status         CHAR(1) default 'N' not null,
  type           CHAR(1) not null,
  createtime     DATE default sysdate,
  modifytime     DATE,
  keycode        VARCHAR2(32),
  enablekey      CHAR(1) not null,
  trustkey       VARCHAR2(64),
  lastip         VARCHAR2(16),
  lasttime       DATE,
  skin           VARCHAR2(16) default 'default' not null
)
;
comment on table M_TRADER
  is '交易员表，每个交易商有个与交易商ID相同的交易员作为默认交易员，不可删除。';
comment on column M_TRADER.forcechangepwd
  is '0：否
1：是';
comment on column M_TRADER.status
  is 'N：正常 Normal
D：禁用 Disable';
comment on column M_TRADER.type
  is 'A：管理员
N：一般交易员';
comment on column M_TRADER.modifytime
  is '最后一次修改时间';
comment on column M_TRADER.enablekey
  is 'Y：启用
N：不启用';
comment on column M_TRADER.trustkey
  is '客户端登录成功后，在本地和服务端记录一个信任Key，不限制重试次数。';
alter table M_TRADER
  add constraint PK_M_TRADER primary key (TRADERID);
alter table M_TRADER
  add constraint REFM_FIRM28 foreign key (FIRMID)
  references M_FIRM (FIRMID)
  disable
  novalidate;

prompt
prompt Creating table M_TRADERMODULE
prompt =============================
prompt
create table M_TRADERMODULE
(
  moduleid NUMBER(2) not null,
  traderid VARCHAR2(40) not null,
  enabled  CHAR(1) default 'N' not null
)
;
comment on table M_TRADERMODULE
  is '交易员在各个交易模块是否可用';
comment on column M_TRADERMODULE.moduleid
  is '10综合管理平台
11财务系统
12监管仓库管理系统
13仓单管理系统
14融资系统
15订单交易
18投资类大宗商品交易系统
19加盟会员管理系统
20做市商交易系统
21竞价系统
22银行接入及结算系统
23E现货
24单点登录系统
25实时行情分析系统
26交易客户端
98demo系统
99公用系统';
comment on column M_TRADERMODULE.enabled
  is 'Y：启用  N：禁用';
alter table M_TRADERMODULE
  add constraint PK_M_TRADERMODULE primary key (MODULEID, TRADERID);

prompt
prompt Creating table M_ZONE
prompt =====================
prompt
create table M_ZONE
(
  code      VARCHAR2(16) not null,
  name      VARCHAR2(32) not null,
  isvisibal CHAR(1) default 'Y' not null,
  sortno    NUMBER(2) default 0 not null
)
;
comment on column M_ZONE.isvisibal
  is 'Y 显示 N 不显示';
alter table M_ZONE
  add constraint PK_M_ZONE primary key (CODE);

prompt
prompt Creating table TM_TRADEMONITOR
prompt ==============================
prompt
create table TM_TRADEMONITOR
(
  id           NUMBER(15) not null,
  moduleid     NUMBER(2) not null,
  type         VARCHAR2(256) not null,
  num          NUMBER(15) not null,
  datetime     DATE not null,
  categorytype VARCHAR2(256)
)
;
alter table TM_TRADEMONITOR
  add constraint PK_TM_TRADEMONITOR primary key (ID);

prompt
prompt Creating table TM_TRADEMONITOR_H
prompt ================================
prompt
create table TM_TRADEMONITOR_H
(
  id           NUMBER(15) not null,
  moduleid     NUMBER(2) not null,
  type         VARCHAR2(256) not null,
  num          NUMBER(15) not null,
  datetime     DATE not null,
  categorytype VARCHAR2(256)
)
;
alter table TM_TRADEMONITOR_H
  add constraint PK_TM_TRADEMONITOR_H primary key (ID);

prompt
prompt Creating table T_APPLY
prompt ======================
prompt
create table T_APPLY
(
  id          NUMBER(10) not null,
  applytype   NUMBER(4) not null,
  status      NUMBER(4) not null,
  proposer    VARCHAR2(64) not null,
  applytime   DATE default sysdate not null,
  approver    VARCHAR2(64),
  approvetime DATE,
  content     SYS.XMLTYPE not null,
  note        VARCHAR2(1024)
)
;
alter table T_APPLY
  add constraint T_APPLY_PK primary key (ID);

prompt
prompt Creating table T_A_BREED
prompt ========================
prompt
create table T_A_BREED
(
  breedid               NUMBER(10) not null,
  breedname             VARCHAR2(32) not null,
  sortid                NUMBER(10) not null,
  contractfactor        NUMBER(12,2),
  minpricemove          NUMBER(10,2) not null,
  spreadalgr            NUMBER(1) not null,
  spreaduplmt           NUMBER(10,2) not null,
  spreaddownlmt         NUMBER(10,2) not null,
  feealgr               NUMBER(1) not null,
  feerate_b             NUMBER(15,9) not null,
  feerate_s             NUMBER(15,9) not null,
  marginalgr            NUMBER(1) not null,
  marginrate_b          NUMBER(10,4) default 0 not null,
  marginrate_s          NUMBER(10,4) default 0 not null,
  marginassure_b        NUMBER(10,4) default 0 not null,
  marginassure_s        NUMBER(10,4) default 0 not null,
  todayclosefeerate_b   NUMBER(15,9) default 0 not null,
  todayclosefeerate_s   NUMBER(15,9) default 0 not null,
  historyclosefeerate_b NUMBER(15,9) default 0 not null,
  historyclosefeerate_s NUMBER(15,9) default 0 not null,
  limitcmdtyqty         NUMBER(10) default -1 not null,
  settlefeealgr         NUMBER(1) not null,
  settlefeerate_b       NUMBER(15,9) default 0 not null,
  settlefeerate_s       NUMBER(15,9) default 0 not null,
  forceclosefeealgr     NUMBER(1) not null,
  forceclosefeerate_b   NUMBER(15,9) default 0 not null,
  forceclosefeerate_s   NUMBER(15,9) default 0 not null,
  settlemarginalgr_b    NUMBER(1) not null,
  settlemarginrate_b    NUMBER(10,4) default 0 not null,
  settlemarginalgr_s    NUMBER(1) not null,
  settlemarginrate_s    NUMBER(10,4) default 0 not null,
  addedtax              NUMBER(10,4) default 0 not null,
  marginpricetype       NUMBER(1) default 0 not null,
  lowestsettlefee       NUMBER(15,2) default 0 not null,
  limitbreedqty         NUMBER(10) default -1 not null,
  firmcleanqty          NUMBER(10) default -1 not null,
  firmmaxholdqty        NUMBER(10) default -1 not null,
  marginitem1           NUMBER(15,2),
  marginitem2           NUMBER(15,2),
  marginitem3           NUMBER(15,2),
  marginitem4           NUMBER(15,2),
  marginitem1_s         NUMBER(15,2),
  marginitem2_s         NUMBER(15,2),
  marginitem3_s         NUMBER(15,2),
  marginitem4_s         NUMBER(15,2),
  marginitemassure1     NUMBER(15,2),
  marginitemassure2     NUMBER(15,2),
  marginitemassure3     NUMBER(15,2),
  marginitemassure4     NUMBER(15,2),
  marginitemassure1_s   NUMBER(15,2),
  marginitemassure2_s   NUMBER(15,2),
  marginitemassure3_s   NUMBER(15,2),
  marginitemassure4_s   NUMBER(15,2),
  orderprivilege        NUMBER(6) default 101 not null,
  payoutalgr            NUMBER(1) not null,
  payoutrate            NUMBER(10,4) default 0 not null,
  addedtaxfactor        NUMBER(13,10) default 0 not null,
  marginitem5           NUMBER(15,2),
  marginitem5_s         NUMBER(15,2),
  marginitemassure5     NUMBER(15,2),
  marginitemassure5_s   NUMBER(15,2),
  settlepricetype       NUMBER(2) default 0 not null,
  beforedays            NUMBER(4),
  specsettleprice       NUMBER(10,2),
  firmmaxholdqtyalgr    NUMBER(1) default 2 not null,
  startpercentqty       NUMBER(10) default 0 not null,
  maxpercentlimit       NUMBER(7,4) default 0 not null,
  onemaxholdqty         NUMBER(10) default -1 not null,
  minquantitymove       NUMBER(3) default 1 not null,
  contractfactorname    VARCHAR2(10),
  delayrecouprate       NUMBER(7,5) default 0 not null,
  settleway             NUMBER(2) default 0 not null,
  delayfeeway           NUMBER(2) default 1 not null,
  maxfeerate            NUMBER(15,9),
  minsettlemoveqty      NUMBER(5) default 1 not null,
  breedtrademode        NUMBER(2) default 0 not null,
  storerecouprate       NUMBER(7,5) default 0 not null,
  minsettleqty          NUMBER(10) default 1 not null,
  delayrecouprate_s     NUMBER(7,5) default 0 not null,
  delaysettlepricetype  NUMBER(2) default 0,
  aheadsettlepricetype  NUMBER(2) default 0,
  settlemargintype      NUMBER(2) default 0,
  beforedays_m          NUMBER(2) default 0,
  sideholdlimitqty      NUMBER(10) default -1,
  holddayslimit         NUMBER(1) default 0 not null,
  maxholdpositionday    NUMBER(10)
)
;
alter table T_A_BREED
  add constraint PK_T_A_BREED primary key (BREEDID);

prompt
prompt Creating table T_A_BREEDTRADEPROP
prompt =================================
prompt
create table T_A_BREEDTRADEPROP
(
  breedid    NUMBER(10) not null,
  sectionid  NUMBER(4) not null,
  modifytime DATE not null
)
;
alter table T_A_BREEDTRADEPROP
  add constraint PK_T_A_BREEDTRADEPROP primary key (BREEDID, SECTIONID);

prompt
prompt Creating table T_A_CMDTYSORT
prompt ============================
prompt
create table T_A_CMDTYSORT
(
  sortid   NUMBER(10) not null,
  sortname VARCHAR2(30) not null
)
;
alter table T_A_CMDTYSORT
  add constraint PK_T_A_CMDTYSORT primary key (SORTID);

prompt
prompt Creating table T_A_COMMODITYSETTLEPROP
prompt ======================================
prompt
create table T_A_COMMODITYSETTLEPROP
(
  commodityid VARCHAR2(16) not null,
  sectionid   NUMBER(4) not null,
  modifytime  DATE not null
)
;
alter table T_A_COMMODITYSETTLEPROP
  add constraint PK_T_A_COMMODITYSETTLEPROP primary key (COMMODITYID, SECTIONID);

prompt
prompt Creating table T_A_COMMODITYTRADEPROP
prompt =====================================
prompt
create table T_A_COMMODITYTRADEPROP
(
  commodityid VARCHAR2(16) not null,
  sectionid   NUMBER(4) not null,
  modifytime  DATE not null
)
;
alter table T_A_COMMODITYTRADEPROP
  add constraint PK_T_A_COMMODITYTRADEPROP primary key (COMMODITYID, SECTIONID);

prompt
prompt Creating table T_A_DAYSECTION
prompt =============================
prompt
create table T_A_DAYSECTION
(
  weekday    NUMBER(2) not null,
  sectionid  NUMBER(4) not null,
  status     NUMBER(2) default 0 not null,
  modifytime DATE not null
)
;
alter table T_A_DAYSECTION
  add constraint PK_T_A_DAYSECTION primary key (WEEKDAY, SECTIONID);

prompt
prompt Creating table T_A_DELAYTRADETIME
prompt =================================
prompt
create table T_A_DELAYTRADETIME
(
  sectionid  NUMBER(4) not null,
  name       VARCHAR2(20),
  starttime  VARCHAR2(10) not null,
  endtime    VARCHAR2(10) not null,
  type       NUMBER(2) default 0 not null,
  status     NUMBER(2) not null,
  modifytime DATE not null
)
;
alter table T_A_DELAYTRADETIME
  add constraint PK_T_A_DELAYTRADETIME primary key (SECTIONID);

prompt
prompt Creating table T_A_FIRMBREEDFEE
prompt ===============================
prompt
create table T_A_FIRMBREEDFEE
(
  firmid                VARCHAR2(32) not null,
  breedid               NUMBER(10) not null,
  feealgr               NUMBER(1) not null,
  feerate_b             NUMBER(15,9) not null,
  feerate_s             NUMBER(15,9) not null,
  todayclosefeerate_b   NUMBER(15,9) default 0 not null,
  todayclosefeerate_s   NUMBER(15,9) default 0 not null,
  historyclosefeerate_b NUMBER(15,9) default 0 not null,
  historyclosefeerate_s NUMBER(15,9) default 0 not null,
  forceclosefeealgr     NUMBER(1) not null,
  forceclosefeerate_b   NUMBER(15,9) default 0 not null,
  forceclosefeerate_s   NUMBER(15,9) default 0 not null,
  modifytime            DATE not null
)
;
alter table T_A_FIRMBREEDFEE
  add constraint PK_T_A_FIRMBREEDFEE primary key (FIRMID, BREEDID);

prompt
prompt Creating table T_A_FIRMBREEDMARGIN
prompt ==================================
prompt
create table T_A_FIRMBREEDMARGIN
(
  firmid              VARCHAR2(32) not null,
  breedid             NUMBER(10) not null,
  marginalgr          NUMBER(1) not null,
  marginrate_b        NUMBER(10,4) default 0 not null,
  marginrate_s        NUMBER(10,4) default 0 not null,
  marginitem1         NUMBER(15,2),
  marginitem2         NUMBER(15,2),
  marginitem3         NUMBER(15,2),
  marginitem4         NUMBER(15,2),
  marginitem1_s       NUMBER(15,2),
  marginitem2_s       NUMBER(15,2),
  marginitem3_s       NUMBER(15,2),
  marginitem4_s       NUMBER(15,2),
  marginassure_b      NUMBER(10,4) default 0 not null,
  marginassure_s      NUMBER(10,4) default 0 not null,
  marginitemassure1   NUMBER(15,2),
  marginitemassure2   NUMBER(15,2),
  marginitemassure3   NUMBER(15,2),
  marginitemassure4   NUMBER(15,2),
  marginitemassure1_s NUMBER(15,2),
  marginitemassure2_s NUMBER(15,2),
  marginitemassure3_s NUMBER(15,2),
  marginitemassure4_s NUMBER(15,2),
  modifytime          DATE not null,
  marginitem5         NUMBER(15,2),
  marginitem5_s       NUMBER(15,2),
  marginitemassure5   NUMBER(15,2),
  marginitemassure5_s NUMBER(15,2)
)
;
alter table T_A_FIRMBREEDMARGIN
  add constraint PK_T_A_FIRMBREEDMARGIN primary key (FIRMID, BREEDID);

prompt
prompt Creating table T_A_FIRMBREEDMAXHOLDQTY
prompt ======================================
prompt
create table T_A_FIRMBREEDMAXHOLDQTY
(
  firmid          VARCHAR2(32) not null,
  breedid         NUMBER(10) not null,
  maxholdqty      NUMBER(10) default -1 not null,
  cleanmaxholdqty NUMBER(10) default -1 not null,
  modifytime      DATE not null
)
;
alter table T_A_FIRMBREEDMAXHOLDQTY
  add constraint PK_T_A_FIRMBREEDMAXHOLDQTY primary key (FIRMID, BREEDID);

prompt
prompt Creating table T_A_FIRMBREEDSETTLEFEE
prompt =====================================
prompt
create table T_A_FIRMBREEDSETTLEFEE
(
  firmid          VARCHAR2(32) not null,
  breedid         NUMBER(10) not null,
  settlefeealgr   NUMBER(1) not null,
  settlefeerate_b NUMBER(15,9) default 0 not null,
  settlefeerate_s NUMBER(15,9) default 0 not null,
  modifytime      DATE not null
)
;
alter table T_A_FIRMBREEDSETTLEFEE
  add constraint PK_T_A_FIRMBREEDSETTLEFEE primary key (FIRMID, BREEDID);

prompt
prompt Creating table T_A_FIRMBREEDSETTLEMARGIN
prompt ========================================
prompt
create table T_A_FIRMBREEDSETTLEMARGIN
(
  firmid             VARCHAR2(32) not null,
  breedid            NUMBER(10) not null,
  settlemarginalgr_b NUMBER(1) not null,
  settlemarginrate_b NUMBER(10,4) default 0 not null,
  settlemarginalgr_s NUMBER(1) not null,
  settlemarginrate_s NUMBER(10,4) default 0 not null,
  payoutalgr         NUMBER(1) not null,
  payoutrate         NUMBER(10,4) default 0 not null,
  modifytime         DATE not null
)
;
alter table T_A_FIRMBREEDSETTLEMARGIN
  add constraint PK_T_A_FIRMBREEDSETTLEMARGIN primary key (FIRMID, BREEDID);

prompt
prompt Creating table T_A_FIRMFEE
prompt ==========================
prompt
create table T_A_FIRMFEE
(
  firmid                VARCHAR2(32) not null,
  commodityid           VARCHAR2(16) not null,
  feealgr               NUMBER(1) not null,
  feerate_b             NUMBER(15,9) not null,
  feerate_s             NUMBER(15,9) not null,
  todayclosefeerate_b   NUMBER(15,9) default 0 not null,
  todayclosefeerate_s   NUMBER(15,9) default 0 not null,
  historyclosefeerate_b NUMBER(15,9) default 0 not null,
  historyclosefeerate_s NUMBER(15,9) default 0 not null,
  forceclosefeealgr     NUMBER(1) not null,
  forceclosefeerate_b   NUMBER(15,9) default 0 not null,
  forceclosefeerate_s   NUMBER(15,9) default 0 not null,
  modifytime            DATE not null
)
;
alter table T_A_FIRMFEE
  add constraint PK_T_A_FIRMFEE primary key (FIRMID, COMMODITYID);

prompt
prompt Creating table T_A_FIRMMARGIN
prompt =============================
prompt
create table T_A_FIRMMARGIN
(
  firmid              VARCHAR2(32) not null,
  commodityid         VARCHAR2(16) not null,
  marginalgr          NUMBER(1) not null,
  marginrate_b        NUMBER(10,4) default 0 not null,
  marginrate_s        NUMBER(10,4) default 0 not null,
  marginitem1         NUMBER(15,2),
  marginitem2         NUMBER(15,2),
  marginitem3         NUMBER(15,2),
  marginitem4         NUMBER(15,2),
  marginitem1_s       NUMBER(15,2),
  marginitem2_s       NUMBER(15,2),
  marginitem3_s       NUMBER(15,2),
  marginitem4_s       NUMBER(15,2),
  marginassure_b      NUMBER(10,4) default 0 not null,
  marginassure_s      NUMBER(10,4) default 0 not null,
  marginitemassure1   NUMBER(15,2),
  marginitemassure2   NUMBER(15,2),
  marginitemassure3   NUMBER(15,2),
  marginitemassure4   NUMBER(15,2),
  marginitemassure1_s NUMBER(15,2),
  marginitemassure2_s NUMBER(15,2),
  marginitemassure3_s NUMBER(15,2),
  marginitemassure4_s NUMBER(15,2),
  modifytime          DATE not null,
  marginitem5         NUMBER(15,2),
  marginitem5_s       NUMBER(15,2),
  marginitemassure5   NUMBER(15,2),
  marginitemassure5_s NUMBER(15,2)
)
;
alter table T_A_FIRMMARGIN
  add constraint PK_T_A_FIRMMARGIN primary key (FIRMID, COMMODITYID);

prompt
prompt Creating table T_A_FIRMMAXHOLDQTY
prompt =================================
prompt
create table T_A_FIRMMAXHOLDQTY
(
  firmid          VARCHAR2(32) not null,
  commodityid     VARCHAR2(16) not null,
  maxholdqty      NUMBER(10) default -1 not null,
  cleanmaxholdqty NUMBER(10) default -1 not null,
  modifytime      DATE not null
)
;
alter table T_A_FIRMMAXHOLDQTY
  add constraint PK_T_A_FIRMMAXHOLDQTY primary key (FIRMID, COMMODITYID);

prompt
prompt Creating table T_A_FIRMSETTLEFEE
prompt ================================
prompt
create table T_A_FIRMSETTLEFEE
(
  firmid          VARCHAR2(32) not null,
  commodityid     VARCHAR2(16) not null,
  settlefeealgr   NUMBER(1) not null,
  settlefeerate_b NUMBER(15,9) default 0 not null,
  settlefeerate_s NUMBER(15,9) default 0 not null,
  modifytime      DATE not null
)
;
alter table T_A_FIRMSETTLEFEE
  add constraint PK_T_A_FIRMSETTLEFEE primary key (FIRMID, COMMODITYID);

prompt
prompt Creating table T_A_FIRMSETTLEMARGIN
prompt ===================================
prompt
create table T_A_FIRMSETTLEMARGIN
(
  firmid             VARCHAR2(32) not null,
  commodityid        VARCHAR2(16) not null,
  settlemarginalgr_b NUMBER(1) not null,
  settlemarginrate_b NUMBER(10,4) default 0 not null,
  settlemarginalgr_s NUMBER(1) not null,
  settlemarginrate_s NUMBER(10,4) default 0 not null,
  payoutalgr         NUMBER(1) not null,
  payoutrate         NUMBER(10,4) default 0 not null,
  modifytime         DATE not null
)
;
alter table T_A_FIRMSETTLEMARGIN
  add constraint PK_T_A_FIRMSETTLEMARGIN primary key (FIRMID, COMMODITYID);

prompt
prompt Creating table T_A_MARKET
prompt =========================
prompt
create table T_A_MARKET
(
  marketcode              CHAR(2) not null,
  marketname              VARCHAR2(64),
  status                  NUMBER(2) default 1 not null,
  shortname               VARCHAR2(20),
  runmode                 NUMBER(2) default 1 not null,
  settlemode              NUMBER(2) default 0 not null,
  marginfbflag            NUMBER(1) default 0 not null,
  floatinglosscomputetype NUMBER(1) default 0 not null,
  closealgr               NUMBER(2) default 0 not null,
  tradepricealgr          NUMBER(2) default 0 not null,
  tradeflowtype           NUMBER(2) default 0 not null,
  floatingprofitsubtax    NUMBER(1) default 0 not null,
  gagemode                NUMBER(2) default 0 not null,
  tradetimetype           NUMBER(2) default 0 not null,
  delayquoshowtype        NUMBER(2) default 1 not null,
  neutralfeeway           NUMBER(2) default 0 not null,
  delayneedbill           NUMBER(2) default 0 not null,
  neutralflag             NUMBER(2) default 0 not null,
  neutralmatchpriority    NUMBER(2) default 0 not null,
  quotationtwoside        NUMBER(2) default 2 not null,
  asmargintype            NUMBER(2) default 0,
  delayorderispure        NUMBER(1) default 0 not null,
  chargedelayfeetype      NUMBER(2) default 0 not null
)
;
alter table T_A_MARKET
  add constraint PK_T_A_MARKET primary key (MARKETCODE);

prompt
prompt Creating table T_A_NOTTRADEDAY
prompt ==============================
prompt
create table T_A_NOTTRADEDAY
(
  id         NUMBER(10) not null,
  week       VARCHAR2(30),
  day        VARCHAR2(1024),
  modifytime DATE not null
)
;
alter table T_A_NOTTRADEDAY
  add constraint PK_T_A_NOTTRADEDAY primary key (ID);

prompt
prompt Creating table T_A_SETTLEPRIVILEGE
prompt ==================================
prompt
create table T_A_SETTLEPRIVILEGE
(
  id              NUMBER(15) not null,
  type            NUMBER(2) not null,
  typeid          VARCHAR2(16) not null,
  kind            NUMBER(2),
  kindid          VARCHAR2(24),
  privilegecode_b NUMBER(6) not null,
  privilegecode_s NUMBER(6) not null
)
;
alter table T_A_SETTLEPRIVILEGE
  add constraint PK_T_A_SETTLEPRIVILEGE primary key (ID);

prompt
prompt Creating table T_A_TARIFF
prompt =========================
prompt
create table T_A_TARIFF
(
  tariffid              VARCHAR2(6) not null,
  commodityid           VARCHAR2(16) not null,
  tariffname            VARCHAR2(32) not null,
  tariffrate            NUMBER(10,2) not null,
  feealgr               NUMBER(1) not null,
  feerate_b             NUMBER(15,9) not null,
  feerate_s             NUMBER(15,9) not null,
  todayclosefeerate_b   NUMBER(15,9) not null,
  todayclosefeerate_s   NUMBER(15,9) not null,
  historyclosefeerate_b NUMBER(15,9) not null,
  historyclosefeerate_s NUMBER(15,9) not null,
  forceclosefeealgr     NUMBER(1) not null,
  forceclosefeerate_b   NUMBER(15,9) not null,
  forceclosefeerate_s   NUMBER(15,9) not null,
  createtime            DATE default sysdate not null,
  createuser            VARCHAR2(32),
  modifytime            DATE default sysdate not null
)
;
alter table T_A_TARIFF
  add constraint PK_T_A_TARIFF primary key (TARIFFID, COMMODITYID);

prompt
prompt Creating table T_A_TRADEPRIVILEGE
prompt =================================
prompt
create table T_A_TRADEPRIVILEGE
(
  id              NUMBER(15) not null,
  type            NUMBER(2) not null,
  typeid          VARCHAR2(40) not null,
  kind            NUMBER(2),
  kindid          VARCHAR2(24),
  privilegecode_b NUMBER(6) not null,
  privilegecode_s NUMBER(6)
)
;
alter table T_A_TRADEPRIVILEGE
  add constraint PK_T_A_TRADEPRIVILEGE primary key (ID);

prompt
prompt Creating table T_A_TRADETIME
prompt ============================
prompt
create table T_A_TRADETIME
(
  sectionid    NUMBER(4) not null,
  name         VARCHAR2(20),
  starttime    VARCHAR2(10) not null,
  endtime      VARCHAR2(10) not null,
  status       NUMBER(2) not null,
  gatherbid    NUMBER(1) default 0 not null,
  bidstarttime VARCHAR2(10),
  bidendtime   VARCHAR2(10),
  modifytime   DATE not null,
  startdate    VARCHAR2(16),
  enddate      VARCHAR2(16),
  bidstartdate VARCHAR2(16),
  bidenddate   VARCHAR2(16)
)
;
alter table T_A_TRADETIME
  add constraint PK_T_A_TRADETIME primary key (SECTIONID);

prompt
prompt Creating table T_BALANCESTATUS
prompt ==============================
prompt
create table T_BALANCESTATUS
(
  b_date    DATE not null,
  status    NUMBER(2) not null,
  note      VARCHAR2(256),
  cleartime DATE
)
;
alter table T_BALANCESTATUS
  add constraint PK_B_DATE primary key (B_DATE);

prompt
prompt Creating table T_BILLFROZEN
prompt ===========================
prompt
create table T_BILLFROZEN
(
  id            NUMBER(15) not null,
  operation     VARCHAR2(20),
  billid        VARCHAR2(32) not null,
  operationtype NUMBER(2),
  modifytime    DATE not null
)
;
alter table T_BILLFROZEN
  add constraint PK_T_BILLFROZEN primary key (ID);

prompt
prompt Creating table T_BR_FIRMREWARDDEAIL
prompt ===================================
prompt
create table T_BR_FIRMREWARDDEAIL
(
  firmid           VARCHAR2(32) not null,
  commodityid      VARCHAR2(16) not null,
  cleardate        DATE not null,
  rewardtype       NUMBER(2) not null,
  brokerid         VARCHAR2(16) not null,
  brokername       VARCHAR2(128),
  firstpay         NUMBER(15,2) not null,
  secondpay        NUMBER(15,2) not null,
  reward           NUMBER(15,2) not null,
  marketreward     NUMBER(15,2) not null,
  brokereachdivide NUMBER(15,2) not null,
  quantity         NUMBER(10) not null,
  trademoney       NUMBER(15,2) not null,
  brokerageid      VARCHAR2(32),
  brokeragename    VARCHAR2(64)
)
;
alter table T_BR_FIRMREWARDDEAIL
  add constraint PK_T_BR_FIRMREWARDDEAIL primary key (FIRMID, COMMODITYID, CLEARDATE, REWARDTYPE);

prompt
prompt Creating table T_CLEARSTATUS
prompt ============================
prompt
create table T_CLEARSTATUS
(
  actionid   NUMBER(3) not null,
  actionnote VARCHAR2(32) not null,
  status     CHAR(1) not null,
  finishtime DATE
)
;
alter table T_CLEARSTATUS
  add constraint PK_ACTIONID primary key (ACTIONID);

prompt
prompt Creating table T_COMMODITY
prompt ==========================
prompt
create table T_COMMODITY
(
  commodityid           VARCHAR2(16) not null,
  name                  VARCHAR2(32) not null,
  sortid                NUMBER(10) not null,
  status                NUMBER(2) not null,
  contractfactor        NUMBER(12,2) not null,
  minpricemove          NUMBER(10,2) not null,
  breedid               NUMBER(10) not null,
  spreadalgr            NUMBER(1) not null,
  spreaduplmt           NUMBER(10,2) not null,
  spreaddownlmt         NUMBER(10,2) not null,
  feealgr               NUMBER(1) not null,
  feerate_b             NUMBER(15,9) not null,
  feerate_s             NUMBER(15,9) not null,
  marginalgr            NUMBER(1) not null,
  marginrate_b          NUMBER(10,4) default 0 not null,
  marginrate_s          NUMBER(10,4) default 0 not null,
  marketdate            DATE,
  settledate            DATE not null,
  settledate1           DATE,
  marginitem1           NUMBER(15,2),
  settledate2           DATE,
  marginitem2           NUMBER(15,2),
  settledate3           DATE,
  marginitem3           NUMBER(15,2),
  settledate4           DATE,
  marginitem4           NUMBER(15,2),
  lastprice             NUMBER(10,2) not null,
  marginitem1_s         NUMBER(15,2),
  marginitem2_s         NUMBER(15,2),
  marginitem3_s         NUMBER(15,2),
  marginitem4_s         NUMBER(15,2),
  marginassure_b        NUMBER(10,4) default 0 not null,
  marginassure_s        NUMBER(10,4) default 0 not null,
  marginitemassure1     NUMBER(15,2),
  marginitemassure2     NUMBER(15,2),
  marginitemassure3     NUMBER(15,2),
  marginitemassure4     NUMBER(15,2),
  marginitemassure1_s   NUMBER(15,2),
  marginitemassure2_s   NUMBER(15,2),
  marginitemassure3_s   NUMBER(15,2),
  marginitemassure4_s   NUMBER(15,2),
  todayclosefeerate_b   NUMBER(15,9) default 0 not null,
  todayclosefeerate_s   NUMBER(15,9) default 0 not null,
  historyclosefeerate_b NUMBER(15,9) default 0 not null,
  historyclosefeerate_s NUMBER(15,9) default 0 not null,
  limitcmdtyqty         NUMBER(10) default -1 not null,
  settlefeealgr         NUMBER(1) not null,
  settlefeerate_b       NUMBER(15,9) default 0 not null,
  settlefeerate_s       NUMBER(15,9) default 0 not null,
  forceclosefeealgr     NUMBER(1) not null,
  forceclosefeerate_b   NUMBER(15,9) default 0 not null,
  forceclosefeerate_s   NUMBER(15,9) default 0 not null,
  settlemarginalgr_b    NUMBER(1) not null,
  settlemarginrate_b    NUMBER(10,4) default 0 not null,
  settlemarginalgr_s    NUMBER(1) not null,
  settlemarginrate_s    NUMBER(10,4) default 0 not null,
  reservecount          NUMBER(10) default 0 not null,
  addedtax              NUMBER(10,4) default 0 not null,
  marginpricetype       NUMBER(1) default 0 not null,
  lowestsettlefee       NUMBER(15,2) default 0 not null,
  firmcleanqty          NUMBER(10) default -1 not null,
  firmmaxholdqty        NUMBER(10) default -1 not null,
  payoutalgr            NUMBER(1) not null,
  payoutrate            NUMBER(10,4) default 0 not null,
  addedtaxfactor        NUMBER(13,10) default 0 not null,
  settledate5           DATE,
  marginitem5           NUMBER(15,2),
  marginitem5_s         NUMBER(15,2),
  marginitemassure5     NUMBER(15,2),
  marginitemassure5_s   NUMBER(15,2),
  settlepricetype       NUMBER(2) default 0 not null,
  beforedays            NUMBER(4),
  specsettleprice       NUMBER(10,2),
  orderprivilege_b      NUMBER(6) default 101 not null,
  orderprivilege_s      NUMBER(6) default 101 not null,
  firmmaxholdqtyalgr    NUMBER(1) default 2 not null,
  startpercentqty       NUMBER(10) default 0 not null,
  maxpercentlimit       NUMBER(7,4) default 0 not null,
  onemaxholdqty         NUMBER(10) default -1 not null,
  minquantitymove       NUMBER(3) default 1 not null,
  delayrecouprate       NUMBER(7,5) default 0 not null,
  settleway             NUMBER(2) default 0 not null,
  delayfeeway           NUMBER(2) default 1 not null,
  maxfeerate            NUMBER(15,9),
  minsettlemoveqty      NUMBER(5) default 1 not null,
  storerecouprate       NUMBER(7,5) default 0 not null,
  minsettleqty          NUMBER(10) default 1 not null,
  delayrecouprate_s     NUMBER(7,5) default 0 not null,
  aheadsettlepricetype  NUMBER(2) default 0,
  delaysettlepricetype  NUMBER(2) default 0,
  settlemargintype      NUMBER(2) default 0,
  beforedays_m          NUMBER(2) default 0,
  sideholdlimitqty      NUMBER(10) default -1,
  holddayslimit         NUMBER(1) default 0 not null,
  maxholdpositionday    NUMBER(10),
  taxinclusive          NUMBER(1) default 1
)
;
alter table T_COMMODITY
  add constraint PK_T_COMMODITY primary key (COMMODITYID);

prompt
prompt Creating table T_CONDITIONORDER
prompt ===============================
prompt
create table T_CONDITIONORDER
(
  a_orderno            NUMBER(15) not null,
  commodityid          VARCHAR2(16) not null,
  customerid           VARCHAR2(40) not null,
  traderid             VARCHAR2(40) not null,
  bs_flag              NUMBER(2) not null,
  ordertype            NUMBER(2) not null,
  price                NUMBER(10,2) not null,
  quantity             NUMBER(10) not null,
  conditiontype        NUMBER(2),
  conditionoperation   NUMBER(2),
  conditionprice       NUMBER(10,2) not null,
  conditioncommodityid VARCHAR2(16) not null,
  firmid               VARCHAR2(32) not null,
  retcode              NUMBER(4),
  updatetime           TIMESTAMP(6),
  validdate            DATE,
  sendstatus           NUMBER(2) default 0 not null,
  successtime          TIMESTAMP(6)
)
;
alter table T_CONDITIONORDER
  add constraint PK_T_CONDITIONORDER primary key (A_ORDERNO);

prompt
prompt Creating table T_CURMINNO
prompt =========================
prompt
create table T_CURMINNO
(
  tradedate NUMBER(10) not null,
  a_orderno NUMBER(15) default 0 not null,
  a_tradeno NUMBER(15) default 0 not null,
  a_holdno  NUMBER(15) default 0 not null
)
;
alter table T_CURMINNO
  add constraint PK_T_CURMINNO primary key (TRADEDATE);

prompt
prompt Creating table T_CUSTOMER
prompt =========================
prompt
create table T_CUSTOMER
(
  customerid VARCHAR2(40) not null,
  firmid     VARCHAR2(32) not null,
  code       VARCHAR2(6) not null,
  name       VARCHAR2(16),
  status     NUMBER(2) default 0 not null,
  createtime DATE not null,
  modifytime DATE
)
;
create unique index UK_T_CUSTOMER on T_CUSTOMER (FIRMID, CODE);
alter table T_CUSTOMER
  add constraint PK_T_CUSTOMER primary key (CUSTOMERID);

prompt
prompt Creating table T_CUSTOMERHOLDSUM
prompt ================================
prompt
create table T_CUSTOMERHOLDSUM
(
  customerid    VARCHAR2(40) not null,
  commodityid   VARCHAR2(16) not null,
  bs_flag       NUMBER(2) not null,
  holdqty       NUMBER(10) not null,
  holdfunds     NUMBER(15,2) not null,
  floatingloss  NUMBER(15,2) not null,
  evenprice     NUMBER(16,6) not null,
  frozenqty     NUMBER(10) not null,
  holdmargin    NUMBER(15,2) default 0 not null,
  gageqty       NUMBER(10) default 0 not null,
  holdassure    NUMBER(15,2) default 0 not null,
  firmid        VARCHAR2(32) not null,
  gagefrozenqty NUMBER(10) default 0 not null
)
;
create index IX_T_CUSTOMERHOLDSUM on T_CUSTOMERHOLDSUM (FIRMID, COMMODITYID, BS_FLAG);
alter table T_CUSTOMERHOLDSUM
  add constraint PK_T_CUSTOMERHOLDSUM primary key (CUSTOMERID, COMMODITYID, BS_FLAG);

prompt
prompt Creating table T_DBLOG
prompt ======================
prompt
create table T_DBLOG
(
  err_date  DATE not null,
  name_proc VARCHAR2(30),
  err_code  NUMBER(10),
  err_msg   VARCHAR2(200)
)
;

prompt
prompt Creating table T_DELAYORDERS
prompt ============================
prompt
create table T_DELAYORDERS
(
  a_orderno      NUMBER(15) not null,
  commodityid    VARCHAR2(16) not null,
  customerid     VARCHAR2(40) not null,
  traderid       VARCHAR2(40),
  bs_flag        NUMBER(2) not null,
  delayordertype NUMBER(2) not null,
  status         NUMBER(2) not null,
  withdrawtype   NUMBER(2),
  quantity       NUMBER(10) not null,
  price          NUMBER(10,2),
  tradeqty       NUMBER(10) default 0,
  frozenfunds    NUMBER(15,2) default 0,
  unfrozenfunds  NUMBER(15,2) default 0,
  ordertime      DATE not null,
  withdrawtime   DATE,
  ordererip      VARCHAR2(64),
  signature      VARCHAR2(256),
  firmid         VARCHAR2(32) not null,
  consignerid    VARCHAR2(10),
  withdrawerid   VARCHAR2(40)
)
;
alter table T_DELAYORDERS
  add constraint PK_T_DELAYORDERS primary key (A_ORDERNO);

prompt
prompt Creating table T_DELAYQUOTATION
prompt ===============================
prompt
create table T_DELAYQUOTATION
(
  commodityid       VARCHAR2(16) not null,
  buysettleqty      NUMBER(10) not null,
  sellsettleqty     NUMBER(10) not null,
  buyneutralqty     NUMBER(10) not null,
  sellneutralqty    NUMBER(10) not null,
  createtime        DATE,
  neutralside       NUMBER(2) default 0 not null,
  delaycleanholdqty NUMBER(10) default 0 not null
)
;
alter table T_DELAYQUOTATION
  add constraint PK_T_DELAYQUOTATION primary key (COMMODITYID);

prompt
prompt Creating table T_DELAYSTATUS
prompt ============================
prompt
create table T_DELAYSTATUS
(
  tradedate   DATE not null,
  status      NUMBER(2) default 3 not null,
  sectionid   NUMBER(4),
  note        VARCHAR2(256),
  recovertime VARCHAR2(10)
)
;
alter table T_DELAYSTATUS
  add constraint PK_T_DELAYSTATUS primary key (TRADEDATE);

prompt
prompt Creating table T_DELAYTRADE
prompt ===========================
prompt
create table T_DELAYTRADE
(
  a_tradeno      NUMBER(15) not null,
  a_orderno      NUMBER(15) not null,
  tradetime      DATE not null,
  customerid     VARCHAR2(40) not null,
  commodityid    VARCHAR2(16) not null,
  bs_flag        NUMBER(2) not null,
  delayordertype NUMBER(2) not null,
  quantity       NUMBER(10) not null,
  tradetype      NUMBER(2) not null,
  firmid         VARCHAR2(32) not null
)
;
alter table T_DELAYTRADE
  add constraint PK_T_DELAYTRADE primary key (A_TRADENO);

prompt
prompt Creating table T_D_DELAYORDERLOG
prompt ================================
prompt
create table T_D_DELAYORDERLOG
(
  id           NUMBER(15) not null,
  firmid       VARCHAR2(32) not null,
  ordertype    NUMBER(2) not null,
  commodityid  VARCHAR2(16) not null,
  a_holdno     NUMBER(15) not null,
  settleprice  NUMBER(15) not null,
  quantity     NUMBER(15,2) not null,
  settlemargin NUMBER(15,2) default 0 not null,
  trademargin  NUMBER(15,2) not null,
  payout       NUMBER(15) not null,
  actiontime   DATE not null,
  expandxml    VARCHAR2(65)
)
;
alter table T_D_DELAYORDERLOG
  add constraint PK_T_D_DELAYORDERLOG primary key (ID);

prompt
prompt Creating table T_D_DELAYORDERSUMLOG
prompt ===================================
prompt
create table T_D_DELAYORDERSUMLOG
(
  id           NUMBER(15) not null,
  firmid       VARCHAR2(32) not null,
  ordertype    NUMBER(2) not null,
  commodityid  VARCHAR2(16) not null,
  settleprice  NUMBER(15,2) not null,
  quantity     NUMBER(15,2) not null,
  settlemargin NUMBER(15,2) default 0 not null,
  trademargin  NUMBER(15,2) not null,
  payout       NUMBER(15) not null,
  a_funds      NUMBER(15,2) not null,
  f_funds      NUMBER(15,2) not null,
  actiontime   DATE not null,
  expandxml    VARCHAR2(64)
)
;
alter table T_D_DELAYORDERSUMLOG
  add constraint PK_T_D_DELAYORDERSUMLOG primary key (ID);

prompt
prompt Creating table T_E_APPLYAHEADSETTLE
prompt ===================================
prompt
create table T_E_APPLYAHEADSETTLE
(
  applyid      VARCHAR2(15) not null,
  commodityid  VARCHAR2(16) not null,
  customerid_s VARCHAR2(40),
  customerid_b VARCHAR2(40),
  price        NUMBER(10,2),
  quantity     NUMBER(10) not null,
  status       NUMBER(2) not null,
  createtime   DATE not null,
  creator      VARCHAR2(20) not null,
  remark1      VARCHAR2(256),
  modifytime   DATE,
  modifier     VARCHAR2(20),
  remark2      VARCHAR2(256)
)
;
alter table T_E_APPLYAHEADSETTLE
  add constraint PK_T_E_APPLYAHEADSETTLE_1 primary key (APPLYID);

prompt
prompt Creating table T_E_APPLYGAGE
prompt ============================
prompt
create table T_E_APPLYGAGE
(
  applyid     NUMBER(15) not null,
  commodityid VARCHAR2(16) not null,
  firmid      VARCHAR2(32) not null,
  customerid  VARCHAR2(40) not null,
  quantity    NUMBER(10) not null,
  applytype   NUMBER(2) not null,
  status      NUMBER(2) not null,
  createtime  DATE not null,
  creator     VARCHAR2(20) not null,
  remark1     VARCHAR2(256),
  modifytime  DATE,
  modifier    VARCHAR2(20),
  remark2     VARCHAR2(256)
)
;
alter table T_E_APPLYGAGE
  add constraint PK_T_E_APPLYGAGE primary key (APPLYID);

prompt
prompt Creating table T_E_APPLYTREATYSETTLE
prompt ====================================
prompt
create table T_E_APPLYTREATYSETTLE
(
  applyid      NUMBER(15) not null,
  commodityid  VARCHAR2(16) not null,
  customerid_s VARCHAR2(40),
  customerid_b VARCHAR2(40),
  price        NUMBER(10,2),
  quantity     NUMBER(10) not null,
  status       NUMBER(2) not null,
  createtime   DATE not null,
  creator      VARCHAR2(20) not null,
  remark1      VARCHAR2(256),
  modifytime   DATE,
  modifier     VARCHAR2(20),
  remark2      VARCHAR2(256)
)
;
alter table T_E_APPLYTREATYSETTLE
  add constraint PK_T_E_APPLYTREATYSETTLE primary key (APPLYID);

prompt
prompt Creating table T_E_DEDUCTDETAIL
prompt ===============================
prompt
create table T_E_DEDUCTDETAIL
(
  deductid        NUMBER(10) not null,
  customerid      VARCHAR2(40) not null,
  wl              CHAR(1),
  buyqty          NUMBER(10),
  sellqty         NUMBER(10),
  buykeepqty      NUMBER(10),
  sellkeepqty     NUMBER(10),
  pureholdqty     NUMBER(10),
  pl              NUMBER(15,2),
  pl_ratio        NUMBER(10,3),
  counteractqty   NUMBER(10),
  orderqty        NUMBER(10),
  deductableqty   NUMBER(10),
  estimateqty     NUMBER(10,2),
  deductqty       NUMBER(10),
  deductedqty     NUMBER(10),
  counteractedqty NUMBER(10)
)
;
alter table T_E_DEDUCTDETAIL
  add constraint PK_T_E_DEDUCTDETAIL primary key (DEDUCTID, CUSTOMERID);

prompt
prompt Creating table T_E_DEDUCTKEEP
prompt =============================
prompt
create table T_E_DEDUCTKEEP
(
  deductid   NUMBER(10) not null,
  bs_flag    NUMBER(2) not null,
  customerid VARCHAR2(40) not null,
  keepqty    NUMBER(10) not null
)
;
alter table T_E_DEDUCTKEEP
  add constraint PK_T_E_DEDUCTKEEP primary key (DEDUCTID, BS_FLAG, CUSTOMERID);

prompt
prompt Creating table T_E_DEDUCTPOSITION
prompt =================================
prompt
create table T_E_DEDUCTPOSITION
(
  deductid       NUMBER(10) not null,
  deductdate     DATE not null,
  commodityid    VARCHAR2(16) not null,
  deductstatus   CHAR(1) default 'N' not null,
  deductprice    NUMBER(10,2) not null,
  loserbsflag    NUMBER(1) not null,
  losermode      NUMBER(1) not null,
  lossrate       NUMBER(5,2) not null,
  selfcounteract NUMBER(1) not null,
  profitlvl1     NUMBER(5,3) default 0 not null,
  profitlvl2     NUMBER(5,3) default 0 not null,
  profitlvl3     NUMBER(5,3) default 0 not null,
  profitlvl4     NUMBER(5,3) default 0 not null,
  profitlvl5     NUMBER(5,3) default 0 not null,
  exectime       DATE,
  alert          VARCHAR2(1024)
)
;
alter table T_E_DEDUCTPOSITION
  add constraint PK_T_E_DEDUCTPOSITION primary key (DEDUCTID);

prompt
prompt Creating table T_E_DIRECTFIRMBREED
prompt ==================================
prompt
create table T_E_DIRECTFIRMBREED
(
  firmid  VARCHAR2(32) not null,
  breedid NUMBER(10) not null
)
;
alter table T_E_DIRECTFIRMBREED
  add constraint PK_T_E_DIRECTFIRMBREED primary key (FIRMID, BREEDID);

prompt
prompt Creating table T_E_GAGEBILL
prompt ===========================
prompt
create table T_E_GAGEBILL
(
  id          NUMBER(20) not null,
  firmid      VARCHAR2(32) not null,
  commodityid VARCHAR2(16) not null,
  quantity    NUMBER(10) not null,
  remark      VARCHAR2(256),
  createtime  DATE not null,
  modifytime  DATE not null
)
;
alter table T_E_GAGEBILL
  add constraint PK_T_E_GAGEBILL primary key (ID);

prompt
prompt Creating table T_E_HISGAGEBILL
prompt ==============================
prompt
create table T_E_HISGAGEBILL
(
  cleardate   DATE not null,
  id          NUMBER(20) not null,
  firmid      VARCHAR2(32) not null,
  commodityid VARCHAR2(16) not null,
  quantity    NUMBER(10) not null,
  remark      VARCHAR2(256),
  createtime  DATE not null,
  modifytime  DATE not null
)
;
alter table T_E_HISGAGEBILL
  add constraint PK_T_E_HISGAGEBILL primary key (CLEARDATE, ID);

prompt
prompt Creating table T_E_PLEDGE
prompt =========================
prompt
create table T_E_PLEDGE
(
  id         NUMBER(15) not null,
  billid     VARCHAR2(32) not null,
  billfund   NUMBER(15,2) default 0 not null,
  firmid     VARCHAR2(32) not null,
  breedname  VARCHAR2(32) not null,
  quantity   NUMBER(10) not null,
  createtime DATE not null,
  creator    VARCHAR2(20) not null,
  modifytime DATE,
  modifier   VARCHAR2(20),
  status     NUMBER(2) default 0 not null,
  type       NUMBER(2) not null
)
;
alter table T_E_PLEDGE
  add constraint PK_T_E_PLEDGE primary key (ID);

prompt
prompt Creating table T_FIRM
prompt =====================
prompt
create table T_FIRM
(
  firmid              VARCHAR2(32) not null,
  status              NUMBER(2) not null,
  maxholdqty          NUMBER(10) default -1 not null,
  mincleardeposit     NUMBER(15,2) default 0 not null,
  maxoverdraft        NUMBER(15,2) default 0 not null,
  virtualfunds        NUMBER(15,2) default 0 not null,
  runtimefl           NUMBER(15,2) default 0 not null,
  clearfl             NUMBER(15,2) default 0 not null,
  runtimemargin       NUMBER(15,2) default 0 not null,
  clearmargin         NUMBER(15,2) default 0 not null,
  runtimeassure       NUMBER(15,2) default 0 not null,
  clearassure         NUMBER(15,2) default 0 not null,
  runtimesettlemargin NUMBER(15,2) default 0 not null,
  clearsettlemargin   NUMBER(15,2) default 0 not null,
  tariffid            VARCHAR2(6) default 'none' not null,
  modifytime          DATE not null
)
;
alter table T_FIRM
  add constraint PK_T_FIRM primary key (FIRMID);

prompt
prompt Creating table T_FIRMHOLDSUM
prompt ============================
prompt
create table T_FIRMHOLDSUM
(
  firmid       VARCHAR2(32) not null,
  commodityid  VARCHAR2(16) not null,
  bs_flag      NUMBER(2) not null,
  holdqty      NUMBER(10) not null,
  holdfunds    NUMBER(15,2) not null,
  floatingloss NUMBER(15,2) not null,
  evenprice    NUMBER(16,6) not null,
  holdmargin   NUMBER(15,2) default 0 not null,
  gageqty      NUMBER(10) default 0 not null,
  holdassure   NUMBER(15,2) default 0 not null
)
;
alter table T_FIRMHOLDSUM
  add constraint PK_T_FIRMHOLDSUM primary key (FIRMID, COMMODITYID, BS_FLAG);

prompt
prompt Creating table T_HOLDFROZEN
prompt ===========================
prompt
create table T_HOLDFROZEN
(
  id          NUMBER(20) not null,
  operation   VARCHAR2(20),
  firmid      VARCHAR2(32) not null,
  customerid  VARCHAR2(40) not null,
  commodityid VARCHAR2(16) not null,
  bs_flag     NUMBER(2) not null,
  frozentype  NUMBER(2),
  frozenqty   NUMBER(15) default 0 not null,
  frozentime  TIMESTAMP(6)
)
;
alter table T_HOLDFROZEN
  add constraint PK_T_HOLDFROZEN primary key (ID);

prompt
prompt Creating table T_HOLDPOSITION
prompt =============================
prompt
create table T_HOLDPOSITION
(
  a_holdno     NUMBER(15) not null,
  a_tradeno    NUMBER(15) not null,
  customerid   VARCHAR2(40) not null,
  commodityid  VARCHAR2(16) not null,
  bs_flag      NUMBER(2) not null,
  price        NUMBER(10,2) not null,
  holdqty      NUMBER(10) not null,
  openqty      NUMBER(10) not null,
  holdtime     DATE not null,
  holdmargin   NUMBER(15,2) default 0 not null,
  firmid       VARCHAR2(32) not null,
  gageqty      NUMBER(10) default 0 not null,
  holdassure   NUMBER(15,2) default 0 not null,
  floatingloss NUMBER(15,2) default 0 not null,
  holdtype     NUMBER(2) default 1 not null,
  atcleardate  DATE default trunc(sysdate) not null,
  deadline     DATE,
  remainday    NUMBER(10)
)
;
create index IX_T_HOLDPOSITION on T_HOLDPOSITION (CUSTOMERID, COMMODITYID, BS_FLAG);
create index IX_T_HOLDPOSITION_F_C_B on T_HOLDPOSITION (FIRMID, COMMODITYID, BS_FLAG);
alter table T_HOLDPOSITION
  add constraint PK_T_HOLDPOSITION primary key (A_HOLDNO);

prompt
prompt Creating table T_H_COMMODITY
prompt ============================
prompt
create table T_H_COMMODITY
(
  cleardate             DATE not null,
  commodityid           VARCHAR2(16) not null,
  name                  VARCHAR2(32) not null,
  sortid                NUMBER(10) not null,
  status                NUMBER(2) not null,
  contractfactor        NUMBER(12,2) not null,
  minpricemove          NUMBER(10,2) not null,
  breedid               NUMBER(10) not null,
  spreadalgr            NUMBER(1) not null,
  spreaduplmt           NUMBER(10,2) not null,
  spreaddownlmt         NUMBER(10,2) not null,
  feealgr               NUMBER(1) not null,
  feerate_b             NUMBER(15,9) not null,
  feerate_s             NUMBER(15,9) not null,
  marginalgr            NUMBER(1) not null,
  marginrate_b          NUMBER(10,4) default 0 not null,
  marginrate_s          NUMBER(10,4) default 0 not null,
  marketdate            DATE,
  settledate            DATE not null,
  settledate1           DATE,
  marginitem1           NUMBER(15,2),
  settledate2           DATE,
  marginitem2           NUMBER(15,2),
  settledate3           DATE,
  marginitem3           NUMBER(15,2),
  settledate4           DATE,
  marginitem4           NUMBER(15,2),
  lastprice             NUMBER(10,2) not null,
  marginitem1_s         NUMBER(15,2),
  marginitem2_s         NUMBER(15,2),
  marginitem3_s         NUMBER(15,2),
  marginitem4_s         NUMBER(15,2),
  marginassure_b        NUMBER(10,4) default 0 not null,
  marginassure_s        NUMBER(10,4) default 0 not null,
  marginitemassure1     NUMBER(15,2),
  marginitemassure2     NUMBER(15,2),
  marginitemassure3     NUMBER(15,2),
  marginitemassure4     NUMBER(15,2),
  marginitemassure1_s   NUMBER(15,2),
  marginitemassure2_s   NUMBER(15,2),
  marginitemassure3_s   NUMBER(15,2),
  marginitemassure4_s   NUMBER(15,2),
  todayclosefeerate_b   NUMBER(15,9) default 0 not null,
  todayclosefeerate_s   NUMBER(15,9) default 0 not null,
  historyclosefeerate_b NUMBER(15,9) default 0 not null,
  historyclosefeerate_s NUMBER(15,9) default 0 not null,
  limitcmdtyqty         NUMBER(10) default -1 not null,
  settlefeealgr         NUMBER(1) not null,
  settlefeerate_b       NUMBER(15,9) default 0 not null,
  settlefeerate_s       NUMBER(15,9) default 0 not null,
  forceclosefeealgr     NUMBER(1) not null,
  forceclosefeerate_b   NUMBER(15,9) default 0 not null,
  forceclosefeerate_s   NUMBER(15,9) default 0 not null,
  settlemarginalgr_b    NUMBER(1) not null,
  settlemarginrate_b    NUMBER(10,4) default 0 not null,
  settlemarginalgr_s    NUMBER(1) not null,
  settlemarginrate_s    NUMBER(10,4) default 0 not null,
  reservecount          NUMBER(10) default 0 not null,
  addedtax              NUMBER(10,4) default 0 not null,
  marginpricetype       NUMBER(1) default 0 not null,
  lowestsettlefee       NUMBER(15,2) default 0 not null,
  firmcleanqty          NUMBER(10) default -1 not null,
  firmmaxholdqty        NUMBER(10) default -1 not null,
  payoutalgr            NUMBER(1) not null,
  payoutrate            NUMBER(10,4) default 0 not null,
  addedtaxfactor        NUMBER(13,10) default 0 not null,
  settledate5           DATE,
  marginitem5           NUMBER(15,2),
  marginitem5_s         NUMBER(15,2),
  marginitemassure5     NUMBER(15,2),
  marginitemassure5_s   NUMBER(15,2),
  settlepricetype       NUMBER(2) default 0 not null,
  beforedays            NUMBER(4),
  specsettleprice       NUMBER(10,2),
  orderprivilege_b      NUMBER(6) default 101 not null,
  orderprivilege_s      NUMBER(6) default 101 not null,
  firmmaxholdqtyalgr    NUMBER(1) default 2 not null,
  startpercentqty       NUMBER(10) default 0 not null,
  maxpercentlimit       NUMBER(7,4) default 0 not null,
  onemaxholdqty         NUMBER(10) default -1 not null,
  minquantitymove       NUMBER(3) default 1 not null,
  delayrecouprate       NUMBER(7,5) default 0 not null,
  settleway             NUMBER(2) default 0 not null,
  delayfeeway           NUMBER(2) default 1 not null,
  maxfeerate            NUMBER(15,9),
  minsettlemoveqty      NUMBER(5) default 1 not null,
  storerecouprate       NUMBER(7,5) default 0 not null,
  minsettleqty          NUMBER(10) default 1 not null,
  delayrecouprate_s     NUMBER(7,5) default 0 not null,
  aheadsettlepricetype  NUMBER(2) default 0,
  delaysettlepricetype  NUMBER(2) default 0,
  settlemargintype      NUMBER(2) default 0,
  beforedays_m          NUMBER(2) default 0,
  sideholdlimitqty      NUMBER(10) default -1,
  holddayslimit         NUMBER(1) default 0 not null,
  maxholdpositionday    NUMBER(10),
  taxinclusive          NUMBER(1)
)
;
alter table T_H_COMMODITY
  add constraint PK_T_H_COMMODITY primary key (CLEARDATE, COMMODITYID);

prompt
prompt Creating table T_H_CONDITIONORDER
prompt =================================
prompt
create table T_H_CONDITIONORDER
(
  cleardate            DATE not null,
  a_orderno            NUMBER(15) not null,
  commodityid          VARCHAR2(16) not null,
  customerid           VARCHAR2(40) not null,
  traderid             VARCHAR2(40) not null,
  bs_flag              NUMBER(2) not null,
  ordertype            NUMBER(2) not null,
  price                NUMBER(10,2) not null,
  quantity             NUMBER(10) not null,
  conditiontype        NUMBER(2),
  conditionoperation   NUMBER(2),
  conditionprice       NUMBER(10,2) not null,
  conditioncommodityid VARCHAR2(16) not null,
  firmid               VARCHAR2(32) not null,
  retcode              NUMBER(4),
  updatetime           TIMESTAMP(6),
  validdate            DATE,
  sendstatus           NUMBER(2) default 0 not null,
  successtime          TIMESTAMP(6)
)
;
alter table T_H_CONDITIONORDER
  add constraint PK_T_H_CONDITIONORDER primary key (CLEARDATE, A_ORDERNO);

prompt
prompt Creating table T_H_CUSTOMERHOLDSUM
prompt ==================================
prompt
create table T_H_CUSTOMERHOLDSUM
(
  cleardate     DATE not null,
  customerid    VARCHAR2(40) not null,
  commodityid   VARCHAR2(16) not null,
  bs_flag       NUMBER(2) not null,
  holdqty       NUMBER(10) not null,
  holdfunds     NUMBER(15,2) not null,
  floatingloss  NUMBER(15,2) not null,
  evenprice     NUMBER(16,6) not null,
  frozenqty     NUMBER(10) not null,
  holdmargin    NUMBER(15,2) default 0 not null,
  gageqty       NUMBER(10) default 0 not null,
  holdassure    NUMBER(15,2) default 0 not null,
  firmid        VARCHAR2(32) not null,
  gagefrozenqty NUMBER(10) default 0 not null
)
;
alter table T_H_CUSTOMERHOLDSUM
  add constraint PK_T_H_CUSTOMERHOLDSUM primary key (CLEARDATE, CUSTOMERID, COMMODITYID, BS_FLAG);

prompt
prompt Creating table T_H_DELAYORDERS
prompt ==============================
prompt
create table T_H_DELAYORDERS
(
  cleardate      DATE not null,
  a_orderno      NUMBER(15) not null,
  commodityid    VARCHAR2(16) not null,
  customerid     VARCHAR2(40) not null,
  traderid       VARCHAR2(40),
  bs_flag        NUMBER(2) not null,
  delayordertype NUMBER(2) not null,
  status         NUMBER(2) not null,
  withdrawtype   NUMBER(2),
  quantity       NUMBER(10) not null,
  price          NUMBER(10,2),
  tradeqty       NUMBER(10) default 0,
  frozenfunds    NUMBER(15,2) default 0,
  unfrozenfunds  NUMBER(15,2) default 0,
  ordertime      DATE not null,
  withdrawtime   DATE,
  ordererip      VARCHAR2(64),
  signature      VARCHAR2(256),
  firmid         VARCHAR2(32) not null,
  consignerid    VARCHAR2(10),
  withdrawerid   VARCHAR2(40)
)
;
alter table T_H_DELAYORDERS
  add constraint PK_T_H_DELAYORDERS primary key (CLEARDATE, A_ORDERNO);

prompt
prompt Creating table T_H_DELAYQUOTATION
prompt =================================
prompt
create table T_H_DELAYQUOTATION
(
  cleardate         DATE not null,
  commodityid       VARCHAR2(16) not null,
  buysettleqty      NUMBER(10) not null,
  sellsettleqty     NUMBER(10) not null,
  buyneutralqty     NUMBER(10) not null,
  sellneutralqty    NUMBER(10) not null,
  createtime        DATE,
  neutralside       NUMBER(2) default 0 not null,
  delaycleanholdqty NUMBER(10) default 0 not null
)
;
alter table T_H_DELAYQUOTATION
  add constraint PK_T_H_DELAYQUOTATION primary key (CLEARDATE, COMMODITYID);

prompt
prompt Creating table T_H_DELAYTRADE
prompt =============================
prompt
create table T_H_DELAYTRADE
(
  cleardate      DATE not null,
  a_tradeno      NUMBER(15) not null,
  a_orderno      NUMBER(15) not null,
  tradetime      DATE not null,
  customerid     VARCHAR2(40) not null,
  commodityid    VARCHAR2(16) not null,
  bs_flag        NUMBER(2) not null,
  delayordertype NUMBER(2) not null,
  quantity       NUMBER(10) not null,
  tradetype      NUMBER(2) not null,
  firmid         VARCHAR2(32) not null
)
;
alter table T_H_DELAYTRADE
  add constraint PK_T_H_DELAYTRADE primary key (CLEARDATE, A_TRADENO);

prompt
prompt Creating table T_H_DIRECTFIRMBREED
prompt ==================================
prompt
create table T_H_DIRECTFIRMBREED
(
  deletedate DATE not null,
  firmid     VARCHAR2(32) not null,
  breedid    NUMBER(10) not null
)
;
alter table T_H_DIRECTFIRMBREED
  add constraint PK_T_H_DIRECTFIRMBREED primary key (DELETEDATE, FIRMID, BREEDID);

prompt
prompt Creating table T_H_FIRM
prompt =======================
prompt
create table T_H_FIRM
(
  cleardate           DATE not null,
  firmid              VARCHAR2(32) not null,
  status              NUMBER(2) not null,
  maxholdqty          NUMBER(10) default -1 not null,
  mincleardeposit     NUMBER(15,2) default 0 not null,
  maxoverdraft        NUMBER(15,2) default 0 not null,
  virtualfunds        NUMBER(15,2) default 0 not null,
  runtimefl           NUMBER(15,2) default 0 not null,
  clearfl             NUMBER(15,2) default 0 not null,
  runtimemargin       NUMBER(15,2) default 0 not null,
  clearmargin         NUMBER(15,2) default 0 not null,
  runtimeassure       NUMBER(15,2) default 0 not null,
  clearassure         NUMBER(15,2) default 0 not null,
  runtimesettlemargin NUMBER(15,2) default 0 not null,
  clearsettlemargin   NUMBER(15,2) default 0 not null,
  tariffid            VARCHAR2(6) default 'none' not null,
  modifytime          DATE not null
)
;
alter table T_H_FIRM
  add constraint PK_T_H_FIRM primary key (CLEARDATE, FIRMID);

prompt
prompt Creating table T_H_FIRMFEE
prompt ==========================
prompt
create table T_H_FIRMFEE
(
  cleardate             DATE not null,
  firmid                VARCHAR2(32) not null,
  commodityid           VARCHAR2(16) not null,
  feealgr               NUMBER(1) not null,
  feerate_b             NUMBER(15,9) not null,
  feerate_s             NUMBER(15,9) not null,
  todayclosefeerate_b   NUMBER(15,9) default 0 not null,
  todayclosefeerate_s   NUMBER(15,9) default 0 not null,
  historyclosefeerate_b NUMBER(15,9) default 0 not null,
  historyclosefeerate_s NUMBER(15,9) default 0 not null,
  forceclosefeealgr     NUMBER(1) not null,
  forceclosefeerate_b   NUMBER(15,9) default 0 not null,
  forceclosefeerate_s   NUMBER(15,9) default 0 not null,
  modifytime            DATE not null
)
;
alter table T_H_FIRMFEE
  add constraint PK_T_H_FIRMFEE primary key (CLEARDATE, FIRMID, COMMODITYID);

prompt
prompt Creating table T_H_FIRMHOLDSUM
prompt ==============================
prompt
create table T_H_FIRMHOLDSUM
(
  cleardate    DATE not null,
  firmid       VARCHAR2(32) not null,
  commodityid  VARCHAR2(16) not null,
  bs_flag      NUMBER(2) not null,
  holdqty      NUMBER(10) not null,
  holdfunds    NUMBER(15,2) not null,
  floatingloss NUMBER(15,2) not null,
  evenprice    NUMBER(16,6) not null,
  holdmargin   NUMBER(15,2) default 0 not null,
  gageqty      NUMBER(10) default 0 not null,
  holdassure   NUMBER(15,2) default 0 not null
)
;
alter table T_H_FIRMHOLDSUM
  add constraint PK_T_H_FIRMHOLDSUM primary key (CLEARDATE, FIRMID, COMMODITYID, BS_FLAG);

prompt
prompt Creating table T_H_FIRMMARGIN
prompt =============================
prompt
create table T_H_FIRMMARGIN
(
  cleardate           DATE not null,
  firmid              VARCHAR2(32) not null,
  commodityid         VARCHAR2(16) not null,
  marginalgr          NUMBER(1) not null,
  marginrate_b        NUMBER(10,4) default 0 not null,
  marginrate_s        NUMBER(10,4) default 0 not null,
  marginitem1         NUMBER(15,2),
  marginitem2         NUMBER(15,2),
  marginitem3         NUMBER(15,2),
  marginitem4         NUMBER(15,2),
  marginitem1_s       NUMBER(15,2),
  marginitem2_s       NUMBER(15,2),
  marginitem3_s       NUMBER(15,2),
  marginitem4_s       NUMBER(15,2),
  marginassure_b      NUMBER(10,4) default 0 not null,
  marginassure_s      NUMBER(10,4) default 0 not null,
  marginitemassure1   NUMBER(15,2),
  marginitemassure2   NUMBER(15,2),
  marginitemassure3   NUMBER(15,2),
  marginitemassure4   NUMBER(15,2),
  marginitemassure1_s NUMBER(15,2),
  marginitemassure2_s NUMBER(15,2),
  marginitemassure3_s NUMBER(15,2),
  marginitemassure4_s NUMBER(15,2),
  modifytime          DATE not null,
  marginitem5         NUMBER(15,2),
  marginitem5_s       NUMBER(15,2),
  marginitemassure5   NUMBER(15,2),
  marginitemassure5_s NUMBER(15,2)
)
;
alter table T_H_FIRMMARGIN
  add constraint PK_T_H_FIRMMARGIN primary key (CLEARDATE, FIRMID, COMMODITYID);

prompt
prompt Creating table T_H_FIRMSETTLEFEE
prompt ================================
prompt
create table T_H_FIRMSETTLEFEE
(
  cleardate       DATE not null,
  firmid          VARCHAR2(32) not null,
  commodityid     VARCHAR2(16) not null,
  settlefeealgr   NUMBER(1) not null,
  settlefeerate_b NUMBER(15,9) default 0 not null,
  settlefeerate_s NUMBER(15,9) default 0 not null,
  modifytime      DATE not null
)
;
alter table T_H_FIRMSETTLEFEE
  add constraint PK_T_H_FIRMSETTLEFEE primary key (CLEARDATE, FIRMID, COMMODITYID);

prompt
prompt Creating table T_H_FIRMSETTLEMARGIN
prompt ===================================
prompt
create table T_H_FIRMSETTLEMARGIN
(
  cleardate          DATE not null,
  firmid             VARCHAR2(32) not null,
  commodityid        VARCHAR2(16) not null,
  settlemarginalgr_b NUMBER(1) not null,
  settlemarginrate_b NUMBER(10,4) default 0 not null,
  settlemarginalgr_s NUMBER(1) not null,
  settlemarginrate_s NUMBER(10,4) default 0 not null,
  payoutalgr         NUMBER(1) not null,
  payoutrate         NUMBER(10,4) default 0 not null,
  modifytime         DATE not null
)
;
alter table T_H_FIRMSETTLEMARGIN
  add constraint PK_T_H_FIRMSETTLEMARGIN primary key (CLEARDATE, FIRMID, COMMODITYID);

prompt
prompt Creating table T_H_HOLDPOSITION
prompt ===============================
prompt
create table T_H_HOLDPOSITION
(
  cleardate    DATE not null,
  a_holdno     NUMBER(15) not null,
  a_tradeno    NUMBER(15) not null,
  customerid   VARCHAR2(40) not null,
  commodityid  VARCHAR2(16) not null,
  bs_flag      NUMBER(2) not null,
  price        NUMBER(10,2) not null,
  holdqty      NUMBER(10) not null,
  openqty      NUMBER(10) not null,
  holdtime     DATE not null,
  holdmargin   NUMBER(15,2) default 0 not null,
  firmid       VARCHAR2(32) not null,
  gageqty      NUMBER(10) default 0 not null,
  holdassure   NUMBER(15,2) default 0 not null,
  floatingloss NUMBER(15,2) default 0 not null,
  holdtype     NUMBER(2) default 1 not null,
  atcleardate  DATE default trunc(sysdate) not null,
  deadline     DATE,
  remainday    NUMBER(10)
)
;
alter table T_H_HOLDPOSITION
  add constraint PK_T_H_HOLDPOSITION primary key (CLEARDATE, A_HOLDNO);

prompt
prompt Creating table T_H_MARKET
prompt =========================
prompt
create table T_H_MARKET
(
  cleardate               DATE not null,
  marketcode              CHAR(2) not null,
  marketname              VARCHAR2(64),
  status                  NUMBER(2) default 1 not null,
  shortname               VARCHAR2(20),
  runmode                 NUMBER(2) default 1 not null,
  settlemode              NUMBER(2) default 0 not null,
  marginfbflag            NUMBER(1) default 0 not null,
  floatinglosscomputetype NUMBER(1) default 0 not null,
  closealgr               NUMBER(2) default 0 not null,
  tradepricealgr          NUMBER(2) default 0 not null,
  tradeflowtype           NUMBER(2) default 0 not null,
  floatingprofitsubtax    NUMBER(1) default 0 not null,
  gagemode                NUMBER(2) default 0 not null,
  tradetimetype           NUMBER(2) default 0 not null,
  delayquoshowtype        NUMBER(2) default 1 not null,
  neutralfeeway           NUMBER(2) default 0 not null,
  delayneedbill           NUMBER(2) default 0 not null,
  neutralflag             NUMBER(2) default 0 not null,
  neutralmatchpriority    NUMBER(2) default 0 not null,
  quotationtwoside        NUMBER(2) default 2 not null,
  asmargintype            NUMBER(2) default 0,
  delayorderispure        NUMBER(1) default 0 not null,
  chargedelayfeetype      NUMBER(2) default 0 not null
)
;
alter table T_H_MARKET
  add constraint PK_T_H_MARKET primary key (CLEARDATE, MARKETCODE);

prompt
prompt Creating table T_H_ORDERS
prompt =========================
prompt
create table T_H_ORDERS
(
  cleardate        DATE not null,
  a_orderno        NUMBER(15) not null,
  a_orderno_w      NUMBER(15),
  commodityid      VARCHAR2(16) not null,
  customerid       VARCHAR2(40) not null,
  traderid         VARCHAR2(40),
  bs_flag          NUMBER(2),
  ordertype        NUMBER(2) not null,
  status           NUMBER(2) not null,
  withdrawtype     NUMBER(2),
  failcode         NUMBER(3),
  quantity         NUMBER(10),
  price            NUMBER(10,2),
  closemode        NUMBER(2),
  specprice        NUMBER(10,2),
  timeflag         NUMBER(1),
  tradeqty         NUMBER(10),
  frozenfunds      NUMBER(15,2),
  unfrozenfunds    NUMBER(15,2),
  ordertime        DATE,
  withdrawtime     DATE,
  ordererip        VARCHAR2(64),
  signature        VARCHAR2(256),
  closeflag        NUMBER(1),
  firmid           VARCHAR2(32) not null,
  consignerid      VARCHAR2(10),
  withdrawerid     VARCHAR2(40),
  updatetime       TIMESTAMP(6) default systimestamp,
  billtradetype    NUMBER(2) default 0 not null,
  specialorderflag NUMBER(2) default 0
)
;
alter table T_H_ORDERS
  add constraint PK_T_H_ORDERS primary key (CLEARDATE, A_ORDERNO);

prompt
prompt Creating table T_H_QUOTATION
prompt ============================
prompt
create table T_H_QUOTATION
(
  cleardate          DATE not null,
  commodityid        VARCHAR2(16) not null,
  yesterbalanceprice NUMBER(12,4) default 0 not null,
  closeprice         NUMBER(12,4) default 0 not null,
  openprice          NUMBER(12,4) default 0 not null,
  highprice          NUMBER(12,4) default 0 not null,
  lowprice           NUMBER(12,4) default 0 not null,
  curprice           NUMBER(12,4) default 0 not null,
  curamount          NUMBER(10) default 0 not null,
  openamount         NUMBER(10) default 0 not null,
  buyopenamount      NUMBER(10) default 0 not null,
  sellopenamount     NUMBER(10) default 0 not null,
  closeamount        NUMBER(10) default 0 not null,
  buycloseamount     NUMBER(10) default 0 not null,
  sellcloseamount    NUMBER(10) default 0 not null,
  reservecount       NUMBER(10) default 0 not null,
  reservechange      NUMBER(10) default 0 not null,
  price              NUMBER(12,4) default 0 not null,
  totalmoney         NUMBER(15,2) default 0 not null,
  totalamount        NUMBER(10) default 0 not null,
  spread             NUMBER(12,4) default 0 not null,
  buyprice1          NUMBER(12,4) default 0 not null,
  sellprice1         NUMBER(12,4) default 0 not null,
  buyamount1         NUMBER(10) default 0 not null,
  sellamount1        NUMBER(10) default 0 not null,
  buyprice2          NUMBER(12,4) default 0,
  sellprice2         NUMBER(12,4) default 0,
  buyamount2         NUMBER(10) default 0,
  sellamount2        NUMBER(10) default 0,
  buyprice3          NUMBER(12,4) default 0,
  sellprice3         NUMBER(12,4) default 0,
  buyamount3         NUMBER(10) default 0,
  sellamount3        NUMBER(10) default 0,
  buyprice4          NUMBER(12,4) default 0,
  sellprice4         NUMBER(12,4) default 0,
  buyamount4         NUMBER(10) default 0,
  sellamount4        NUMBER(10) default 0,
  buyprice5          NUMBER(12,4) default 0,
  sellprice5         NUMBER(12,4) default 0,
  buyamount5         NUMBER(10) default 0,
  sellamount5        NUMBER(10) default 0,
  buyprice6          NUMBER(12,4) default 0,
  sellprice6         NUMBER(12,4) default 0,
  buyamount6         NUMBER(10) default 0,
  sellamount6        NUMBER(10) default 0,
  buyprice7          NUMBER(12,4) default 0,
  sellprice7         NUMBER(12,4) default 0,
  buyamount7         NUMBER(10) default 0,
  sellamount7        NUMBER(10) default 0,
  buyprice8          NUMBER(12,4) default 0,
  sellprice8         NUMBER(12,4) default 0,
  buyamount8         NUMBER(10) default 0,
  sellamount8        NUMBER(10) default 0,
  buyprice9          NUMBER(12,4) default 0,
  sellprice9         NUMBER(12,4) default 0,
  buyamount9         NUMBER(10) default 0,
  sellamount9        NUMBER(10) default 0,
  buyprice10         NUMBER(12,4) default 0,
  sellprice10        NUMBER(12,4) default 0,
  buyamount10        NUMBER(10) default 0,
  sellamount         NUMBER(10) default 0,
  outamount          NUMBER(10) default 0,
  inamount           NUMBER(10) default 0,
  tradecue           NUMBER(10) default 0,
  no                 NUMBER(10) default 0,
  createtime         TIMESTAMP(6)
)
;
alter table T_H_QUOTATION
  add constraint PK_T_H_QUOTATION primary key (CLEARDATE, COMMODITYID);

prompt
prompt Creating table T_H_TRADE
prompt ========================
prompt
create table T_H_TRADE
(
  cleardate        DATE not null,
  a_tradeno        NUMBER(15) not null,
  m_tradeno        NUMBER(15) not null,
  a_orderno        NUMBER(15),
  a_tradeno_closed NUMBER(15),
  tradetime        DATE,
  customerid       VARCHAR2(32) not null,
  commodityid      VARCHAR2(16) not null,
  bs_flag          NUMBER(2) not null,
  ordertype        NUMBER(2) not null,
  price            NUMBER(10,2) not null,
  quantity         NUMBER(10),
  close_pl         NUMBER(15,2),
  tradefee         NUMBER(15,2),
  tradetype        NUMBER(2) not null,
  holdprice        NUMBER(10,2),
  holdtime         DATE,
  firmid           VARCHAR2(32) not null,
  closeaddedtax    NUMBER(15,2) default 0,
  m_tradeno_opp    NUMBER(15) not null,
  atcleardate      DATE default trunc(sysdate) not null,
  tradeatcleardate DATE default trunc(sysdate) not null,
  oppfirmid        VARCHAR2(32) not null
)
;
alter table T_H_TRADE
  add constraint PK_T_H_TRADE primary key (CLEARDATE, A_TRADENO);

prompt
prompt Creating table T_MATCHSETTLEHOLDRELEVANCE
prompt =========================================
prompt
create table T_MATCHSETTLEHOLDRELEVANCE
(
  matchid      VARCHAR2(12) not null,
  settleid     NUMBER(15) not null,
  quantity     NUMBER(10) default 0 not null,
  price        NUMBER(15,2) default 0 not null,
  settlepayout NUMBER(15,2) not null,
  settlemargin NUMBER(15,2) not null
)
;
alter table T_MATCHSETTLEHOLDRELEVANCE
  add constraint PK_T_MATCHSETTLEHOLDRELEVANCE primary key (MATCHID, SETTLEID);

prompt
prompt Creating table T_ORDERS
prompt =======================
prompt
create table T_ORDERS
(
  a_orderno        NUMBER(15) not null,
  a_orderno_w      NUMBER(15),
  commodityid      VARCHAR2(16) not null,
  customerid       VARCHAR2(40) not null,
  traderid         VARCHAR2(40),
  bs_flag          NUMBER(2),
  ordertype        NUMBER(2) not null,
  status           NUMBER(2) not null,
  withdrawtype     NUMBER(2),
  failcode         NUMBER(3),
  quantity         NUMBER(10),
  price            NUMBER(10,2),
  closemode        NUMBER(2),
  specprice        NUMBER(10,2),
  timeflag         NUMBER(1),
  tradeqty         NUMBER(10),
  frozenfunds      NUMBER(15,2),
  unfrozenfunds    NUMBER(15,2),
  ordertime        DATE,
  withdrawtime     DATE,
  ordererip        VARCHAR2(64),
  signature        VARCHAR2(256),
  closeflag        NUMBER(1),
  firmid           VARCHAR2(32) not null,
  consignerid      VARCHAR2(10),
  withdrawerid     VARCHAR2(40),
  updatetime       TIMESTAMP(6) default systimestamp,
  billtradetype    NUMBER(2) default 0 not null,
  specialorderflag NUMBER(2) default 0
)
;
create index IX_T_ORDERS on T_ORDERS (FIRMID);
alter table T_ORDERS
  add constraint PK_T_ORDERS primary key (A_ORDERNO);

prompt
prompt Creating table T_QUOTATION
prompt ==========================
prompt
create table T_QUOTATION
(
  commodityid        VARCHAR2(16) not null,
  yesterbalanceprice NUMBER(12,4) default 0 not null,
  closeprice         NUMBER(12,4) default 0 not null,
  openprice          NUMBER(12,4) default 0 not null,
  highprice          NUMBER(12,4) default 0 not null,
  lowprice           NUMBER(12,4) default 0 not null,
  curprice           NUMBER(12,4) default 0 not null,
  curamount          NUMBER(10) default 0 not null,
  openamount         NUMBER(10) default 0 not null,
  buyopenamount      NUMBER(10) default 0 not null,
  sellopenamount     NUMBER(10) default 0 not null,
  closeamount        NUMBER(10) default 0 not null,
  buycloseamount     NUMBER(10) default 0 not null,
  sellcloseamount    NUMBER(10) default 0 not null,
  reservecount       NUMBER(10) default 0 not null,
  reservechange      NUMBER(10) default 0 not null,
  price              NUMBER(12,4) default 0 not null,
  totalmoney         NUMBER(15,2) default 0 not null,
  totalamount        NUMBER(10) default 0 not null,
  spread             NUMBER(12,4) default 0 not null,
  buyprice1          NUMBER(12,4) default 0 not null,
  sellprice1         NUMBER(12,4) default 0 not null,
  buyamount1         NUMBER(10) default 0 not null,
  sellamount1        NUMBER(10) default 0 not null,
  buyprice2          NUMBER(12,4) default 0,
  sellprice2         NUMBER(12,4) default 0,
  buyamount2         NUMBER(10) default 0,
  sellamount2        NUMBER(10) default 0,
  buyprice3          NUMBER(12,4) default 0,
  sellprice3         NUMBER(12,4) default 0,
  buyamount3         NUMBER(10) default 0,
  sellamount3        NUMBER(10) default 0,
  buyprice4          NUMBER(12,4) default 0,
  sellprice4         NUMBER(12,4) default 0,
  buyamount4         NUMBER(10) default 0,
  sellamount4        NUMBER(10) default 0,
  buyprice5          NUMBER(12,4) default 0,
  sellprice5         NUMBER(12,4) default 0,
  buyamount5         NUMBER(10) default 0,
  sellamount5        NUMBER(10) default 0,
  buyprice6          NUMBER(12,4) default 0,
  sellprice6         NUMBER(12,4) default 0,
  buyamount6         NUMBER(10) default 0,
  sellamount6        NUMBER(10) default 0,
  buyprice7          NUMBER(12,4) default 0,
  sellprice7         NUMBER(12,4) default 0,
  buyamount7         NUMBER(10) default 0,
  sellamount7        NUMBER(10) default 0,
  buyprice8          NUMBER(12,4) default 0,
  sellprice8         NUMBER(12,4) default 0,
  buyamount8         NUMBER(10) default 0,
  sellamount8        NUMBER(10) default 0,
  buyprice9          NUMBER(12,4) default 0,
  sellprice9         NUMBER(12,4) default 0,
  buyamount9         NUMBER(10) default 0,
  sellamount9        NUMBER(10) default 0,
  buyprice10         NUMBER(12,4) default 0,
  sellprice10        NUMBER(12,4) default 9,
  buyamount10        NUMBER(10) default 0,
  sellamount10       NUMBER(10) default 0,
  outamount          NUMBER(10) default 0,
  inamount           NUMBER(10) default 0,
  tradecue           NUMBER(10) default 0,
  no                 NUMBER(10) default 0,
  createtime         TIMESTAMP(6)
)
;
alter table T_QUOTATION
  add constraint PK_T_QUOTATION primary key (COMMODITYID);

prompt
prompt Creating table T_RMICONF
prompt ========================
prompt
create table T_RMICONF
(
  serviceid   NUMBER(2) not null,
  cnname      VARCHAR2(64),
  ename       VARCHAR2(64),
  hostip      VARCHAR2(16) not null,
  port        NUMBER(6) not null,
  rmidataport NUMBER(6) not null,
  enabled     CHAR(1) not null
)
;
alter table T_RMICONF
  add constraint PK_T_RMICONF primary key (SERVICEID);

prompt
prompt Creating table T_SETTLEANDHOLD
prompt ==============================
prompt
create table T_SETTLEANDHOLD
(
  settleholdpositionid NUMBER(15),
  matchid              VARCHAR2(12),
  tax                  NUMBER(15,2),
  bs_flag              NUMBER(2)
)
;
comment on column T_SETTLEANDHOLD.settleholdpositionid
  is '交收交易客户持仓明细表id';
comment on column T_SETTLEANDHOLD.matchid
  is '交收配对编号';
comment on column T_SETTLEANDHOLD.tax
  is '税费';
comment on column T_SETTLEANDHOLD.bs_flag
  is '买卖标记1买，2卖';

prompt
prompt Creating table T_SETTLECOMMODITY
prompt ================================
prompt
create table T_SETTLECOMMODITY
(
  settleprocessdate     DATE not null,
  commodityid           VARCHAR2(16) not null,
  name                  VARCHAR2(32) not null,
  sortid                NUMBER(10) not null,
  status                NUMBER(2) not null,
  contractfactor        NUMBER(12,2) not null,
  minpricemove          NUMBER(10,2) not null,
  breedid               NUMBER(10) not null,
  spreadalgr            NUMBER(1) not null,
  spreaduplmt           NUMBER(10,2) not null,
  spreaddownlmt         NUMBER(10,2) not null,
  feealgr               NUMBER(1) not null,
  feerate_b             NUMBER(15,9) not null,
  feerate_s             NUMBER(15,9) not null,
  marginalgr            NUMBER(1) not null,
  marginrate_b          NUMBER(10,4) default 0 not null,
  marginrate_s          NUMBER(10,4) default 0 not null,
  marketdate            DATE,
  settledate            DATE not null,
  settledate1           DATE,
  marginitem1           NUMBER(15,2),
  settledate2           DATE,
  marginitem2           NUMBER(15,2),
  settledate3           DATE,
  marginitem3           NUMBER(15,2),
  settledate4           DATE,
  marginitem4           NUMBER(15,2),
  lastprice             NUMBER(10,2) not null,
  marginitem1_s         NUMBER(15,2),
  marginitem2_s         NUMBER(15,2),
  marginitem3_s         NUMBER(15,2),
  marginitem4_s         NUMBER(15,2),
  marginassure_b        NUMBER(10,4) default 0 not null,
  marginassure_s        NUMBER(10,4) default 0 not null,
  marginitemassure1     NUMBER(15,2),
  marginitemassure2     NUMBER(15,2),
  marginitemassure3     NUMBER(15,2),
  marginitemassure4     NUMBER(15,2),
  marginitemassure1_s   NUMBER(15,2),
  marginitemassure2_s   NUMBER(15,2),
  marginitemassure3_s   NUMBER(15,2),
  marginitemassure4_s   NUMBER(15,2),
  todayclosefeerate_b   NUMBER(15,9) default 0 not null,
  todayclosefeerate_s   NUMBER(15,9) default 0 not null,
  historyclosefeerate_b NUMBER(15,9) default 0 not null,
  historyclosefeerate_s NUMBER(15,9) default 0 not null,
  limitcmdtyqty         NUMBER(10) default -1 not null,
  settlefeealgr         NUMBER(1) not null,
  settlefeerate_b       NUMBER(15,9) default 0 not null,
  settlefeerate_s       NUMBER(15,9) default 0 not null,
  forceclosefeealgr     NUMBER(1) not null,
  forceclosefeerate_b   NUMBER(15,9) default 0 not null,
  forceclosefeerate_s   NUMBER(15,9) default 0 not null,
  settlemarginalgr_b    NUMBER(1) not null,
  settlemarginrate_b    NUMBER(10,4) default 0 not null,
  settlemarginalgr_s    NUMBER(1) not null,
  settlemarginrate_s    NUMBER(10,4) default 0 not null,
  reservecount          NUMBER(10) default 0 not null,
  addedtax              NUMBER(10,4) default 0 not null,
  marginpricetype       NUMBER(1) default 0 not null,
  lowestsettlefee       NUMBER(15,2) default 0 not null,
  firmcleanqty          NUMBER(10) default -1 not null,
  firmmaxholdqty        NUMBER(10) default -1 not null,
  payoutalgr            NUMBER(1) not null,
  payoutrate            NUMBER(10,4) default 0 not null,
  addedtaxfactor        NUMBER(13,10) default 0 not null,
  settledate5           DATE,
  marginitem5           NUMBER(15,2),
  marginitem5_s         NUMBER(15,2),
  marginitemassure5     NUMBER(15,2),
  marginitemassure5_s   NUMBER(15,2),
  settlepricetype       NUMBER(2) default 0 not null,
  beforedays            NUMBER(4),
  specsettleprice       NUMBER(10,2),
  orderprivilege_b      NUMBER(6) default 101 not null,
  orderprivilege_s      NUMBER(6) default 101 not null,
  firmmaxholdqtyalgr    NUMBER(1) default 2 not null,
  startpercentqty       NUMBER(10) default 0 not null,
  maxpercentlimit       NUMBER(7,4) default 0 not null,
  onemaxholdqty         NUMBER(10) default -1 not null,
  minquantitymove       NUMBER(3) default 1 not null,
  delayrecouprate       NUMBER(7,5) default 0 not null,
  settleway             NUMBER(2) default 0 not null,
  delayfeeway           NUMBER(2) default 1 not null,
  maxfeerate            NUMBER(15,9),
  minsettlemoveqty      NUMBER(5) default 1 not null,
  storerecouprate       NUMBER(7,5) default 0 not null,
  minsettleqty          NUMBER(10) default 1 not null,
  delayrecouprate_s     NUMBER(7,5) default 0 not null,
  aheadsettlepricetype  NUMBER(2) default 0,
  delaysettlepricetype  NUMBER(2) default 0,
  settlemargintype      NUMBER(2) default 0,
  beforedays_m          NUMBER(2) default 0,
  sideholdlimitqty      NUMBER(10) default -1,
  holddayslimit         NUMBER(1) default 0 not null,
  maxholdpositionday    NUMBER(10),
  taxinclusive          NUMBER(1)
)
;
alter table T_SETTLECOMMODITY
  add constraint PK_T_SETTLECOMMODITY primary key (SETTLEPROCESSDATE, COMMODITYID);

prompt
prompt Creating table T_SETTLEHOLDPOSITION
prompt ===================================
prompt
create table T_SETTLEHOLDPOSITION
(
  id                      NUMBER(15) not null,
  settleprocessdate       DATE not null,
  a_holdno                NUMBER(15) not null,
  a_tradeno               NUMBER(15) not null,
  customerid              VARCHAR2(40) not null,
  commodityid             VARCHAR2(16) not null,
  bs_flag                 NUMBER(2) not null,
  price                   NUMBER(10,2) not null,
  holdqty                 NUMBER(10) not null,
  openqty                 NUMBER(10) not null,
  holdtime                DATE not null,
  holdmargin              NUMBER(15,2) default 0 not null,
  firmid                  VARCHAR2(32) not null,
  gageqty                 NUMBER(10) default 0 not null,
  holdassure              NUMBER(15,2) default 0 not null,
  floatingloss            NUMBER(15,2) default 0 not null,
  settlemargin            NUMBER(15,2) default 0 not null,
  payout                  NUMBER(15,2) default 0 not null,
  settlefee               NUMBER(15,2) default 0 not null,
  settle_pl               NUMBER(15,2) default 0 not null,
  settleaddedtax          NUMBER(15,2) default 0 not null,
  settleprice             NUMBER(16,6) not null,
  settletype              NUMBER(2) not null,
  holdtype                NUMBER(2) default 1 not null,
  atcleardate             DATE default trunc(sysdate) not null,
  matchquantity           NUMBER(10) default 0,
  matchstatus             NUMBER(2) default 0 not null,
  happenmatchqty          NUMBER(10) default 0 not null,
  happenmatchpayout       NUMBER(15,2) default 0 not null,
  happenmatchsettlemargin NUMBER(15,2) default 0 not null
)
;
create index IX_T_SETTLEHOLDPOSITION on T_SETTLEHOLDPOSITION (SETTLEPROCESSDATE, COMMODITYID);
alter table T_SETTLEHOLDPOSITION
  add constraint PK_T_SETTLEHOLDPOSITION primary key (ID);

prompt
prompt Creating table T_SETTLEMATCH
prompt ============================
prompt
create table T_SETTLEMATCH
(
  matchid        VARCHAR2(12) not null,
  commodityid    VARCHAR2(16) not null,
  contractfactor NUMBER(12,2) not null,
  quantity       NUMBER(10) not null,
  hl_amount      NUMBER(15,2) default 0 not null,
  status         NUMBER(2) default 0 not null,
  result         NUMBER(1) not null,
  settletype     NUMBER(2) not null,
  firmid_b       VARCHAR2(32) not null,
  buyprice       NUMBER(15,6) not null,
  buypayout_ref  NUMBER(15,2) default 0 not null,
  buypayout      NUMBER(15,2) default 0 not null,
  buymargin      NUMBER(15,2) default 0 not null,
  takepenalty_b  NUMBER(15,2) default 0 not null,
  paypenalty_b   NUMBER(15,2) default 0 not null,
  settlepl_b     NUMBER(15,2) default 0 not null,
  firmid_s       VARCHAR2(32) not null,
  sellprice      NUMBER(15,6) not null,
  sellincome_ref NUMBER(15,2) default 0 not null,
  sellincome     NUMBER(15,2) default 0 not null,
  sellmargin     NUMBER(15,2) default 0 not null,
  takepenalty_s  NUMBER(15,2) default 0 not null,
  paypenalty_s   NUMBER(15,2) default 0 not null,
  settlepl_s     NUMBER(15,2) default 0 not null,
  createtime     DATE not null,
  modifytime     DATE not null,
  settledate     DATE not null,
  modifier       VARCHAR2(64),
  istransfer     NUMBER(2) default 0 not null,
  buytax         NUMBER(15,2) default 0,
  taxincluesive  NUMBER(1) default 0
)
;
comment on column T_SETTLEMATCH.buytax
  is '交收税费';
comment on column T_SETTLEMATCH.taxincluesive
  is '商品是否含税,0默认含税，1为不含税';
alter table T_SETTLEMATCH
  add constraint PK_T_SETTLEMATCH primary key (MATCHID);

prompt
prompt Creating table T_SETTLEMATCHFUNDMANAGE
prompt ======================================
prompt
create table T_SETTLEMATCHFUNDMANAGE
(
  id          NUMBER(15) not null,
  matchid     VARCHAR2(12) not null,
  firmid      VARCHAR2(32) not null,
  summaryno   VARCHAR2(5) not null,
  amount      NUMBER(15,2) not null,
  operatedate DATE not null,
  commodityid VARCHAR2(16)
)
;

prompt
prompt Creating table T_SETTLEMATCHLOG
prompt ===============================
prompt
create table T_SETTLEMATCHLOG
(
  id         NUMBER(20) not null,
  matchid    VARCHAR2(12) not null,
  operator   VARCHAR2(32) not null,
  operatelog VARCHAR2(2048) not null,
  updatetime TIMESTAMP(6)
)
;
alter table T_SETTLEMATCHLOG
  add constraint PK_T_SETTLEMATCHLOG primary key (ID);

prompt
prompt Creating table T_SETTLEPROPS
prompt ============================
prompt
create table T_SETTLEPROPS
(
  id            NUMBER(15) not null,
  commodityid   VARCHAR2(16) not null,
  propertyname  VARCHAR2(64) not null,
  propertyvalue VARCHAR2(1000),
  note          VARCHAR2(2000)
)
;
alter table T_SETTLEPROPS
  add constraint PK_T_SETTLEPROPS primary key (ID);

prompt
prompt Creating table T_SPECFROZENHOLD
prompt ===============================
prompt
create table T_SPECFROZENHOLD
(
  id        NUMBER(15) not null,
  a_holdno  NUMBER(15) not null,
  a_orderno NUMBER(15),
  frozenqty NUMBER(10) not null
)
;
alter table T_SPECFROZENHOLD
  add constraint PK_T_SPECFROZENHOLD primary key (ID);

prompt
prompt Creating table T_SUBSYSTEM
prompt ==========================
prompt
create table T_SUBSYSTEM
(
  moduleid NUMBER(2) not null,
  enabled  CHAR(1) not null
)
;
alter table T_SUBSYSTEM
  add constraint PK_T_SUBSYSTEM primary key (MODULEID);

prompt
prompt Creating table T_SYSTEMSTATUS
prompt =============================
prompt
create table T_SYSTEMSTATUS
(
  tradedate   DATE not null,
  status      NUMBER(2) default 3 not null,
  sectionid   NUMBER(4),
  note        VARCHAR2(256),
  recovertime VARCHAR2(10)
)
;
alter table T_SYSTEMSTATUS
  add constraint PK_T_SYSTEMSTATUS primary key (TRADEDATE);

prompt
prompt Creating table T_TRADE
prompt ======================
prompt
create table T_TRADE
(
  a_tradeno        NUMBER(15) not null,
  m_tradeno        NUMBER(15) not null,
  a_orderno        NUMBER(15),
  a_tradeno_closed NUMBER(15),
  tradetime        DATE,
  customerid       VARCHAR2(40) not null,
  commodityid      VARCHAR2(16) not null,
  bs_flag          NUMBER(2) not null,
  ordertype        NUMBER(2) not null,
  price            NUMBER(10,2) not null,
  quantity         NUMBER(10),
  close_pl         NUMBER(15,2),
  tradefee         NUMBER(15,2),
  tradetype        NUMBER(2) not null,
  holdprice        NUMBER(10,2),
  holdtime         DATE,
  firmid           VARCHAR2(32) not null,
  closeaddedtax    NUMBER(15,2) default 0,
  m_tradeno_opp    NUMBER(15) not null,
  atcleardate      DATE default trunc(sysdate) not null,
  tradeatcleardate DATE default trunc(sysdate) not null,
  oppfirmid        VARCHAR2(32) not null
)
;
create index IX_T_TRADE on T_TRADE (M_TRADENO);
alter table T_TRADE
  add constraint PK_T_TRADE primary key (A_TRADENO);

prompt
prompt Creating table T_TRADEDAYS
prompt ==========================
prompt
create table T_TRADEDAYS
(
  day DATE not null
)
;
alter table T_TRADEDAYS
  add constraint PK_T_TRADEDAYS primary key (DAY);

prompt
prompt Creating table T_TRADER
prompt =======================
prompt
create table T_TRADER
(
  traderid    VARCHAR2(40) not null,
  operatecode VARCHAR2(2048),
  modifytime  DATE not null
)
;
alter table T_TRADER
  add constraint PK_T_TRADER primary key (TRADERID);

prompt
prompt Creating table T_UNTRADETRANSFER
prompt ================================
prompt
create table T_UNTRADETRANSFER
(
  transferid   NUMBER(10) not null,
  customerid_s VARCHAR2(40) not null,
  customerid_b VARCHAR2(40) not null,
  commodityid  VARCHAR2(16) not null,
  bs_flag      NUMBER(2) not null,
  type         NUMBER(2) not null,
  quantity     NUMBER(10) default 0 not null,
  status       NUMBER(2) default 0 not null,
  createtime   DATE default sysdate not null,
  modifytime   DATE default sysdate not null
)
;
alter table T_UNTRADETRANSFER
  add constraint PK_T_UNTRADETRANSFER primary key (TRANSFERID);

prompt
prompt Creating table T_VALIDGAGEBILL
prompt ==============================
prompt
create table T_VALIDGAGEBILL
(
  firmid      VARCHAR2(32) not null,
  commodityid VARCHAR2(16) not null,
  quantity    NUMBER(10) not null,
  frozenqty   NUMBER(10) not null
)
;
alter table T_VALIDGAGEBILL
  add constraint PK_T_VALIDGAGEBILL primary key (FIRMID, COMMODITYID);

prompt
prompt Creating table V_BARGAIN
prompt ========================
prompt
create table V_BARGAIN
(
  contractid     NUMBER(10) not null,
  tradepartition NUMBER(3) default 1 not null,
  section        NUMBER(5) not null,
  submitid       NUMBER(12) not null,
  code           VARCHAR2(64) not null,
  commodityid    VARCHAR2(64) not null,
  price          NUMBER(12,2) not null,
  amount         NUMBER(16,6) not null,
  userid         VARCHAR2(32) not null,
  tradetime      DATE default trunc(sysdate),
  b_bail         NUMBER(12,2) default 0 not null,
  s_bail         NUMBER(12,2) default 0 not null,
  b_poundage     NUMBER(12,2) default 0 not null,
  s_poundage     NUMBER(12,2) default 0 not null
)
;
alter table V_BARGAIN
  add primary key (CONTRACTID);

prompt
prompt Creating table V_COMMEXT
prompt ========================
prompt
create table V_COMMEXT
(
  id          NUMBER(10) not null,
  code        VARCHAR2(64) not null,
  attributeid NUMBER(10) not null,
  attribute   VARCHAR2(64) not null,
  value       VARCHAR2(128) not null
)
;
alter table V_COMMEXT
  add primary key (ID);

prompt
prompt Creating table V_COMMODITY
prompt ==========================
prompt
create table V_COMMODITY
(
  code               VARCHAR2(64) not null,
  tradepartition     NUMBER(3) default 1 not null,
  firsttime          DATE not null,
  commodityid        VARCHAR2(128) not null,
  createtime         DATE not null,
  status             NUMBER(3) default 2 not null,
  breedid            NUMBER(10) not null,
  splitid            VARCHAR2(512) default 0 not null,
  userid             VARCHAR2(32) not null,
  amount             NUMBER(16,6) not null,
  tradeunit          NUMBER(16,6) default 0.000001 not null,
  minamount          NUMBER(16,6) not null,
  maxamount          NUMBER(16,6) not null,
  flowamountalgr     NUMBER(2) default 0 not null,
  flowamount         NUMBER(16,6) default 0.000001 not null,
  beginprice         NUMBER(15,2) not null,
  alertprice         NUMBER(15,2) default -1,
  stepprice          NUMBER(15,2) not null,
  maxstepprice       NUMBER(15,2) not null,
  marginalgr         NUMBER(2) not null,
  b_security         NUMBER(15,4) not null,
  s_security         NUMBER(15,4) not null,
  feealgr            NUMBER(2) not null,
  b_fee              NUMBER(15,5) not null,
  s_fee              NUMBER(15,5) not null,
  authorization      NUMBER(2) default 0 not null,
  isorder            NUMBER(2) default 0 not null,
  bs_flag            NUMBER(2),
  tendertradeconfirm NUMBER(2) default 0 not null,
  auditstatus        NUMBER(2) default 0 not null,
  audituser          VARCHAR2(128),
  audittime          DATE,
  remark             VARCHAR2(256)
)
;
alter table V_COMMODITY
  add primary key (CODE);

prompt
prompt Creating table V_COMMODITYPARAMS
prompt ================================
prompt
create table V_COMMODITYPARAMS
(
  tradepartition NUMBER(3) default 1 not null,
  breedid        NUMBER(10) not null,
  tradeunit      NUMBER(16,6) not null,
  minamount      NUMBER(16,6) not null,
  maxamount      NUMBER(16,6) not null,
  stepprice      NUMBER(15,2) not null,
  maxstepprice   NUMBER(15,2) not null,
  marginalgr     NUMBER(2) not null,
  b_security     NUMBER(15,4) not null,
  s_security     NUMBER(15,4) not null,
  feealgr        NUMBER(2) not null,
  b_fee          NUMBER(15,5) not null,
  s_fee          NUMBER(15,5) not null,
  flowamountalgr NUMBER(2) default 0 not null,
  flowamount     NUMBER(16,6) default 0.000001 not null
)
;
alter table V_COMMODITYPARAMS
  add primary key (TRADEPARTITION, BREEDID);

prompt
prompt Creating table V_COMMODITYSELF
prompt ==============================
prompt
create table V_COMMODITYSELF
(
  partitionid NUMBER(3) not null,
  usercode    VARCHAR2(32) not null,
  code        VARCHAR2(64) not null,
  time        DATE not null
)
;
alter table V_COMMODITYSELF
  add primary key (PARTITIONID, USERCODE, CODE);

prompt
prompt Creating table V_CONTRACTTEMPLET
prompt ================================
prompt
create table V_CONTRACTTEMPLET
(
  id      NUMBER(5) not null,
  breedid NUMBER(10) not null,
  name    VARCHAR2(128),
  templet CLOB not null
)
;
alter table V_CONTRACTTEMPLET
  add primary key (ID);

prompt
prompt Creating table V_CURCOMMODITY
prompt =============================
prompt
create table V_CURCOMMODITY
(
  code           VARCHAR2(64) not null,
  tradepartition NUMBER(3) default 1 not null,
  commodityid    VARCHAR2(128) not null,
  section        NUMBER(3),
  bargaintype    NUMBER(2) default 0 not null,
  modifytime     DATE not null
)
;
alter table V_CURCOMMODITY
  add primary key (CODE);

prompt
prompt Creating table V_CURSUBMIT
prompt ==========================
prompt
create table V_CURSUBMIT
(
  id             NUMBER(12) not null,
  tradepartition NUMBER(3) default 1 not null,
  code           VARCHAR2(64) not null,
  price          NUMBER(12,2) default 0 not null,
  amount         NUMBER(16,6) default 0 not null,
  traderid       VARCHAR2(40) not null,
  userid         VARCHAR2(32) not null,
  submittime     DATE not null,
  ordertype      NUMBER(3) not null,
  validamount    NUMBER(16,6) default 0 not null,
  modifytime     TIMESTAMP(6) default systimestamp(6),
  frozenmargin   NUMBER(15,2) default 0 not null,
  frozenfee      NUMBER(15,2) default 0 not null,
  unfrozenmargin NUMBER(15,2) default 0 not null,
  unfrozenfee    NUMBER(15,2) default 0 not null,
  withdrawtype   NUMBER(2)
)
;
alter table V_CURSUBMIT
  add primary key (ID);

prompt
prompt Creating table V_CURSUBMITTENDER
prompt ================================
prompt
create table V_CURSUBMITTENDER
(
  id             NUMBER(12) not null,
  tradepartition NUMBER(3) default 1 not null,
  code           VARCHAR2(64) not null,
  price          NUMBER(12,2) default 0 not null,
  amount         NUMBER(16,6) default 0 not null,
  traderid       VARCHAR2(40) not null,
  userid         VARCHAR2(32) not null,
  submittime     DATE not null,
  ordertype      NUMBER(3) not null,
  validamount    NUMBER(16,6) default 0 not null,
  modifytime     TIMESTAMP(6) default systimestamp(6),
  frozenmargin   NUMBER(15,2) default 0 not null,
  frozenfee      NUMBER(15,2) default 0 not null,
  unfrozenmargin NUMBER(15,2) default 0 not null,
  unfrozenfee    NUMBER(15,2) default 0 not null,
  withdrawtype   NUMBER(2)
)
;
alter table V_CURSUBMITTENDER
  add primary key (ID);

prompt
prompt Creating table V_CURSUBMITTENDERPLAN
prompt ====================================
prompt
create table V_CURSUBMITTENDERPLAN
(
  id             NUMBER(12) not null,
  tradepartition NUMBER(3) default 1 not null,
  code           VARCHAR2(64) not null,
  price          NUMBER(12,2) default 0 not null,
  amount         NUMBER(16,6) default 0 not null,
  confirmamount  NUMBER(16,6) default 0 not null,
  traderid       VARCHAR2(40) not null,
  userid         VARCHAR2(32) not null,
  submittime     DATE not null,
  ordertype      NUMBER(3) not null,
  validamount    NUMBER(16,6) default 0 not null,
  modifytime     TIMESTAMP(6) default systimestamp(6),
  frozenmargin   NUMBER(15,2) default 0 not null,
  frozenfee      NUMBER(15,2) default 0 not null,
  unfrozenmargin NUMBER(15,2) default 0 not null,
  unfrozenfee    NUMBER(15,2) default 0 not null,
  withdrawtype   NUMBER(2)
)
;
alter table V_CURSUBMITTENDERPLAN
  add primary key (ID);

prompt
prompt Creating table V_FIRMSPECIALFEE
prompt ===============================
prompt
create table V_FIRMSPECIALFEE
(
  usercode   VARCHAR2(32) not null,
  breedid    NUMBER(10) not null,
  bs_flag    NUMBER(2) not null,
  feealgr    NUMBER(2) not null,
  fee        NUMBER(15,5) default 0 not null,
  updatetime TIMESTAMP(6)
)
;
alter table V_FIRMSPECIALFEE
  add primary key (USERCODE, BREEDID, BS_FLAG);

prompt
prompt Creating table V_FIRMSPECIALMARGIN
prompt ==================================
prompt
create table V_FIRMSPECIALMARGIN
(
  usercode   VARCHAR2(32) not null,
  breedid    NUMBER(10) not null,
  bs_flag    NUMBER(2) not null,
  marginalgr NUMBER(2) not null,
  margin     NUMBER(15,4) default 0 not null,
  updatetime TIMESTAMP(6)
)
;
alter table V_FIRMSPECIALMARGIN
  add primary key (USERCODE, BREEDID, BS_FLAG);

prompt
prompt Creating table V_FLOWCONTROL
prompt ============================
prompt
create table V_FLOWCONTROL
(
  tradepartition NUMBER(3) default 1 not null,
  unittype       NUMBER(2) not null,
  unitid         NUMBER(5) not null,
  breedid        NUMBER(10) not null,
  startmode      NUMBER(2) not null,
  starttime      VARCHAR2(32),
  durativetime   NUMBER(8) not null,
  countdownstart VARCHAR2(128),
  countdowntime  VARCHAR2(128),
  quartertime    NUMBER(8) default 0 not null,
  forcedendtime  VARCHAR2(32),
  ismargincount  NUMBER(2) default 0 not null
)
;
alter table V_FLOWCONTROL
  add primary key (TRADEPARTITION, UNITTYPE, UNITID);

prompt
prompt Creating table V_FUNDFROZEN
prompt ===========================
prompt
create table V_FUNDFROZEN
(
  id           NUMBER(10) not null,
  userid       VARCHAR2(32) not null,
  code         VARCHAR2(64) not null,
  frozenmargin NUMBER(15,2) default 0 not null,
  frozenfee    NUMBER(15,2) default 0 not null,
  frozentime   TIMESTAMP(6) not null
)
;
alter table V_FUNDFROZEN
  add primary key (ID);

prompt
prompt Creating table V_HISBARGAIN
prompt ===========================
prompt
create table V_HISBARGAIN
(
  tradedate      DATE not null,
  contractid     NUMBER(10) not null,
  tradepartition NUMBER(3) default 1 not null,
  section        NUMBER(5) not null,
  submitid       NUMBER(12) not null,
  code           VARCHAR2(64) not null,
  commodityid    VARCHAR2(64) not null,
  price          NUMBER(12,2) not null,
  amount         NUMBER(16,6) not null,
  userid         VARCHAR2(32) not null,
  tradetime      DATE default trunc(sysdate),
  b_bail         NUMBER(12,2) default 0 not null,
  b_unfrozenbail NUMBER(12,2) default 0 not null,
  s_bail         NUMBER(12,2) default 0 not null,
  s_unfrozenbail NUMBER(12,2) default 0 not null,
  b_poundage     NUMBER(12,2) default 0 not null,
  s_poundage     NUMBER(12,2) default 0 not null,
  status         NUMBER(3) default -1,
  result         NUMBER(2) default 0,
  b_payments     NUMBER(15,2) default 0 not null,
  s_payments     NUMBER(15,2) default 0 not null,
  b_referpayment NUMBER(15,2) default 0 not null,
  s_referpayment NUMBER(15,2) default 0 not null,
  b_dedit        NUMBER(15,2) default 0 not null,
  s_dedit        NUMBER(15,2) default 0 not null,
  processingtime TIMESTAMP(6),
  remark         VARCHAR2(500)
)
;
alter table V_HISBARGAIN
  add primary key (TRADEDATE, CONTRACTID);

prompt
prompt Creating table V_HISCOMMODITY
prompt =============================
prompt
create table V_HISCOMMODITY
(
  tradedate      DATE not null,
  code           VARCHAR2(64) not null,
  tradepartition NUMBER(3) default 1 not null,
  commodityid    VARCHAR2(128) not null,
  section        NUMBER(5),
  bargaintype    NUMBER(2) default 0 not null,
  modifytime     DATE not null
)
;
alter table V_HISCOMMODITY
  add primary key (TRADEDATE, CODE);

prompt
prompt Creating table V_HISSUBMIT
prompt ==========================
prompt
create table V_HISSUBMIT
(
  tradedate      DATE not null,
  id             NUMBER(12) not null,
  tradepartition NUMBER(3) default 1 not null,
  code           VARCHAR2(64) not null,
  price          NUMBER(12,2) default 0 not null,
  amount         NUMBER(16,6) default 0 not null,
  userid         VARCHAR2(32) not null,
  traderid       VARCHAR2(40) not null,
  submittime     DATE not null,
  ordertype      NUMBER(3) not null,
  validamount    NUMBER(16,6) default 0,
  modifytime     TIMESTAMP(0) default systimestamp(6),
  frozenmargin   NUMBER(15,2) default 0 not null,
  frozenfee      NUMBER(15,2) default 0 not null,
  unfrozenmargin NUMBER(15,2) default 0 not null,
  unfrozenfee    NUMBER(15,2) default 0 not null,
  withdrawtype   NUMBER(2)
)
;
alter table V_HISSUBMIT
  add primary key (TRADEDATE, ID);

prompt
prompt Creating table V_HISTRADEAUTHORITY
prompt ==================================
prompt
create table V_HISTRADEAUTHORITY
(
  tradedate DATE not null,
  code      VARCHAR2(64) not null,
  usercode  VARCHAR2(32) not null,
  modiftime DATE not null
)
;
alter table V_HISTRADEAUTHORITY
  add primary key (TRADEDATE, CODE, USERCODE);

prompt
prompt Creating table V_HISTRADEUSER
prompt =============================
prompt
create table V_HISTRADEUSER
(
  tradedate       DATE not null,
  usercode        VARCHAR2(32) not null,
  overdraft       NUMBER(10,2) default 0 not null,
  isentry         NUMBER(2) default 0 not null,
  tradecount      NUMBER(8) default 0 not null,
  limits          NUMBER(2) default 3 not null,
  iscontinueorder NUMBER(2) default 0 not null,
  modifytime      DATE default sysdate
)
;
alter table V_HISTRADEUSER
  add primary key (TRADEDATE, USERCODE);

prompt
prompt Creating table V_SECTIONATTRIBUTE
prompt =================================
prompt
create table V_SECTIONATTRIBUTE
(
  id            NUMBER(10) not null,
  partitionid   NUMBER(3) not null,
  unitid        NUMBER(5) not null,
  breedid       NUMBER(10) not null,
  attributeid   NUMBER(10),
  attributename VARCHAR2(128),
  num           NUMBER(10),
  updatetime    TIMESTAMP(6)
)
;
alter table V_SECTIONATTRIBUTE
  add primary key (ID);

prompt
prompt Creating table V_SYSCURSTATUS
prompt =============================
prompt
create table V_SYSCURSTATUS
(
  tradepartition NUMBER(3) default 1 not null,
  status         NUMBER(3) not null,
  section        NUMBER(8) not null,
  modifytime     DATE not null,
  starttime      DATE,
  endtime        DATE,
  isclose        NUMBER(2) default 0 not null
)
;
alter table V_SYSCURSTATUS
  add primary key (TRADEPARTITION);

prompt
prompt Creating table V_SYSLOG
prompt =======================
prompt
create table V_SYSLOG
(
  id         NUMBER(15) not null,
  userid     VARCHAR2(16) not null,
  action     NUMBER(2),
  createtime DATE,
  note       VARCHAR2(2000)
)
;
alter table V_SYSLOG
  add primary key (ID);

prompt
prompt Creating table V_SYSPARTITION
prompt =============================
prompt
create table V_SYSPARTITION
(
  partitionid           NUMBER(3) not null,
  firmlimitclass        VARCHAR2(256) not null,
  validetcommodityclass VARCHAR2(256) not null,
  traderuleclass        VARCHAR2(256) not null,
  bargainactionclass    VARCHAR2(256) not null,
  kernelengineclass     VARCHAR2(256) not null,
  countdownclass        VARCHAR2(256) not null,
  validflag             NUMBER(3) not null,
  description           VARCHAR2(128),
  trademode             NUMBER(3) not null,
  selfrate              NUMBER(10) default 0 not null,
  isshowquotation       NUMBER(2) default 0,
  maxshowqty            NUMBER(5) default 3 not null,
  countmode             NUMBER(2) default 0 not null,
  ismargincount         NUMBER(2) default 0 not null,
  issplittarget         NUMBER(2) default 0 not null,
  isshowprice           NUMBER(2) default 0 not null
)
;
alter table V_SYSPARTITION
  add primary key (PARTITIONID);

prompt
prompt Creating table V_SYSPROPERTY
prompt ============================
prompt
create table V_SYSPROPERTY
(
  tradepartition NUMBER(3) default 1 not null,
  durativetime   NUMBER(8) not null,
  spacetime      NUMBER(6) not null,
  countdownstart VARCHAR2(128) not null,
  countdowntime  VARCHAR2(128) not null,
  breedid        NUMBER(10)
)
;
alter table V_SYSPROPERTY
  add primary key (TRADEPARTITION);

prompt
prompt Creating table V_TEMPLETCLASSSET
prompt ================================
prompt
create table V_TEMPLETCLASSSET
(
  id    NUMBER(10) not null,
  class VARCHAR2(256) not null,
  type  NUMBER(2) not null,
  name  VARCHAR2(256) not null
)
;
alter table V_TEMPLETCLASSSET
  add primary key (ID);

prompt
prompt Creating table V_TRADEAUTHORITY
prompt ===============================
prompt
create table V_TRADEAUTHORITY
(
  code      VARCHAR2(64) not null,
  usercode  VARCHAR2(32) not null,
  modiftime DATE not null
)
;
alter table V_TRADEAUTHORITY
  add primary key (CODE, USERCODE);

prompt
prompt Creating table V_TRADEMODEPARAMS
prompt ================================
prompt
create table V_TRADEMODEPARAMS
(
  id   NUMBER(10) not null,
  name VARCHAR2(32) not null
)
;
alter table V_TRADEMODEPARAMS
  add primary key (ID);

prompt
prompt Creating table V_TRADEUSER
prompt ==========================
prompt
create table V_TRADEUSER
(
  usercode        VARCHAR2(32) not null,
  overdraft       NUMBER(10,2) default 0 not null,
  isentry         NUMBER(2) default 0 not null,
  tradecount      NUMBER(8) default 0 not null,
  limits          NUMBER(2) default 3 not null,
  iscontinueorder NUMBER(2) default 0 not null,
  modifytime      DATE default sysdate
)
;
alter table V_TRADEUSER
  add primary key (USERCODE);

prompt
prompt Creating table W_ERRORLOGINLOG
prompt ==============================
prompt
create table W_ERRORLOGINLOG
(
  errorloginid NUMBER(15) not null,
  userid       VARCHAR2(32) not null,
  logindate    DATE not null,
  warehouseid  VARCHAR2(32) not null,
  ip           VARCHAR2(32)
)
;
comment on column W_ERRORLOGINLOG.userid
  is '管理员Id';
alter table W_ERRORLOGINLOG
  add primary key (ERRORLOGINID);

prompt
prompt Creating table W_GLOBALLOG_ALL
prompt ==============================
prompt
create table W_GLOBALLOG_ALL
(
  id             NUMBER(15) not null,
  operator       VARCHAR2(32),
  warehouseid    VARCHAR2(32),
  operatetime    DATE default sysdate,
  operatetype    NUMBER(4),
  operateip      VARCHAR2(32),
  operatortype   VARCHAR2(32),
  mark           VARCHAR2(4000),
  operatecontent VARCHAR2(4000),
  currentvalue   VARCHAR2(4000),
  operateresult  NUMBER(1) default 0,
  logtype        NUMBER(2)
)
;
comment on column W_GLOBALLOG_ALL.id
  is 'ID';
comment on column W_GLOBALLOG_ALL.operator
  is '操作人';
comment on column W_GLOBALLOG_ALL.operatetime
  is '操作时间';
comment on column W_GLOBALLOG_ALL.operatetype
  is '操作类型';
comment on column W_GLOBALLOG_ALL.operateip
  is '操作IP';
comment on column W_GLOBALLOG_ALL.operatortype
  is '操作人种类';
comment on column W_GLOBALLOG_ALL.mark
  is '标示';
comment on column W_GLOBALLOG_ALL.operatecontent
  is '操作内容';
comment on column W_GLOBALLOG_ALL.currentvalue
  is '当前值';
comment on column W_GLOBALLOG_ALL.operateresult
  is '操作结果 1 成功  0 失败';
alter table W_GLOBALLOG_ALL
  add primary key (ID);
alter table W_GLOBALLOG_ALL
  add constraint RC_W_GLOBALLOG_ALL
  check (operateresult in(0,1));

prompt
prompt Creating table W_GLOBALLOG_ALL_H
prompt ================================
prompt
create table W_GLOBALLOG_ALL_H
(
  id             NUMBER(15) not null,
  operator       VARCHAR2(32),
  warehouseid    VARCHAR2(32),
  operatetime    DATE,
  operatetype    NUMBER(4),
  operateip      VARCHAR2(32),
  operatortype   VARCHAR2(32),
  mark           VARCHAR2(4000),
  operatecontent VARCHAR2(4000),
  currentvalue   VARCHAR2(4000),
  operateresult  NUMBER(1) default 0,
  logtype        NUMBER(2)
)
;
comment on column W_GLOBALLOG_ALL_H.id
  is 'ID';
comment on column W_GLOBALLOG_ALL_H.operator
  is '操作人';
comment on column W_GLOBALLOG_ALL_H.operatetime
  is '操作时间';
comment on column W_GLOBALLOG_ALL_H.operatetype
  is '操作类型';
comment on column W_GLOBALLOG_ALL_H.operateip
  is '操作IP';
comment on column W_GLOBALLOG_ALL_H.operatortype
  is '操作人种类';
comment on column W_GLOBALLOG_ALL_H.mark
  is '标示';
comment on column W_GLOBALLOG_ALL_H.operatecontent
  is '操作内容';
comment on column W_GLOBALLOG_ALL_H.currentvalue
  is '当前值';
comment on column W_GLOBALLOG_ALL_H.operateresult
  is '操作结果 1 成功  0 失败';
alter table W_GLOBALLOG_ALL_H
  add constraint RC_W_GLOBALLOG_ALL_H
  check (operateresult in(0,1));

prompt
prompt Creating table W_LOGCATALOG
prompt ===========================
prompt
create table W_LOGCATALOG
(
  catalogid   NUMBER(4) not null,
  moduleid    NUMBER(2) not null,
  catalogname VARCHAR2(32)
)
;
comment on table W_LOGCATALOG
  is '日志分类，4位数字的编码，以日志模块ID开头。';
comment on column W_LOGCATALOG.catalogid
  is '日志分类ID：4位数字的编码，详见备注Notes。';
comment on column W_LOGCATALOG.catalogname
  is '日志分类名';
alter table W_LOGCATALOG
  add primary key (CATALOGID);

prompt
prompt Creating table W_MYMENU
prompt =======================
prompt
create table W_MYMENU
(
  userid  VARCHAR2(32) not null,
  rightid NUMBER(10) not null
)
;
alter table W_MYMENU
  add primary key (USERID, RIGHTID);

prompt
prompt Creating table W_RIGHT
prompt ======================
prompt
create table W_RIGHT
(
  id           NUMBER(10) not null,
  parentid     NUMBER(10),
  name         VARCHAR2(128),
  moduleid     NUMBER(2) not null,
  icon         VARCHAR2(128),
  authorityurl VARCHAR2(512),
  visiturl     VARCHAR2(512),
  seq          NUMBER(3),
  visible      NUMBER(1),
  type         NUMBER(1) not null,
  catalogid    NUMBER(4),
  iswritelog   VARCHAR2(1) default 'N'
)
;
comment on column W_RIGHT.id
  is ' 规范：
1：开头两位为系统模块号
2: 第三四位为一级菜单
3：第五六位为二级菜单
4：第七八位为三级菜单
5：第九十位为页面中的增删改查
';
comment on column W_RIGHT.parentid
  is '父关联';
comment on column W_RIGHT.name
  is '权限名称';
comment on column W_RIGHT.icon
  is '图标';
comment on column W_RIGHT.authorityurl
  is '权限路径';
comment on column W_RIGHT.visiturl
  is '真实路径';
comment on column W_RIGHT.seq
  is '序号';
comment on column W_RIGHT.visible
  is '是否可见-1 不可见0 可见';
comment on column W_RIGHT.type
  is '类型-3:只检查session不检查权限的url -2：无需判断权限的URL -1： 父菜单类型 0：子菜单类型 1：页面内增删改查权限';
comment on column W_RIGHT.catalogid
  is '日志类型 0不写日志 其它对应表w_logcatalog 的CATALOGID字段';
comment on column W_RIGHT.iswritelog
  is '''Y''：写日志、''N''：不写日志';
alter table W_RIGHT
  add primary key (ID);
alter table W_RIGHT
  add constraint CHECK_W_RIGHT_TYPE
  check (TYPE in (-3,-2,-1,0,1));
alter table W_RIGHT
  add constraint CHECK_W_RIGHT_VISIBLE
  check (VISIBLE in (-1,0));

prompt
prompt Creating table W_ROLE
prompt =====================
prompt
create table W_ROLE
(
  id          NUMBER(10) not null,
  name        VARCHAR2(32) not null,
  warehouseid VARCHAR2(32) not null,
  description VARCHAR2(256)
)
;
comment on column W_ROLE.id
  is '角色Id';
comment on column W_ROLE.name
  is '角色名称';
comment on column W_ROLE.description
  is '描述';
alter table W_ROLE
  add primary key (ID);

prompt
prompt Creating table W_ROLE_RIGHT
prompt ===========================
prompt
create table W_ROLE_RIGHT
(
  rightid NUMBER(10) not null,
  roleid  NUMBER(10) not null
)
;
comment on column W_ROLE_RIGHT.rightid
  is '权限Id';
comment on column W_ROLE_RIGHT.roleid
  is '角色Id';
alter table W_ROLE_RIGHT
  add primary key (RIGHTID, ROLEID);

prompt
prompt Creating table W_TRADEMODULE
prompt ============================
prompt
create table W_TRADEMODULE
(
  moduleid           NUMBER(2) not null,
  cnname             VARCHAR2(64) not null,
  enname             VARCHAR2(64),
  shortname          VARCHAR2(16),
  addfirmfn          VARCHAR2(36),
  updatefirmstatusfn VARCHAR2(36),
  delfirmfn          VARCHAR2(36),
  isfirmset          CHAR(1) default 'N' not null,
  hostip             VARCHAR2(16),
  port               NUMBER(6),
  rmidataport        NUMBER(6),
  isbalancecheck     CHAR(1) default 'N' not null,
  isneedbreed        CHAR(1) not null
)
;
comment on column W_TRADEMODULE.moduleid
  is '10综合管理平台
11财务系统
12监管仓库管理系统
13仓单管理系统
14融资系统
15订单交易
18投资类大宗商品交易系统
19加盟会员管理系统
20做市商交易系统
21竞价系统
22银行接入及结算系统
23E现货
24单点登录系统
25实时行情分析系统
26交易客户端
98demo系统
99公用系统';
comment on column W_TRADEMODULE.isfirmset
  is '‘Y’ 是 ‘N’ 否 (如果需要在公用前台我的平台中显示本系统，还需要在公用系统的 spring_sys_msg.xml 中配置上本系统的配置信息)';
comment on column W_TRADEMODULE.isbalancecheck
  is 'Y：是 N：否';
comment on column W_TRADEMODULE.isneedbreed
  is '本系统是否需要综合管理平台增加的商品   Y:是   N:否';
alter table W_TRADEMODULE
  add primary key (MODULEID);

prompt
prompt Creating table W_USER
prompt =====================
prompt
create table W_USER
(
  userid      VARCHAR2(32) not null,
  warehouseid VARCHAR2(32) not null,
  name        VARCHAR2(32),
  password    VARCHAR2(32),
  type        VARCHAR2(20) default 'ADMIN' not null,
  description VARCHAR2(256),
  isforbid    CHAR(1) default 'N' not null,
  skin        VARCHAR2(16) default 'default' not null,
  keycode     VARCHAR2(128) default '0123456789ABCDE' not null
)
;
comment on column W_USER.userid
  is '管理员Id';
comment on column W_USER.name
  is '管理员名称';
comment on column W_USER.password
  is '密码';
comment on column W_USER.type
  is 'ADMIN：普通管理员角色DEFAULT_ADMIN：高级管理员角色DEFAULT_SUPER_ADMIN：默认超级管理员角色';
comment on column W_USER.description
  is '描述';
comment on column W_USER.isforbid
  is 'Y：禁用
N：不禁用
';
comment on column W_USER.skin
  is '皮肤';
comment on column W_USER.keycode
  is 'key';
alter table W_USER
  add primary key (USERID);

prompt
prompt Creating table W_USER_RIGHT
prompt ===========================
prompt
create table W_USER_RIGHT
(
  rightid NUMBER(10) not null,
  userid  VARCHAR2(32) not null
)
;
comment on column W_USER_RIGHT.rightid
  is '权限Id
权限Id';
comment on column W_USER_RIGHT.userid
  is '管理员Id';
alter table W_USER_RIGHT
  add primary key (RIGHTID, USERID);

prompt
prompt Creating table W_USER_ROLE
prompt ==========================
prompt
create table W_USER_ROLE
(
  userid VARCHAR2(32) not null,
  roleid NUMBER(10) not null
)
;
comment on column W_USER_ROLE.userid
  is '管理员Id';
comment on column W_USER_ROLE.roleid
  is '角色Id';
alter table W_USER_ROLE
  add primary key (USERID, ROLEID);

prompt
prompt Creating sequence SEQ_BI_DISMANTLE
prompt ==================================
prompt
create sequence SEQ_BI_DISMANTLE
minvalue 1
maxvalue 9999999999999999999999999999
start with 541
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_BI_FINANCINGSTOCK
prompt =======================================
prompt
create sequence SEQ_BI_FINANCINGSTOCK
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_BI_FROZENSTOCK
prompt ====================================
prompt
create sequence SEQ_BI_FROZENSTOCK
minvalue 1
maxvalue 9999999999999999999999999999
start with 81
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_BI_OUTSTOCK
prompt =================================
prompt
create sequence SEQ_BI_OUTSTOCK
minvalue 1
maxvalue 9999999999999999999999999999
start with 741
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_BI_PLEDGESTOCK
prompt ====================================
prompt
create sequence SEQ_BI_PLEDGESTOCK
minvalue 1
maxvalue 9999999999999999999999999999
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_BI_STOCK
prompt ==============================
prompt
create sequence SEQ_BI_STOCK
minvalue 1
maxvalue 9999999999999999999999999999
start with 1021
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_BI_STOCKCHGLOG
prompt ====================================
prompt
create sequence SEQ_BI_STOCKCHGLOG
minvalue 1
maxvalue 9999999999999999999999999999
start with 561
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_BI_TRADESTOCK
prompt ===================================
prompt
create sequence SEQ_BI_TRADESTOCK
minvalue 1
maxvalue 9999999999999999999999999999
start with 584
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_BI_WAREHOUSE
prompt ==================================
prompt
create sequence SEQ_BI_WAREHOUSE
minvalue 1
maxvalue 9999999999999999999999999999
start with 241
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_BR_BROKERAREA
prompt ===================================
prompt
create sequence SEQ_BR_BROKERAREA
minvalue 1
maxvalue 9999999999999999999999999999
start with 21
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_C_APPLY
prompt =============================
prompt
create sequence SEQ_C_APPLY
minvalue 1
maxvalue 9999999999999999999999999999
start with 1000000
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_C_AUDIT
prompt =============================
prompt
create sequence SEQ_C_AUDIT
minvalue 1
maxvalue 9999999999999999999999999999
start with 1000000
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_C_FRONT_ROLE
prompt ==================================
prompt
create sequence SEQ_C_FRONT_ROLE
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_C_GLOBALLOG
prompt =================================
prompt
create sequence SEQ_C_GLOBALLOG
minvalue 1
maxvalue 9999999999999999999999999999
start with 24059
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_C_ROLE
prompt ============================
prompt
create sequence SEQ_C_ROLE
minvalue 1
maxvalue 9999999999999999999999999999
start with 101
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_F_B_ACTION
prompt ================================
prompt
create sequence SEQ_F_B_ACTION
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_F_B_BANKCOMPAREINFO
prompt =========================================
prompt
create sequence SEQ_F_B_BANKCOMPAREINFO
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_F_B_CAPITALINFO
prompt =====================================
prompt
create sequence SEQ_F_B_CAPITALINFO
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_F_B_DICTIONARY
prompt ====================================
prompt
create sequence SEQ_F_B_DICTIONARY
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_F_B_FEEINFO
prompt =================================
prompt
create sequence SEQ_F_B_FEEINFO
minvalue 1
maxvalue 999999999999999999999999999
start with 2
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_F_B_INTERFACELOG
prompt ======================================
prompt
create sequence SEQ_F_B_INTERFACELOG
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_F_B_LOG
prompt =============================
prompt
create sequence SEQ_F_B_LOG
minvalue 1
maxvalue 999999999999999999999999999
start with 18
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_F_B_MAKETMONEY
prompt ====================================
prompt
create sequence SEQ_F_B_MAKETMONEY
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_F_B_MARGINS
prompt =================================
prompt
create sequence SEQ_F_B_MARGINS
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_F_B_QSRESULT
prompt ==================================
prompt
create sequence SEQ_F_B_QSRESULT
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_F_B_RGSTCAPITALVALUE
prompt ==========================================
prompt
create sequence SEQ_F_B_RGSTCAPITALVALUE
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_F_B_TRADEDATA
prompt ===================================
prompt
create sequence SEQ_F_B_TRADEDATA
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_F_B_TRADELIST
prompt ===================================
prompt
create sequence SEQ_F_B_TRADELIST
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_F_B_TRANSMONEYOBJ
prompt =======================================
prompt
create sequence SEQ_F_B_TRANSMONEYOBJ
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_F_FROZENFUNDFLOW
prompt ======================================
prompt
create sequence SEQ_F_FROZENFUNDFLOW
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_F_FUNDFLOW
prompt ================================
prompt
create sequence SEQ_F_FUNDFLOW
minvalue 1
maxvalue 9999999999999999999999999999
start with 50488
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_F_VOUCHER
prompt ===============================
prompt
create sequence SEQ_F_VOUCHER
minvalue 1
maxvalue 9999999999999999999999999999
start with 63373
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_F_VOUCHERENTRY
prompt ====================================
prompt
create sequence SEQ_F_VOUCHERENTRY
minvalue 1
maxvalue 9999999999999999999999999999
start with 126745
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_IPO_BALLOTNO_INFO
prompt =======================================
prompt
create sequence SEQ_IPO_BALLOTNO_INFO
minvalue 1
maxvalue 9999999999999999999999999999
start with 1041
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_IPO_COMMODITY
prompt ===================================
prompt
create sequence SEQ_IPO_COMMODITY
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_IPO_DISTRIBUTION
prompt ======================================
prompt
create sequence SEQ_IPO_DISTRIBUTION
minvalue 1
maxvalue 9999999999999999999999999999
start with 281
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_IPO_NUMBEROFRECORDS
prompt =========================================
prompt
create sequence SEQ_IPO_NUMBEROFRECORDS
minvalue 1
maxvalue 9999999999999999999999999999
start with 301
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_IPO_NUMBEROFRECORDS_H
prompt ===========================================
prompt
create sequence SEQ_IPO_NUMBEROFRECORDS_H
minvalue 1
maxvalue 9999999999999999999999999999
start with 61
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_IPO_ORDER
prompt ===============================
prompt
create sequence SEQ_IPO_ORDER
minvalue 1
maxvalue 9999999999999999999999999999
start with 121
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_IPO_ORDER_H
prompt =================================
prompt
create sequence SEQ_IPO_ORDER_H
minvalue 1
maxvalue 9999999999999999999999999999
start with 81
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_M_BREED
prompt =============================
prompt
create sequence SEQ_M_BREED
minvalue 1
maxvalue 9999999999999999999999999999
start with 1320
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_M_CATEGORY
prompt ================================
prompt
create sequence SEQ_M_CATEGORY
minvalue 1
maxvalue 9999999999999999999999999999
start with 1200
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_M_FIRMCATEGORY
prompt ====================================
prompt
create sequence SEQ_M_FIRMCATEGORY
minvalue 1
maxvalue 9999999999999999999999999999
start with 61
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_M_FIRM_APPLY
prompt ==================================
prompt
create sequence SEQ_M_FIRM_APPLY
minvalue 1
maxvalue 9999999999999999999999999999
start with 602
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_M_MESSAGE
prompt ===============================
prompt
create sequence SEQ_M_MESSAGE
minvalue 1
maxvalue 9999999999999999999999999999
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_M_NOTICE
prompt ==============================
prompt
create sequence SEQ_M_NOTICE
minvalue 1
maxvalue 9999999999999999999999999999
start with 61
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_M_PROPERTY
prompt ================================
prompt
create sequence SEQ_M_PROPERTY
minvalue 1
maxvalue 9999999999999999999999999999
start with 1180
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_M_PROPERTYTYPE
prompt ====================================
prompt
create sequence SEQ_M_PROPERTYTYPE
minvalue 1
maxvalue 9999999999999999999999999999
start with 160
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_TESTGB
prompt ============================
prompt
create sequence SEQ_TESTGB
minvalue 1
maxvalue 9999999999999999999999999999
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_TM_TRADEMONITOR
prompt =====================================
prompt
create sequence SEQ_TM_TRADEMONITOR
minvalue 1
maxvalue 9999999999999999999999999999
start with 203541240
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_A_BREED
prompt ===============================
prompt
create sequence SEQ_T_A_BREED
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_A_CMDTYSORT
prompt ===================================
prompt
create sequence SEQ_T_A_CMDTYSORT
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_A_SETTLEPRIVILEGE
prompt =========================================
prompt
create sequence SEQ_T_A_SETTLEPRIVILEGE
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_A_TRADEPRIVILEGE
prompt ========================================
prompt
create sequence SEQ_T_A_TRADEPRIVILEGE
minvalue 1
maxvalue 9999999999999999999999999999
start with 181
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_BILLFROZEN
prompt ==================================
prompt
create sequence SEQ_T_BILLFROZEN
minvalue 1
maxvalue 9999999999999999999999999999
start with 644
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_BROADCAST
prompt =================================
prompt
create sequence SEQ_T_BROADCAST
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_CONDITIONORDER
prompt ======================================
prompt
create sequence SEQ_T_CONDITIONORDER
minvalue 1
maxvalue 10000000000000000
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_DELAYORDERS
prompt ===================================
prompt
create sequence SEQ_T_DELAYORDERS
minvalue 1
maxvalue 9999999999999999999999999999
start with 761
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_DELAYTRADE
prompt ==================================
prompt
create sequence SEQ_T_DELAYTRADE
minvalue 1
maxvalue 9999999999999999999999999999
start with 221
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_D_ORDERLOG
prompt ==================================
prompt
create sequence SEQ_T_D_ORDERLOG
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_D_ORDERSUMLOG
prompt =====================================
prompt
create sequence SEQ_T_D_ORDERSUMLOG
minvalue 1
maxvalue 9999999999999999999999999999
start with 781
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_E_APPLYAHEADSETTLE
prompt ==========================================
prompt
create sequence SEQ_T_E_APPLYAHEADSETTLE
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_E_APPLYBILL
prompt ===================================
prompt
create sequence SEQ_T_E_APPLYBILL
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_E_APPLYGAGE
prompt ===================================
prompt
create sequence SEQ_T_E_APPLYGAGE
minvalue 1
maxvalue 9999999999999999999999999999
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_E_APPLYTREATYSETTLE
prompt ===========================================
prompt
create sequence SEQ_T_E_APPLYTREATYSETTLE
minvalue 1
maxvalue 9999999999999999999999999999
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_E_DEDUCTPOSITION
prompt ========================================
prompt
create sequence SEQ_T_E_DEDUCTPOSITION
minvalue 1
maxvalue 9999999999999999999999999999
start with 6
increment by 1
nocache;

prompt
prompt Creating sequence SEQ_T_E_EMBEDORDERS
prompt =====================================
prompt
create sequence SEQ_T_E_EMBEDORDERS
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_E_FUNDTRANSFER
prompt ======================================
prompt
create sequence SEQ_T_E_FUNDTRANSFER
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_E_GAGEBILL
prompt ==================================
prompt
create sequence SEQ_T_E_GAGEBILL
minvalue 1
maxvalue 9999999999999999999999999999
start with 61
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_E_PLEDGE
prompt ================================
prompt
create sequence SEQ_T_E_PLEDGE
minvalue 1
maxvalue 9999999999999999999999999999
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_E_SETTLELOG
prompt ===================================
prompt
create sequence SEQ_T_E_SETTLELOG
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_E_VIRTUALFUNDSAPPLY
prompt ===========================================
prompt
create sequence SEQ_T_E_VIRTUALFUNDSAPPLY
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_HOLDFROZEN
prompt ==================================
prompt
create sequence SEQ_T_HOLDFROZEN
minvalue 1
maxvalue 9999999999999999999999999999
start with 61
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_HOLDPOSITION
prompt ====================================
prompt
create sequence SEQ_T_HOLDPOSITION
minvalue 1
maxvalue 9999999999999999999999999999
start with 175082
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_NOTSENDBROADCAST
prompt ========================================
prompt
create sequence SEQ_T_NOTSENDBROADCAST
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_ORDERS
prompt ==============================
prompt
create sequence SEQ_T_ORDERS
minvalue 1
maxvalue 9999999999999999999999999999
start with 168502
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_SETTLEHOLDPOSITION
prompt ==========================================
prompt
create sequence SEQ_T_SETTLEHOLDPOSITION
minvalue 1
maxvalue 9999999999999999999999999999
start with 821
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_SETTLEMATCH
prompt ===================================
prompt
create sequence SEQ_T_SETTLEMATCH
minvalue 1
maxvalue 9999999999999999999999999999
start with 644
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_SETTLEMATCHFUNDMANAGE
prompt =============================================
prompt
create sequence SEQ_T_SETTLEMATCHFUNDMANAGE
minvalue 1
maxvalue 9999999999999999999999999999
start with 763
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_SETTLEMATCHLOG
prompt ======================================
prompt
create sequence SEQ_T_SETTLEMATCHLOG
minvalue 1
maxvalue 9999999999999999999999999999
start with 821
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_SETTLEPROPS
prompt ===================================
prompt
create sequence SEQ_T_SETTLEPROPS
minvalue 1
maxvalue 9999999999999999999999999999
start with 341
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_SPECFROZENHOLD
prompt ======================================
prompt
create sequence SEQ_T_SPECFROZENHOLD
minvalue 1
maxvalue 9999999999999999999999999999
start with 19701
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_SYSLOG
prompt ==============================
prompt
create sequence SEQ_T_SYSLOG
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_TRADE
prompt =============================
prompt
create sequence SEQ_T_TRADE
minvalue 1
maxvalue 9999999999999999999999999999
start with 470622
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_UNTRADETRANSFER
prompt =======================================
prompt
create sequence SEQ_T_UNTRADETRANSFER
minvalue 1
maxvalue 9999999999999999999999999999
start with 41
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_T_VALIDBILL
prompt =================================
prompt
create sequence SEQ_T_VALIDBILL
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_V_COMMEXT
prompt ===============================
prompt
create sequence SEQ_V_COMMEXT
minvalue 1
maxvalue 9999999999999999999999999999
start with 121
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_V_FUNDFROZEN
prompt ==================================
prompt
create sequence SEQ_V_FUNDFROZEN
minvalue 1
maxvalue 9999999999999999999999999999
start with 101
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_V_SECTIONATTRIBUTE
prompt ========================================
prompt
create sequence SEQ_V_SECTIONATTRIBUTE
minvalue 1
maxvalue 9999999999999999999999999999
start with 121
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_W_ERRORLOGINLOG
prompt =====================================
prompt
create sequence SEQ_W_ERRORLOGINLOG
minvalue 1
maxvalue 9999999999999999999999999999
start with 341
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_W_GLOBALLOG_ALL
prompt =====================================
prompt
create sequence SEQ_W_GLOBALLOG_ALL
minvalue 1
maxvalue 9999999999999999999999999999
start with 1221
increment by 1
cache 20;

prompt
prompt Creating sequence SEQ_W_ROLE
prompt ============================
prompt
create sequence SEQ_W_ROLE
minvalue 1
maxvalue 9999999999999999999999999999
start with 21
increment by 1
cache 20;

prompt
prompt Creating sequence SP_V_BARGAIN
prompt ==============================
prompt
create sequence SP_V_BARGAIN
minvalue 1
maxvalue 9999999999999999999999999999
start with 81
increment by 1
cache 20;

prompt
prompt Creating sequence SP_V_COMMODITY
prompt ================================
prompt
create sequence SP_V_COMMODITY
minvalue 1
maxvalue 9999999999999999999999999999
start with 101
increment by 1
cache 20;

prompt
prompt Creating sequence SP_V_COMMODITYTYPE
prompt ====================================
prompt
create sequence SP_V_COMMODITYTYPE
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SP_V_COMMODITY_CODE
prompt =====================================
prompt
create sequence SP_V_COMMODITY_CODE
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SP_V_CURSUBMIT
prompt ================================
prompt
create sequence SP_V_CURSUBMIT
minvalue 1
maxvalue 9999999999999999999999999999
start with 81
increment by 1
cache 20;

prompt
prompt Creating sequence SP_V_OUTID
prompt ============================
prompt
create sequence SP_V_OUTID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SP_V_PAYMENTFORSELLER
prompt =======================================
prompt
create sequence SP_V_PAYMENTFORSELLER
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SP_V_SYSLOG
prompt =============================
prompt
create sequence SP_V_SYSLOG
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SP_V_VOUCHERENTRYID
prompt =====================================
prompt
create sequence SP_V_VOUCHERENTRYID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating sequence SP_V_VOUCHERNO
prompt ================================
prompt
create sequence SP_V_VOUCHERNO
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

prompt
prompt Creating view V_BI_BUSINESSRELATIONSHIP
prompt =======================================
prompt
create or replace force view v_bi_businessrelationship as
select  t."STOCKID",t."BREEDNAME",t."WAREHOUSEID",t."QUANTITY",t."UNIT",t."SELLER",t."BUYER",t."RECEIVED",t."RECEIVEDDATE",t."SELLTIME", nvl(bi.stockid,0)  as invoiceStatus
from (select b.stockid,m.breedname,s.warehouseid,s.quantity,s.unit,b.seller,b.buyer,b.received,b.receiveddate,b.selltime
from  BI_BusinessRelationship b,BI_stock s,m_breed m
where b.stockid=s.stockid and s.breedid=m.breedid)t
left join bi_invoiceinform bi on bi.stockid=t.stockid;

prompt
prompt Creating view V_BI_INVOICEINFORM
prompt ================================
prompt
create or replace force view v_bi_invoiceinform as
select i.stockid,m.breedname,s.warehouseid,s.quantity,s.unit,i.invoicetype,
i.companyname,i.address,i.dutyparagraph,i.bank,i.bankaccount,i.name,i.phone
from  BI_Invoiceinform i,BI_stock s,m_breed m
where i.stockid=s.stockid and s.breedid=m.breedid;

prompt
prompt Creating view V_BI_OUTSTOCK
prompt ===========================
prompt
create or replace force view v_bi_outstock as
select  t3.stockid,t3.realstockcode,t3.breedid,t3.breedname,t3.ownerfirm,t3.warehouseid,t3.quantity,t3.unit,t3.createtime,t3.lasttime,t3.company,t3.logisticsorder,
case when t3.received is null or t3.received='0' then 0
else 1 end isreceived,t3.receiveddate,nvl(i.stockid,0) as invoiceStatus
from (select   t1.stockid,t1.realstockcode,t1.breedid,t1.breedname,t1.ownerfirm,t1.warehouseid,t1.quantity,t1.unit,t1.createtime,t1.lasttime,t1.company,t1.logisticsorder,t2.received,t2.receiveddate from (
              select t.stockid,t.realstockcode,t.breedid,m.breedname,t.ownerfirm,t.warehouseid,t.quantity,t.unit,t.createtime,t.lasttime,b.company,b.logisticsorder from
                     (select stockid,realstockcode,breedid,ownerfirm,warehouseid,quantity,unit,createtime,lasttime from bi_stock o where stockstatus=2) t
                      left  join bi_logistics b on t.stockid=b.stockid
                      inner join  m_breed   m on m.breedid=t.breedid
               ) t1

left  join
(select stockid,received,receiveddate,buyer from bi_businessrelationship  where  selltime in (select selltime from ( select stockid,max(selltime) selltime from bi_businessrelationship group by stockid))) t2
on t1.stockid=t2.stockid and t1.ownerfirm=t2.buyer) t3
LEFT JOIN BI_INVOICEINFORM i ON i.STOCKID=t3.stockid;

prompt
prompt Creating view V_COMMODITYTARIFF
prompt ===============================
prompt
create or replace force view v_commoditytariff as
select tariffID,
    decode(t.FEEALGR,1,to_char(t.FEERATE_B * 100, 'fm9999999990.009999') || '%',to_char(t.FEERATE_B, 'fm9999999990.009999')) newFeeRate_B,
    decode(t.FEEALGR,1,to_char(t.FEERATE_S * 100, 'fm9999999990.009999') || '%',to_char(t.FEERATE_S, 'fm9999999990.009999')) newFeeRate_S,
    decode(t.FEEALGR,1,to_char(t.TodayCloseFeeRate_B * 100, 'fm9999999990.009999') || '%',to_char(t.TodayCloseFeeRate_B, 'fm9999999990.009999')) newTodayCloseFeeRate_B,
    decode(t.FEEALGR,1,to_char(t.TodayCloseFeeRate_S * 100, 'fm9999999990.009999') || '%',to_char(t.TodayCloseFeeRate_S, 'fm9999999990.009999')) newTodayCloseFeeRate_S,
    decode(t.FEEALGR,1,to_char(t.HistoryCloseFeeRate_B * 100, 'fm9999999990.009999') || '%',to_char(t.HistoryCloseFeeRate_B, 'fm9999999990.009999')) newHistoryCloseFeeRate_B,
    decode(t.FEEALGR,1,to_char(t.HistoryCloseFeeRate_S * 100, 'fm9999999990.009999') || '%',to_char(t.HistoryCloseFeeRate_S, 'fm9999999990.009999')) newHistoryCloseFeeRate_S,
    decode(t.ForceCloseFeeAlgr,1,to_char(t.ForceCloseFeeRate_B * 100, 'fm9999999990.009999') || '%',to_char(t.ForceCloseFeeRate_B, 'fm9999999990.009999')) newForceCloseFeeRate_B,
    decode(t.ForceCloseFeeAlgr,1,to_char(t.ForceCloseFeeRate_S * 100, 'fm9999999990.009999') || '%',to_char(t.ForceCloseFeeRate_S, 'fm9999999990.009999')) newForceCloseFeeRate_S,
    decode(c.FEEALGR,1,to_char(c.FEERATE_B * 100, 'fm9999999990.009999') || '%',to_char(c.FEERATE_B, 'fm9999999990.009999')) oldFeeRate_B,
    decode(c.FEEALGR,1,to_char(c.FEERATE_S * 100, 'fm9999999990.009999') || '%',to_char(c.FEERATE_S, 'fm9999999990.009999')) oldFeeRate_S,
    decode(c.FEEALGR,1,to_char(c.TodayCloseFeeRate_B * 100, 'fm9999999990.009999') || '%',to_char(c.TodayCloseFeeRate_B, 'fm9999999990.009999')) oldTodayCloseFeeRate_B,
    decode(c.FEEALGR,1,to_char(c.TodayCloseFeeRate_S * 100, 'fm9999999990.009999') || '%',to_char(c.TodayCloseFeeRate_S, 'fm9999999990.009999')) oldTodayCloseFeeRate_S,
    decode(c.FEEALGR,1,to_char(c.HistoryCloseFeeRate_B * 100, 'fm9999999990.009999') || '%',to_char(c.HistoryCloseFeeRate_B, 'fm9999999990.009999')) oldHistoryCloseFeeRate_B,
    decode(c.FEEALGR,1,to_char(c.HistoryCloseFeeRate_S * 100, 'fm9999999990.009999') || '%',to_char(c.HistoryCloseFeeRate_S, 'fm9999999990.009999')) oldHistoryCloseFeeRate_S,
    decode(c.ForceCloseFeeAlgr,1,to_char(c.ForceCloseFeeRate_B * 100, 'fm9999999990.009999') || '%',to_char(c.ForceCloseFeeRate_B, 'fm9999999990.009999')) oldForceCloseFeeRate_B,
    decode(c.ForceCloseFeeAlgr,1,to_char(c.ForceCloseFeeRate_S * 100, 'fm9999999990.009999') || '%',to_char(c.ForceCloseFeeRate_S, 'fm9999999990.009999')) oldForceCloseFeeRate_S,
     t.MODIFYTIME,t.createUser,t.TariffName,TariffRate * 100 || '%' TARIFFRATE,c.name,t.commodityID from T_A_Tariff t, T_COMMODITY c where t.commodityid = c.commodityid;

prompt
prompt Creating view V_C_CUSTOMERFUNDS
prompt ===============================
prompt
create or replace force view v_c_customerfunds as
select FIRMID,FIRMNAME,NOWLEAVEBALANCE,RUNTIMEFL,RUNTIMEMARGIN,RUNTIMEASSURE,LASTBALANCE,CLEARFL,CLEARMARGIN,CLEARASSURE,TRADEFEE,MAXOVERDRAFT,CLOSE_PL
    from  (select a.*,
          f.balance,
          f.frozenfunds,
          f.lastbalance,
          m.name FirmName,
          tt.TradeFee,
          nvl(nvl(balance, 0) + nvl((-1) * FrozenFunds, 0), 0) nowLeaveBalance,
          nvl(d.close_PL, 0) close_PL
     from T_Firm a,
          (select sum(t.TradeFee) TradeFee, t.firmID firmID
             from T_Trade t
            group by firmID) tt,
          F_FirmFunds f,
          M_firm m,
          (select firmID, nvl(sum(Close_PL), 0) close_PL
             from T_Trade
            group by firmID) d
    where a.FirmID = tt.FirmID(+)
      and a.FirmID = f.FirmID
      and m.firmID = a.firmID
      and a.firmid = d.firmID(+)
    order by nowLeaveBalance ASC) Q;

prompt
prompt Creating view V_C_TRADEMODULE
prompt =============================
prompt
create or replace force view v_c_trademodule as
select distinct l.moduleid,t.shortname name from f_ledgerfield  l,C_TradeModule t where l.moduleid=t.moduleid;

prompt
prompt Creating view V_ERRORLOGINLOG
prompt =============================
prompt
create or replace force view v_errorloginlog as
select trader.traderid as "TRADERID",trader.userid as "USERID",logs.counts as "COUNTS",logs.loginDate as "LOGINDATE" from (select traderid,count(*) counts,trunc(loginDate) loginDate from m_errorloginlog group by traderid,trunc(loginDate)) logs,m_trader trader where trader.traderid = logs.traderid;

prompt
prompt Creating view V_F_FIRMCURFUNDS
prompt ==============================
prompt
create or replace force view v_f_firmcurfunds as
select firmId,          --交易商代码
       name,            --交易商名称
       f_balance,       --交易系统当前余额
       l_balance,       --财务结算余额
       y_balance,       --财务未结算金额
       balanceSubtract, --差额
       lastwarranty,    --担保金
       frozenFunds,     --临时资金
       user_balance     --可用资金
  from (select z.*,
               f_balance - l_balance - y_balance balanceSubtract,
               f_balance + FrozenFunds user_balance
          from (select f.firmid,
                       (select name from m_firm where firmId = f.firmId) name,
                       f.balance f_balance,
                       nvl(h.todaybalance, 0) l_balance,
                       nvl(e.y_balance, 0) y_balance,
                       nvl(f.lastwarranty, 0) lastwarranty,
                       nvl(-1 * FrozenFunds, 0) FrozenFunds
                  from F_FirmFunds f,
                       (select h1.firmid, h1.todaybalance
                          from f_firmbalance h1
                         where h1.b_date =
                               (select nvl(max(b_date),
                                           to_date('2009-01-01', 'yyyy-MM-dd'))
                                  from f_firmbalance)) h,
                       (select d.firmid,
                               0 + nvl(b.c_balance, 0) - nvl(c.d_balance, 0) y_balance
                          from F_FirmFunds d,
                               (select a.firmid, sum(a.amount) c_balance
                                  from f_fundflow a
                                 where a.oprcode in
                                       (select t.summaryno
                                          from f_summary t
                                         where t.funddcflag = 'C')
                                 group by firmid) b,
                               (select a.firmid, sum(a.amount) d_balance
                                  from f_fundflow a
                                 where a.oprcode in
                                       (select t.summaryno
                                          from f_summary t
                                         where t.funddcflag = 'D')
                                 group by firmid) c
                         where d.firmid = b.firmid(+)
                           and d.firmid = c.firmid(+)) e
                 where f.firmid = h.firmid(+)
                   and f.firmid = e.firmid(+)) z)
;

prompt
prompt Creating view V_H_TRADE
prompt =======================
prompt
create or replace force view v_h_trade as
select CLEARDATE, A_TRADENO,A_ORDERNO,TRADETIME,CUSTOMERID,COMMODITYID,BS_FLAG,ORDERTYPE,PRICE,QUANTITY,CLOSE_PL,TRADEFEE,TRADETYPE,HOLDPRICE,HOLDTIME,FIRMID,CLOSEADDEDTAX,FIRMNAME,OPPCUSTOMERID
           from (select a.*, m.name FirmName, a.oppFirmId oppCustomerID
                   from T_H_TRADE a,
                        M_firm m
                  where m.firmID = a.firmID
                  order by a.firmID, a_orderno) Q;

prompt
prompt Creating view V_M_FIRM_CREATE_STAT
prompt ==================================
prompt
create or replace force view v_m_firm_create_stat as
select
       trunc(createtime) createdate,        --开户日期
       count(1) cnt                         --开户数量
  from m_firm group by trunc(createtime)
;

prompt
prompt Creating view V_M_FRONT_LOGON_STAT
prompt ==================================
prompt
create or replace force view v_m_front_logon_stat as
select operatrdate, ---登录日期
       sum(logsu) logsuccess, --登录成功数量
       sum(logcount) logcount, --交易商登录数量
       sum(logfail) logfail --登录失败数量
  from (select trunc(t.operatetime) operatrdate,
               count(*) logsu,
               0 logcount,
               0 logfail
          from c_globallog_all t
         where t.operatetype = '3201'
           and t.operateresult = 1
           and t.operatecontent like '%登录成功%'
         group by trunc(t.operatetime)
        union
        select trunc(t.operatetime) operatrdate,
               count(*) logsu,
               0 logcount,
               0 logfail
          from c_globallog_all_h t
         where t.operatetype = '3201'
           and t.operateresult = 1
           and t.operatecontent like '%登录成功%'
         group by trunc(t.operatetime)
        union
        select trunc(t.operatetime) operatrdate,
               0 logsu,
               count(distinct t.operator) logcount,
               0 logfail
          from c_globallog_all t
         where t.operatetype = '3201'
         group by trunc(t.operatetime)
        union
        select trunc(t.operatetime) operatrdate,
               0 logsu,
               count(distinct t.operator) logcount,
               0 logfail
          from c_globallog_all_h t
         where t.operatetype = '3201'
         group by trunc(t.operatetime)
        union
        select trunc(t.operatetime) operatrdate,
               0 logsu,
               0 logcount,
               count(*) logfail
          from c_globallog_all t
         where t.operatetype = '3201'
           and t.operateresult = 0
         group by trunc(t.operatetime)
        union
        select trunc(t.operatetime) operatrdate,
               0 logsu,
               0 logcount,
               count(*) logfail
          from c_globallog_all_h t
         where t.operatetype = '3201'
           and t.operateresult = 0
         group by trunc(t.operatetime))
 group by operatrdate
;

prompt
prompt Creating view V_STOCKLIST
prompt =========================
prompt
create or replace force view v_stocklist as
select t5."STOCKID",t5."BREEDID",t5.ownerfirm,t5."WAREHOUSEID",t5."QUANTITY",t5."UNIT",t5."LASTTIME",t5."CREATETIME",t5."STOCKSTATUS",
t5."LOGISTICSORDER",t5."COMPANY",t5."RECEIVED" ,t5."RECEIVEDDATE",t5.breedname,nvl(b11.stockid,0) as invoiceStatus from
(select t4."STOCKID",t4."BREEDID",t4.ownerfirm,t4."WAREHOUSEID",t4."QUANTITY",t4."UNIT",t4."LASTTIME",t4."CREATETIME",t4."STOCKSTATUS",
        t4."LOGISTICSORDER",t4."COMPANY",t4."RECEIVED" ,t4."RECEIVEDDATE",m.breedname  from
       (select distinct(t3.stockid),t3.breedid,t3.warehouseid,t3.quantity,t3.ownerfirm,t3.unit,t3.lasttime,t3.createtime,t3.stockstatus,t3.logisticsorder,t3.company,t44.received,t44.receiveddate
               from
                   (select t.stockid,t.breedid,t.ownerfirm,t.warehouseid,t.quantity,t.unit,t.lasttime,t.createtime,t.stockstatus,t2.logisticsorder,t2.company
                        from bi_stock t
                             left join bi_logistics t2 on t.stockid=t2.stockid where t.stockstatus=2 ) t3
                                  left join
                                  (select stockid,received,receiveddate,buyer from bi_businessrelationship
 where  selltime in (select selltime from ( select stockid,max(selltime) selltime from bi_businessrelationship group by stockid)))
                                   t44 on t3.stockid=t44.stockid and t3.ownerfirm=t44.buyer  ) t4
                                       left join m_breed m on t4.breedid=m.breedid) t5

                                       left join bi_invoiceinform b11 on t5.stockid=b11.stockid;

prompt
prompt Creating view V_T_FIRM_INFO
prompt ===========================
prompt
create or replace force view v_t_firm_info as
select firmid, firmName, status, customerCounts, tcounts, createTime
    from (select a.*,
                 cf.name firmName,
                 cf.createtime createtime,
                 b.counts customerCounts,
                 t.tcounts tcounts
            from T_firm a,
                 (select T_customer.firmid,
                         count(T_customer.customerid) counts
                    from T_customer
                   group by T_customer.firmid) b,
                 (select M_trader.firmid, count(M_trader.traderid) tcounts
                    from M_trader
                   group by M_trader.firmid) t,
                 M_firm cf
           where a.firmid = b.firmid(+)
             and a.firmid = t.firmid(+)
             and a.firmid = cf.firmid
           order by a.firmID);

prompt
prompt Creating view V_T_OVERDUEHOLDPOSITION
prompt =====================================
prompt
create or replace force view v_t_overdueholdposition as
select firmid,       -- 交易商代码
       customerid,   -- 交易客户代码
       commodityid,  -- 商品代码
       bs_flag,      -- 买卖方向，1：买，2：卖
       holdqty,      -- 持仓数量
       openqty,      -- 开仓数量
       gageqty,      -- 抵顶数量
       maycloseQty   -- 可转让数量
  from (select ag.*, (s.holdqty - s.FrozenQty) maycloseQty
          from (select a.firmid,
                       a.customerid,
                       a.commodityid,
                       a.bs_flag,
                       sum(a.holdqty) holdqty,
                       sum(a.openqty) openqty,
                       sum(a.gageqty) gageqty
                  from T_HoldPosition a
                 where 1 = 1
                   and remainday = 0
                   and a.deadline is not null
                 group by a.firmid, a.customerid, a.commodityid, a.bs_flag) ag,
               t_customerholdsum s
         where ag.commodityid = s.commodityid
           and ag.customerid = s.customerid
           and ag.bs_flag = s.bs_flag
           and ag.holdqty > 0
           )
;

prompt
prompt Creating view V_T_TRADE
prompt =======================
prompt
create or replace force view v_t_trade as
select A_TRADENO,A_ORDERNO,TRADETIME,CUSTOMERID,COMMODITYID,BS_FLAG,ORDERTYPE,PRICE,QUANTITY,CLOSE_PL,TRADEFEE,TRADETYPE,HOLDPRICE,HOLDTIME,FIRMID,CLOSEADDEDTAX,FIRMNAME,OPPCUSTOMERID
           from (select a.*, m.name FirmName, a.oppFirmId oppCustomerID
                   from T_Trade a,
                        M_firm m
                  where m.firmID = a.firmID
                  order by a.firmID, a_orderno) Q;

prompt
prompt Creating view V_W_ERRORLOGINLOG
prompt ===============================
prompt
create or replace force view v_w_errorloginlog as
select u.userid   as userid,
       u.name as name,
       logs.warehouseid as warehouseid,
       logs.counts     as counts,
       logs.loginDate  as logindate
  from (select t.userid, count(*) counts,warehouseid, trunc(loginDate) loginDate
          from w_errorloginlog t
         group by userid,warehouseid, trunc(loginDate)) logs,
       w_user u
 where u.userid = logs.userid;

prompt
prompt Creating package DATE_VIEW_PARAM
prompt ================================
prompt
create or replace package date_view_param is
  function set_start(startdate varchar2) return varchar2;
  function get_start return varchar2;
  function set_end(enddate varchar2) return varchar2;
  function get_end return varchar2;
end date_view_param;
/

prompt
prompt Creating package PKG_C_BASE
prompt ===========================
prompt
create or replace package PKG_C_Base is

    -- Author  : XUEJT
    -- Created : 2012/12/28 9:33:00
    -- Purpose : 公共包

    -- Public type declarations
    FIRM_STATUS_NORMAL constant m_firm.Status%type := 'N'; --正常 Normal
    FIRM_STATUS_DISABLE constant m_firm.Status%type := 'D'; --禁用 Disable
    FIRM_STATUS_ERASE constant m_firm.Status%type := 'E'; --删除 Erase


end PKG_C_Base;
/

prompt
prompt Creating function FN_M_MD5
prompt ==========================
prompt
CREATE OR REPLACE FUNCTION FN_M_MD5 (p_str IN VARCHAR2)
RETURN VARCHAR2
/****
 * MD5加密算法
 * 返回MD5加密后的字符串
 ****/
IS
  raw_input RAW (128):=UTL_RAW.cast_to_raw (p_str);
  decrypted_raw RAW (2048);
BEGIN
  DBMS_OBFUSCATION_TOOLKIT.md5 (input => raw_input,checksum => decrypted_raw);
  RETURN LOWER (RAWTOHEX (decrypted_raw));
END;
/

prompt
prompt Creating function FN_BI_FIRMADD
prompt ===============================
prompt
create or replace function FN_BI_firmADD
(
    p_FirmID m_firm.firmid%type --交易商代码
)
return integer is
  /**
  * 现货系统添加交易商
  * 返回值： 1 成功
  **/
  v_cnt                number(4); --数字变量
begin
  select count(*) into v_cnt from BI_firm where firmid = p_FirmID;
   if (v_cnt > 0) then
    --如果交易商已经存在则重新设置交易商信息
    update BI_firm set password=FN_M_MD5(p_FirmID||'111111'),createtime= sysdate  where firmid=p_FirmID;
  end if;

  insert into BI_firm
      (firmid, password, createtime)
  values
      (p_FirmID, FN_M_MD5(p_FirmID||'111111'), sysdate);

  return 1;
end;
/

prompt
prompt Creating function FN_BI_FIRMDEL
prompt ===============================
prompt
create or replace function FN_BI_FirmDel
(
    p_FirmID   m_firm.firmid%type--交易商代码
)
return integer is
  /**
  * 删除交易商
  * 返回值： 1 成功
  **/
  v_cnt                number(4); --数字变量
  RET_RESULT integer:=-130;--仓单数字变量
begin
    --查看仓单表中状态是否有0:未注册1:注册仓单4:拆弹中 有则不能注销仓单
    select count(*) into v_cnt from bi_stock s where s.ownerfirm=p_FirmID and s.stockstatus in(0,1,4);
    if(v_cnt>0)then
    return RET_RESULT;
    end if;
    return 1;
end;
/

prompt
prompt Creating function FN_BI_UNFROZENBILL
prompt ====================================
prompt
create or replace function FN_BI_UnfrozenBill
(
    p_moduleID   BI_FrozenStock.moduleid%type, --模块编号
	p_stockID    BI_FrozenStock.stockid%type --仓单编号
)
return integer is
  /**
  * 解冻交易商
  * 返回值： 1 成功、-2 已经解冻过了
  **/
  v_cnt number(4); --数字变量

  RET_RESULT integer:=-2;--仓单数字变量
begin
    --查看仓单表中状态是否有0:未注册1:注册仓单4:拆弹中 有则不能注销仓单
    select count(*) into v_cnt from BI_FrozenStock where moduleid=p_moduleID and stockID=p_stockID and status=0;
    if(v_cnt<=0)then
		return RET_RESULT;
    end if;
	--删除仓单业务
	delete from BI_StockOperation where stockID=p_stockID and operationID=4;
	--释放冻结仓单
	update BI_FrozenStock set status=1,releaseTime=sysdate where stockID=p_stockID;
	--返回成功
    return 1;
end;
/

prompt
prompt Creating function FN_BR_BROKEREVERYTRADEREWARD
prompt ==============================================
prompt
create or replace function FN_BR_BrokerEveryTradeReward(
    p_CommodityID    varchar2 ,--商品ID
    p_Quantity       number ,--数量
    p_FeeMoney       number ,--一笔成交收的手续费
    p_BarginMoney    number, --成交货款
    p_AtClearDate       date,--订货所属结算日期
    p_TradeAtClearDate  date,--成交所属结算日期
    p_BS_Flag        number,--买卖标志
    p_OrderType      number,--委托类型
    p_TradeType      number,--成交类型
    p_type           number--返回值类型  0 加收佣金  1  固定手续费
)return number
  /**
  * 计算每笔成交应返会员的加收佣金或会员分成的固定手续费
  * 2012-8-14 by jingwh
  **/
as
  v_brokerReward               number(15,2) default 0;
  v_feealgr                    number(1);
  v_feeRate_b                  number(15, 9);
  v_feeRate_s                  number(15, 9);
  v_todayclosefeerate_b        number(15, 9);
  v_todayclosefeerate_s        number(15, 9);
  v_historyclosefeerate_b      number(15, 9);
  v_historyclosefeerate_s      number(15, 9);
  v_forceclosefeerate_b        number(15, 9);
  v_forceclosefeerate_s        number(15, 9);
  v_rate                       number(15, 9);
  v_marketFee                  number(15,2);
  v_factmarketFee              number(15,2)  default 0;
begin
 --获取商品信息：手续费算法，。
    select t.feealgr,t.FeeRate_b,t.feerate_s,t.todayclosefeerate_b,t.todayclosefeerate_s,t.historyclosefeerate_b,t.historyclosefeerate_s,t.forceclosefeerate_b,t.forceclosefeerate_s
     into    v_feealgr,v_feeRate_b,v_feeRate_s,v_todayclosefeerate_b,v_todayclosefeerate_s,v_historyclosefeerate_b,v_historyclosefeerate_s,v_forceclosefeerate_b,v_forceclosefeerate_s from t_commodity t where t.commodityid=p_CommodityID;
    --比较订货时间和成交时间
    if(p_OrderType=1)then--开仓
          if(p_BS_Flag=1)then--买订立
                v_rate:=v_feeRate_b;
          elsif(p_BS_Flag=2)then--卖订立
                v_rate:=v_feeRate_s;
          end if;
    elsif(p_OrderType=2)then--平仓
       -- 判断是否强平  2013-12-18 by zhaodc
      if(p_TradeType=3)then
              if(p_BS_Flag=1)then--买转让
                  v_rate:=v_forceclosefeerate_b;
              elsif(p_BS_Flag=2)then--卖转让
                  v_rate:=v_forceclosefeerate_s;
              end if;
      else
          if(trunc(p_TradeAtClearDate)=trunc(p_AtClearDate))then--今开今平
              if(p_BS_Flag=1)then--买转让
                  v_rate:=v_todayclosefeerate_b;
              elsif(p_BS_Flag=2)then--卖转让
                  v_rate:=v_todayclosefeerate_s;
              end if;
          elsif(trunc(p_TradeAtClearDate)>trunc(p_AtClearDate))then  --平历史
              if(p_BS_Flag=1)then--买转让
                  v_rate:=v_historyclosefeerate_b;
              elsif(p_BS_Flag=2)then--卖转让
                  v_rate:=v_historyclosefeerate_s;
              end if;
          end if;
      end if;
    end if;
    --算返市场手续费
    if(v_feealgr=1)then
       v_marketFee:=v_rate*p_BarginMoney;
    elsif(v_feealgr=2)then
       v_marketFee:=v_rate*p_Quantity;
    end if;
    --算返会员的加收佣金 如果市场收上来的手续费（收）>市场应得手续费（固定）  加收佣金=收-固定 ；
    --如果市场收上来的手续费（收）<=市场应得手续费（固定）  手续费全部返给市场 加收佣金=0
    --计算会员分成用到的固定手续费  如果收>固定 会员分成=固定*比例 如果收<固定 会员分成=收*比例（例如收10  固定100  比例 30% 用固定算分成的话市场就会垫钱20  ）
    if(p_FeeMoney>v_marketFee)then
      v_brokerReward:=p_FeeMoney-v_marketFee;
      v_factmarketFee:=v_marketFee;
    elsif(p_FeeMoney<=v_marketFee)then
      v_brokerReward:=0;
      v_factmarketFee:=p_FeeMoney;
    end if;
    if(p_type=0)then
      return v_brokerReward;
    elsif(p_type=1)then
      return v_factmarketFee;
    end if;

end;
/

prompt
prompt Creating function FN_BR_BROKERPAYDATE
prompt =====================================
prompt
create or replace function FN_BR_BrokerPayDate(p_date date) return date is
/**
 * 计算付会员佣金尾款日期
 **/
  v_paydate    date;             --付会员佣金尾款日期
  v_dateString varchar2(32);
  v_payPeriod     number(1);     --付款周期
  v_payPeriodDate number(3);     --付款周期日
begin

  select PayPeriod,PayPeriodDate into v_payPeriod,v_payPeriodDate from BR_RewardParameterProps ;
  if(v_payPeriod=1)then  --按月计算
     v_dateString := to_char(ADD_MONTHS(trunc(p_date), 1), 'yyyy-MM');
  --dbms_output.put_line('--v_dateString:'||v_dateString);
     v_dateString := v_dateString || '-'||v_payPeriodDate;
     v_paydate    := to_date(v_dateString, 'yyyy-MM-dd');
  elsif(v_payPeriod=2)then --按周计算
    -- if(v_payPeriodDate>6 and v_payPeriodDate<1)then

    -- end if;
     select next_day(p_date,v_payPeriodDate) into v_paydate from dual;
     v_paydate    := trunc(v_paydate);
  end if;
  return v_paydate;
end;
/

prompt
prompt Creating function FN_F_UPDATEFUNDSFULL
prompt ======================================
prompt
create or replace function FN_F_UpdateFundsFull
(
  p_firmID varchar2,      --交易商代码
  p_oprcode char,         --业务代码
  p_amount number,        --发生额
  p_contractNo varchar2,  --成交合同号
  p_extraCode varchar2,   --中远期商品代码，银行为科目代码
  p_appendAmount number,  --中远期(增值税,担保金)
  p_voucherNo number      --凭证号(手工凭证使用)
) return number
/***
 * 更新资金
 * version 1.0.0.1 此方法公用
 *
 * 返回值：资金余额
 ****/
is
  v_fundsign number(1); -- 1 加项 -1 减项
  v_balance number(15,2);
  v_amount number(15,2):= p_amount;
begin
  begin
    select decode(funddcflag,'C',1,'D',-1,0) into v_fundsign from f_summary where summaryno=p_oprcode;
    if(v_fundsign=0) then
      Raise_application_error(-21003, 'Fund DCflag not defined in F_Summary!'); --未设置业务代码（摘要）资金借贷方向
    end if;
  exception when NO_DATA_FOUND then
    Raise_application_error(-21002, 'Undefined operation code(summaryNo)!'); --不存在的业务代码（摘要）
  end;

  update f_firmfunds set balance=balance + v_fundsign*v_amount where firmid=p_firmid
  returning balance into v_balance;
  if(SQL%ROWCOUNT = 0) then
    Raise_application_error(-21001, 'FirmID not existed !'); --不存在的交易商代码
  end if;

  --插入资金流水
  insert into f_fundflow
    (fundflowid, firmid, oprcode, contractno, commodityid, amount, balance,appendamount, voucherno, createtime)
  values
    (seq_f_fundflow.nextval, p_firmid, p_oprcode, p_contractno, p_extraCode, v_amount, v_balance,p_appendAmount,p_voucherNo, sysdate);

  return v_balance;
end;
/

prompt
prompt Creating function FN_F_UPDATEFUNDS
prompt ==================================
prompt
create or replace function FN_F_UpdateFunds
(
  p_firmID varchar2,     --交易商代码
  p_oprcode char,         --业务代码
  p_amount number,       --发生额
  p_contractNo varchar2  --成交合同号
) return number
/***
 * 更新资金
 * version 1.0.0.1 此方法公用
 *
 * 返回值：资金余额
 ****/
is
begin
  return fn_f_updatefundsFull(p_firmid,p_oprcode,p_amount,p_contractNo,null,null,null);
end;
/

prompt
prompt Creating function FN_BR_BROKERREWARD
prompt ====================================
prompt
create or replace function FN_BR_BrokerReward
  return number is
  /**
   * 付会员佣金
  **/
  v_ret           number(15, 2);
  v_payDate       date;
  v_autopay       char(1);
  v_oprcode       varchar2(10):='15019';
  v_firstPayMoney number(15, 2);
  v_brokerFirmID  varchar2(32);
  v_rtn           varchar2(10);
  v_moduleId      number(2):=15;
  v_tradeDate     date;

begin
      --查询结算日期
      select tradedate into v_tradeDate from t_systemstatus;
      --计算付款日
      v_payDate := FN_BR_BrokerPayDate(v_tradeDate);
      --查询是否自动付佣金 Y 是 N 否
      select autopay into v_autopay from BR_RewardParameterProps;
      --删除交易当日佣金明细数据支持重做结算
      delete from T_BR_FirmRewardDeail m where m.cleardate = trunc(v_tradeDate);
      --查当日历史成交记录生成佣金明细数据
      execute immediate 'BEGIN :1:=FN_BR_FirmRewardDeail(:2); END;' using out v_rtn,v_tradeDate;
      --如果是手动付佣金，将当日佣金明细首款置为0，尾款为总佣金
      if(v_autopay = 'N') then
            update T_BR_Firmrewarddeail m set m.firstpay = 0,m.secondpay = m.reward  where m.cleardate = trunc(v_tradeDate);
      end if;

     /**
     For循环是把BR_Brokerreward的会员ID和已付佣金查询出来。
     **/
     for brokerReward in (select t.brokerid,t.paidamount from BR_brokerReward t where t.Occurdate = trunc(v_tradeDate) and t.moduleid=v_moduleId) loop
        --查询出会员交易商ID
        select firmid into v_brokerFirmID from BR_broker where brokerid = brokerReward.brokerid;

        v_firstPayMoney := -brokerReward.paidamount;

        --写流水将付给会员的佣金再收上来
        v_ret:= fn_f_updatefunds(v_brokerFirmID,v_oprcode,v_firstPayMoney,null);
     end loop;

     --删除当日待付佣金记录支持重做结算
     delete from BR_Brokerreward t where t.Occurdate = trunc(v_tradeDate) and moduleid = v_moduleId;

     --根据会员ID汇总当日佣金明细佣金首款和尾款
     for broker in (select t.brokerid,sum(t.firstpay) firstpay,sum(t.secondpay) secondpay from T_BR_firmrewarddeail t
                  where t.cleardate = trunc(v_tradeDate) group by t.brokerid) loop
        --插入待付佣金
        insert into BR_BrokerReward (BrokerID, moduleid, Occurdate, Amount, Paydate, Paidamount)
               values (broker.brokerid,v_moduleId,trunc(v_tradeDate),broker.secondpay,trunc(v_paydate),broker.firstpay);
        --查询出会员交易商ID
        select firmid into v_brokerFirmID from BR_broker where brokerid = broker.brokerid;
        --写流水付会员佣金首款
        v_ret := fn_f_updatefunds(v_brokerFirmID,v_oprcode,broker.firstpay,null);
    end loop;
    --如果是自动付佣金，便将付款日<=当日且待付>0的佣金付给会员；更新会员待付佣金表
    if (v_autopay = 'Y') then
        for brokerReward in (select t.brokerid, t.amount, t.occurdate from BR_Brokerreward t where t.paydate <= trunc(v_tradeDate) and t.amount > 0 and t.moduleid=v_moduleId ) loop
            select firmid into v_brokerFirmID from BR_broker where brokerid = brokerReward.brokerid;
            v_ret := fn_f_updatefunds(v_brokerFirmID,v_oprcode,brokerReward.Amount,null);
            update BR_Brokerreward m set m.amount= 0,m.paidamount = m.paidamount + brokerReward.Amount
                where m.brokerid = brokerReward.Brokerid and m.occurdate = brokerReward.Occurdate and m.moduleid=v_moduleId;
        end loop;
   end if;

return 1;
end;
/

prompt
prompt Creating function FN_BR_FIRMADD
prompt ===============================
prompt
create or replace function FN_BR_FIRMADD(p_firmId m_firm.firmid%type)
  return number is
  /**
  * 审核交易商时调用此存储；交易商和会员，居间商绑定关系
  * 返回值： 1 成功
  **/

  v_brokerAgeId      varchar2(64);
  v_brokerId         varchar2(32);
  v_count            number(3);
  v_applyId          number(10);

begin

     select applyId into v_applyId from m_firm where firmId=p_firmId;
     --该交易商有申请ID且在会员的交易商注册表中有记录继续，否则返回成功
     if(v_applyId is not null)then
        select count(*) into v_count from br_firmapply a where a.applyid=v_applyId;
        if(v_count>0)then
             --查询交易商申请表中记录的所属居间商和会员
             select fa.brokerageid,fa.brokerid into v_brokerAgeId,v_brokerId from br_firmapply fa where fa.applyid=v_applyId;
             --交易商和会员建立关系
             insert into br_firmandbroker (firmId,brokerid,bindtime) values (p_firmId,v_brokerId,sysdate);
             --交易商和居间商建立关系
             if(v_brokerAgeId is not null)then
                insert into br_brokerageandfirm (brokerageid,firmid,bindtype,bindtime) values (v_brokerAgeId,p_firmId,0,sysdate);
             end if;
             return 1;
         end if;
     end if;
return 1;
end;
/

prompt
prompt Creating function FN_BR_FIRMREWARDDEAIL
prompt =======================================
prompt
create or replace function FN_BR_FirmRewardDeail(p_tradeDate Date)
  return number is
  /**
  * 从历史成交中生成佣金明细
  **/
  v_firstpayrate  number(6, 4);--提成首付比例
  v_secondpayrate number(6, 4);--提成尾款比例
  v_rewardrate    number(6, 4);--手续费佣金比例
  v_firstPay      number(15, 2);--提成首付金额
  v_secondPay     number(15, 2);--提成尾款金额
  v_reward        number(15, 2);--会员实得手续费：会员加收部分手续费+交易手续费中会员所得分成
  v_feestandard   number(15, 2);--商品固定手续费
  v_rewardRemainder number(15, 2);--会员加收部分手续费
  v_brokerEachDivide number(15, 2);--交易手续费中会员所得分成
  v_marketReward  number(15, 2);--市场所得
  v_brokerAgeId   varchar2(32);--交易商直属居间商代码
  v_brokerAgeName varchar2(64);--交易商直属居间商名称
  v_cnt            number(2);
begin

 --从中远期获得按交易商按商品分组后的信息
  --主要包括交易商代码、授权商代码、商品代码、该商品对应的所有交易手续费、交易总数量、交易金额
  for firmRewardDeail in (select a.firmId,
                                 brokerid,
                                 brokername,
                                 commodityId,
                                 feeMoney,
                                 quantity,
                                 barginMoney,
                                 feestandard,
                                 brokerReward
                            from (select t.firmid,
                                         sum(t.tradefee) feeMoney,
                                         sum(t.quantity) quantity,
                                         sum(t.price*t.quantity*c.contractfactor) barginMoney,
                                         sum(FN_BR_BrokerEveryTradeReward(t.commodityid,t.quantity,t.tradefee,t.price*t.quantity*c.contractfactor,t.atcleardate, t.tradeatcleardate,t.bs_flag,t.ordertype, t.tradetype, 0)) brokerReward,
                                         sum(FN_BR_BrokerEveryTradeReward(t.commodityid,t.quantity,t.tradefee,t.price*t.quantity*c.contractfactor,t.atcleardate, t.tradeatcleardate,t.bs_flag,t.ordertype, t.tradetype, 1)) feestandard,
                                         c.commodityId
                                    from t_h_trade t,t_h_commodity c,BR_FirmAndBroker m
                                    where t.commodityid=c.commodityid and t.cleardate=c.cleardate
                                    and  t.cleardate = trunc(p_tradeDate) and t.tradefee<>0 and  m.firmid=t.firmid
                                   group by t.firmid, c.commodityId,t.cleardate,m.brokerid) a,
                                 (select m.firmid, m.brokerid,mb.name brokername
                                    from BR_firmandbroker m, BR_Broker mb
                                   where m.brokerid = mb.brokerid
                                     and mb.firmid is not null) b
                           where a.firmId = b.firmId order by b.brokerid, a.firmId) loop


    --从会员佣金设置表获得手续费佣金比例、提成首付比例、提成尾款比例
      select rewardrate, firstpayrate, secondpayrate
      into v_rewardrate, v_firstpayrate, v_secondpayrate
      from (select t.rewardrate,
                   t.firstpayrate,
                   t.secondpayrate
              from BR_brokerrewardprops t
             where (t.commodityId = firmRewardDeail.commodityId or t.commodityId = '-1')
               and (t.brokerid = firmRewardDeail.brokerid or t.brokerid = '-1')
               and(t.moduleid = '15' or t.moduleid = '-1')
               and(t.rewardType=0 or t.rewardType=-1 )
             order by t.brokerid desc, t.commodityId desc, t.moduleid ,t.rewardType desc)
     where rownum = 1;

    --市场固定手续费
    v_feestandard:=firmRewardDeail.feestandard;
    --会员加收部分手续费
    v_rewardRemainder:=firmRewardDeail.brokerReward;
    --交易手续费中会员所得分成
    v_brokerEachDivide:=v_feestandard*v_rewardrate;
    --市场所得
    v_marketReward:= v_feestandard-v_brokerEachDivide;
    --会员实得手续费
    v_reward:=v_rewardRemainder+v_feestandard*v_rewardrate;

    --提成首付金额
    v_firstPay:=v_reward*v_firstpayrate;
    --提成尾款比例
    v_secondPay := v_reward-v_firstPay;

    --查询交易商直属居间商代码和名称
     select count(*) into v_cnt from  br_brokerageandfirm f,br_brokerage b where f.brokerageid=b.brokerageid and f.firmid=firmRewardDeail.firmId and f.bindtype=0;
     if(v_cnt>0)then
            select f.brokerageid,b.name into v_brokerAgeId,v_brokerAgeName from br_brokerageandfirm f,br_brokerage b where f.brokerageid=b.brokerageid and f.firmid=firmRewardDeail.firmId and f.bindtype=0;
     end if;
    --保存数据
    insert into T_BR_FirmRewardDeail m
      (firmId,
       commodityId,
       cleardate,
       rewardtype,
       brokerId,
       brokerName,
       firstPay,
       secondPay,
       reward,
       marketReward,
       brokerEachDivide,
       quantity,
       tradeMoney,
       brokerAgeID,
       brokerAgeName)
    values
      (firmRewardDeail.firmId,
       firmRewardDeail.commodityId,
       trunc(p_tradeDate),
       0,
       firmRewardDeail.brokerId,
        firmRewardDeail.brokername,
       v_firstPay,
       v_secondPay,
       v_reward,
       v_marketReward,
       v_brokerEachDivide,
       firmRewardDeail.quantity,
       firmRewardDeail.barginMoney,
       v_brokerAgeId,
       v_brokerAgeName);
  end loop;
  return 1;
end;
/

prompt
prompt Creating function FN_F_AUDITVOUCHERPASS
prompt =======================================
prompt
create or replace function FN_F_AuditVoucherPass(p_voucherNo number)
return number
/***
 * 审核凭证通过
 *
 * version 1.0.0.3
 *
 * 返回 1 成功 -1 未找到该笔待审核凭证
 ***/
as
  v_cnt number(10);

  v_contractno varchar2(16);
  v_summaryNo f_summary.summaryno%type;
  v_fundDCflag char(1);

  v_firmID varchar2(32);

  v_accountcode varchar2(38);
  v_debitamount number(15,2);
  v_creditamount number(15,2);

  v_amount number(15,2); --发生额
  v_balance number(15,2); --余额

  v_negCount number;

  cursor c_entry is
    select accountcode, debitamount, creditamount from f_voucherentry where voucherno=p_voucherNo and accountcode like '200100%';

begin
  begin
    select contractno,summaryno into v_contractno,v_summaryNo from f_voucher where voucherNo=p_voucherNo and status='auditing' for update;
  exception when NO_DATA_FOUND then
    return -1;
  end;
  select count(*) into v_cnt from f_voucherentry where voucherno=p_voucherNo and accountcode like '200100%';
  if(v_cnt>0) then
    select fundDCflag into v_fundDCflag from f_summary where summaryno=v_summaryNo;
    if(v_fundDCflag<>'D' and v_fundDCflag<>'C') then  --与交易商资金无关凭证
      Raise_application_error(-21003, 'Fund DCflag not defined in F_Summary!'); --未设置业务代码（摘要）资金借贷方向
    else  --有交易商资金变动
      open c_entry;
      loop
        fetch c_entry into v_accountcode,v_debitamount,v_creditamount;
        exit when c_entry%NOTFOUND;
        v_firmid:=substr(v_accountcode,7);

        if(v_fundDCflag='C') then
          v_amount:=v_creditamount-v_debitamount;
        else
          v_amount:=v_debitamount-v_creditamount;
        end if;

        v_balance:=fn_f_updatefundsFull(v_firmid,v_summaryNo,v_amount,v_contractno,null,null,p_voucherNo);

        select count(*) into v_negCount
        from f_firmfunds a,
            (
              select substr(accountCode,7) firmid,sum(creditAmount)-sum(debitAmount) amount
              from f_voucherentry
              where voucherNo=p_voucherNo and accountCode like '2001%' group by accountCode
            ) b
        where  a.firmid = b.firmid and (a.balance - a.frozenfunds)<0 and b.amount<0;
        if(v_negCount>0) then
            rollback;
            return -2;            --造成负值
        end if;
      end loop;
    end if;
  end if;

  --更新凭证状态为已审核
  update f_voucher set status = 'audited',audittime=sysdate where voucherNo = p_voucherNo;

  return 1;
end;
/

prompt
prompt Creating function FN_F_CREATEVOUCHER
prompt ====================================
prompt
create or replace function FN_F_CreateVoucher(
  p_summaryNo varchar2,
  p_summary varchar2,
  p_debitCode varchar2,
  p_creditCode varchar2,
  p_amount number,
  p_contractno varchar2,
  p_inputUser varchar2
) return number  --凭证号
/**
 * 创建凭证，凭证为编辑状态
 * version 1.0.0.3
 *
 **/
as
  v_level number;
  v_cnt number;
   v_voucherno number;
   v_summary varchar2(32);
begin
  --判断科目是否合法
  select accountlevel into v_level from f_account where code=p_debitCode;

  select count(*) into v_cnt from f_account where code like p_debitCode||'%' and accountlevel>v_level;
  if(v_cnt>0) then
   Raise_application_error(-21004, 'Fund accountcode not a leaf node!'||p_debitCode); --对方科目非叶子科目
  end if;

  select accountlevel into v_level from f_account where code=p_creditCode;

  select count(*) into v_cnt from f_account where code like p_creditCode||'%' and accountlevel>v_level;
  if(v_cnt>0) then
   Raise_application_error(-21004, 'Fund accountcode not a leaf node!'||p_creditCode); --对方科目非叶子科目
  end if;

  --如果没有指定摘要内容，查询出来。
  if(p_summary is null) then
    select summary into v_summary from F_Summary where summaryno=p_summaryNo;
  end if;
  select seq_f_voucher.nextval into v_voucherno from dual;

  --插入凭证
  insert into f_voucher
   (voucherno, summaryno, summary, inputuser, inputtime, status, contractno)
  values
   (v_voucherno, p_summaryNo, p_summary, p_inputUser, sysdate, 'editing', p_contractno);

  insert into f_voucherentry
   (entryid, voucherno, accountcode, debitamount, creditamount)
  values
   (seq_f_voucherentry.nextval, v_voucherno, p_debitCode, p_amount, 0);
  insert into f_voucherentry
   (entryid, voucherno, accountcode, debitamount, creditamount)
  values
   (seq_f_voucherentry.nextval, v_voucherno, p_creditCode, 0, p_amount);

  return v_voucherno;
end;
/

prompt
prompt Creating function FN_F_CREATEVOUCHERCOMP
prompt ========================================
prompt
create or replace function FN_F_CreateVoucherComp(
  p_summaryNo varchar2,
  p_summary varchar2,
  p_debitCode varchar2,
  p_creditCode varchar2,
  p_amount number,
  p_contractno varchar2,
  p_fundflowid number,
  p_createtime date,
  p_b_date date
) return number  --凭证号
/**
 * 创建电脑凭证，凭证为已审核状态
 * version 1.0.0.1
 *
 **/
as
  v_voucherno number;
  v_summary varchar2(32);
begin
  v_summary:=p_summary;
  if(v_summary is null) then
    select summary into v_summary from f_summary where summaryno=p_summaryNo;
  end if;
  v_voucherNo:=fn_f_createvoucher(p_summaryNo,v_summary,p_debitCode,p_creditCode,p_amount,p_contractno,'system');
  update F_Voucher
  set inputtime=p_createtime,auditor='system',audittime=p_createtime,status='audited',fundflowid=p_fundflowid,b_date=p_b_date
  where voucherno=v_voucherNo;

  return v_voucherno;
end;
/

prompt
prompt Creating function FN_F_EXTRACTVOUCHER
prompt =====================================
prompt
create or replace function FN_F_ExtractVoucher
return number
as
/***
 * 抽取电脑凭证
 * version 1.0.0.1
 *
 * 返回生成凭证数
 ****/
  v_voucherNo number(10);
  v_b_date date;

  v_fundflowid number(10);
  v_firmId varchar2(32);
  v_oprcode F_FundFlow.Oprcode%type;
  v_contractNo varchar2(16);
  v_commodityID varchar2(16);
  v_amount number(15,2);
  v_appendAmount number(15,2);
  v_createtime date;

  v_fundDCflag char(1);
  v_summary varchar2(32);
  v_accountcodeopp varchar2(38);
  v_appendAccount char(1);

  v_debitCode varchar2(38);
  v_creditCode varchar2(38);

  v_cnt number(10):=0;

  cursor c_FundFlow is
      select fundflowid, firmid, oprcode,contractNo,commodityID, amount, appendamount, createtime, b_date
      from f_fundflow
      where voucherno is null
      order by fundflowid;

begin
  delete from f_fundflow where amount=0 and appendamount=0;
  --通过交易资金流水和成交合同生成凭证
  open c_FundFlow;
  loop
     fetch c_FundFlow into v_fundflowid,v_firmId,v_oprcode,v_contractNo,v_commodityID,v_amount,v_appendAmount,v_createtime,v_b_date;
     exit when c_FundFlow%NOTFOUND;
     --将商品科目对应
     select funddcflag, replace(accountcodeopp,'*',v_commodityID),summary,appendAccount
     into v_funddcflag, v_accountcodeopp,v_summary,v_appendAccount
     from f_summary
     where summaryno = v_oprcode;

   --新增，用于诚信保证金 2012-5-10
   v_accountcodeopp := replace(v_accountcodeopp, '#', v_firmId);

     if(v_accountcodeopp = 'spec') then
       v_accountcodeopp := v_commodityID;
     end if;

     if(v_funddcflag='D') then
         v_debitCode:='200100'||v_firmId;
         v_creditCode:=v_accountcodeopp;
     elsif(v_funddcflag='C') then
         v_debitCode:=v_accountcodeopp;
         v_creditCode:='200100'||v_firmId;
     end if;

     if(v_contractNo is not null) then --合同号跟交易系统号
       v_contractno:=substr(v_oprcode,1,1)||'-'||v_contractNo;
     end if;

     v_voucherNo:=fn_f_createvoucherComp(v_oprcode,v_summary,v_debitCode,v_creditCode,v_amount,v_contractno,v_fundflowid,v_createtime,v_b_date);
     v_cnt:=v_cnt + 1;

     update F_FundFlow set voucherno=v_voucherNo where fundflowid=v_fundflowid;

     if(v_appendAmount is not null and v_appendAmount!=0 and v_appendAccount!='N') then --有附加账目
         v_fundflowid:=null;
         if(v_appendAccount='T') then
           if(v_funddcflag='D') then  --亏损，一部分来自返回增值税
             v_oprcode:='15098';
             v_debitCode:='1005' || substr(v_oprcode,0,2) || v_commodityID;
             v_creditCode:=v_accountcodeopp;
           elsif(v_funddcflag='C') then --盈利，一部分给增值税
             v_oprcode:='15099';
             v_debitCode:=v_accountcodeopp;
             v_creditCode:='1005' || substr(v_oprcode,0,2) || v_commodityID;
           end if;
           v_voucherNo:=fn_f_createvoucherComp(v_oprcode,null,v_debitCode,v_creditCode,v_appendAmount,v_contractno,v_fundflowid,v_createtime,v_b_date);
           v_cnt:=v_cnt + 1;
         elsif(v_appendAccount='W') then --担保金
           if(v_funddcflag='D') then --收保证金，加担保金
             v_oprcode:='15097';  --入担保金
             v_debitCode:='1006';
             v_creditCode:='200101'||v_firmId;
             v_voucherNo:=fn_f_createvoucherComp(v_oprcode,null,v_debitCode,v_creditCode,v_appendAmount,v_contractno,v_fundflowid,v_createtime,v_b_date);
             v_cnt:=v_cnt + 1;

             v_oprcode:='15095';  --收交易商担保金
             v_debitCode:='200101'||v_firmId;
             v_creditCode:='2099'|| substr(v_oprcode,0,2) ||v_commodityID;
             v_voucherNo:=fn_f_createvoucherComp(v_oprcode,null,v_debitCode,v_creditCode,v_appendAmount,v_contractno,v_fundflowid,v_createtime,v_b_date);
             v_cnt:=v_cnt + 1;
           elsif(v_funddcflag='C') then --退保证金
             v_oprcode:='15094';  --退交易商担保金
             v_debitCode:='2099'|| substr(v_oprcode,0,2) ||v_commodityID;
             v_creditCode:='200101'||v_firmId;
             v_voucherNo:=fn_f_createvoucherComp(v_oprcode,null,v_debitCode,v_creditCode,v_appendAmount,v_contractno,v_fundflowid,v_createtime,v_b_date);
             v_cnt:=v_cnt + 1;

             v_oprcode:='15096';  --出担保金
             v_debitCode:='200101'||v_firmId;
             v_creditCode:='1006';
             v_voucherNo:=fn_f_createvoucherComp(v_oprcode,v_summary,v_debitCode,v_creditCode,v_appendAmount,v_contractno,v_fundflowid,v_createtime,v_b_date);
             v_cnt:=v_cnt + 1;
           end if;
         end if;
     end if;
  end loop;
  close c_FundFlow;

  return v_cnt;
end;
/

prompt
prompt Creating procedure SP_F_BALANCEACCOUNT
prompt ======================================
prompt
create or replace procedure SP_F_BalanceAccount(p_beginDate date) as
     v_lastDate date;
     v_curDate date;

     v_lvl number(2);
     v_cnt number(10);
begin
     --清除开始日期以后的结算
     delete from F_DailyBalance where b_Date >= p_beginDate;
     delete from F_FirmBalance where b_Date >= p_beginDate;
     --取得上日日期
     select max(b_Date) into v_lastDate from F_DailyBalance;
     if(v_lastDate is null) then
          v_lastDate := to_date('2000-01-01','yyyy-MM-dd');
     end if;

     for curDate in (select distinct b_date from f_Accountbook where b_date > v_lastDate order by b_date)
     loop
         v_curDate:=curDate.b_Date;

         --对所有科目初始化当日结算记录
         insert into F_DailyBalance(b_date,accountcode,lastdaybalance,debitamount,creditamount,todaybalance)
         select v_curDate,a.Code,nvl(b.todaybalance,0),0,0,nvl(b.todaybalance,0)
         from f_account a,(select * from F_DailyBalance where b_date = v_lastDate) b
         where a.Code = b.accountCode(+) and a.code not like '%\_' escape '\';

         --更新叶子节点当日借贷方发生额
         for debit in (select debitCode,sum(amount) amount from f_accountBook where b_date = v_curDate group by debitCode)
         loop
             update F_DailyBalance set DebitAmount=debit.amount where b_date = v_curDate and accountCode = debit.debitcode;
         end loop;
         for credit in (select creditCode,sum(amount) amount from f_accountBook where b_date = v_curDate group by creditCode)
         loop
             update F_DailyBalance set creditAmount=credit.amount where b_date = v_curDate and accountCode = credit.creditCode;
         end loop;

         select max(accountlevel) into v_lvl from F_Account;
         --更新当日借方、贷方发生额
         for account in (select code,accountlevel,dcFlag from f_account where accountlevel<v_lvl order by accountlevel desc)
         loop
             select count(1) into v_cnt from f_account
             where code like account.code||'%' and accountlevel=account.accountlevel+1;
             if(v_cnt>0) then
                 update F_DailyBalance a
                 set (DebitAmount,CreditAmount)=
                 (
                    select nvl(sum(DebitAmount),0),nvl(sum(CreditAmount),0)
                    from F_DailyBalance fd,f_account fa
                    where fd.b_date=v_curDate and fd.accountcode=fa.code and fd.accountcode like account.code||'%'
                      and fa.accountlevel=account.accountlevel+1
                 ) where accountcode=account.code and a.b_date=v_curDate;
             end if;
         end loop;

         --更新当日结算余额
         update (select a.*,b.dcflag from F_DailyBalance a,F_Account b
                 where b_date = v_curDate and a.accountCode=b.code) c
         set TodayBalance=c.LastdayBalance+(case dcflag when 'D' then DebitAmount-CreditAmount else CreditAmount-DebitAmount end);


         --------------------------------更新交易商结算表及担保金
         insert into F_FirmBalance
            (b_date, firmid, lastbalance, todaybalance, lastwarranty, todaywarranty)
         select b_date, substr(accountcode,7) firmid, lastdaybalance, todaybalance, 0, 0
         from f_dailybalance
         where b_Date=v_curDate
         and accountCode like '200100%' and substr(accountCode,7) is not null;

         --更新上日担保金
         update F_FirmBalance f
         set lastwarranty=nvl((select todaywarranty from F_FirmBalance where b_date=v_lastDate and firmid=f.firmid),0)
         where b_Date=v_curDate;

         --更新当日担保金
         update F_FirmBalance f set todaywarranty=lastwarranty where b_Date=v_curDate;
         for wfirm in (select distinct debitcode firmCode from f_accountbook
                       where b_Date=v_curDate and summaryno in ('15097','15096') and debitcode like '200101%'
                 union select distinct creditcode firmCode from f_accountbook
                       where b_Date=v_curDate and summaryno in ('15097','15096') and creditcode like '200101%')
         loop
             update F_FirmBalance f set todaywarranty=todaywarranty+
               nvl(
                 (
                   select sum(decode(summaryno,'15097',amount,-amount)) inAmount
                   from f_accountbook
                   where b_Date=v_curDate and (debitcode=wfirm.firmcode or creditcode=wfirm.firmcode) and summaryno in ('15097','15096')
                 )
               ,0)
             where b_Date=v_curDate and firmid=substr(wfirm.firmcode,7);
         end loop;

         --更新交易商资金表
         update F_Firmfunds f set (lastbalance,lastwarranty)=
           (select nvl(todaybalance,0),nvl(todaywarranty,0) from F_FirmBalance b where b_Date=v_curDate and b.firmid=f.firmid);
         --------------------------------end warranty
         --更新上日日期
         v_lastDate := v_curDate;
     end loop;

end;
/

prompt
prompt Creating procedure SP_F_CLEARACTION_DONE
prompt ========================================
prompt
create or replace procedure SP_F_ClearAction_Done
(
    p_ActionID   F_ClearStatus.ActionID%type
)
is
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
    update F_ClearStatus
       set status = 'Y',
           FinishTime = sysdate
     where ActionID = p_ActionID;
    commit;
end;
/

prompt
prompt Creating procedure SP_F_CLIENTLEDGER
prompt ====================================
prompt
create or replace procedure SP_F_ClientLedger(p_beginDate date) as
begin
    --清除开始日期以后的结算
    delete from F_ClientLedger where b_Date >= p_beginDate;

    insert into f_clientledger
      (b_date, firmid, code, value)
    select b_date,substr(accountcode,7),ledgeritem,d.fieldsign*amount from
    (
      select b_date,accountcode,ledgeritem,sum(amount) amount from
      (
        select b_date,debitcode accountcode,ledgeritem, -amount amount
        from f_accountbook a,f_summary b
        where a.summaryno=b.summaryno and a.b_date>=p_beginDate and a.debitcode like '200100%'
        union all
        select b_date,creditcode accountcode,ledgeritem, amount
        from f_accountbook a,f_summary b
        where a.summaryno=b.summaryno and a.b_date>=p_beginDate and a.creditcode like '200100%'
      ) group by b_date,accountcode,ledgeritem
    ) c,f_ledgerfield d
    where c.ledgeritem=d.code;

end;
/

prompt
prompt Creating procedure SP_F_COMPUTEFIRMRIGHTS
prompt =========================================
prompt
create or replace procedure SP_F_ComputeFirmRights(
  p_beginDate date
)
/****
 * 计算交易商权益
****/
as
	v_lastDate     date;           -- 上一个结算日
  v_cnt          number(4);      --数字变量
  v_sumFirmFee   number(15, 2);  -- 交易商手续费合计
  v_sumFL        number(15, 2);  -- 交易商订货盈亏合计
  v_sumBalance   number(15, 2);  -- 交易商权益计算费用合计
begin

   -- 更新银行清算权益计算费用

        -- 删除银行清算权益计算费用表的当日数据
        delete from F_FirmRightsComputeFunds where b_date = p_beginDate;

        -- 取得银行清算权益计算费用表的上一个结算日
        select max(b_Date) into v_lastDate from F_FirmRightsComputeFunds;

        if(v_lastDate is null) then
          v_lastDate := to_date('2000-01-01','yyyy-MM-dd');
        end if;

       -- 将交易商当前资金表的交易商和银行清算总账费用配置表中费用类型是权益计算费用的总账代码链表
       -- 插入银行清算权益计算费用表作为当日的初始数据
       insert into F_FirmRightsComputeFunds(B_date, Firmid, Code)
         select p_beginDate,f.firmid, bc.ledgercode
         from f_firmfunds f,F_BankClearLedgerConfig bc
         where bc.feetype = 1;

        for firmRights in (select b_date, firmId, code from F_FirmRightsComputeFunds where b_date = p_beginDate)
        loop
            -- 更新银行清算权益计算费用表的上日余额
            update F_FirmRightsComputeFunds f
            set lastBalance = nvl((select balance
                 from F_FirmRightsComputeFunds where b_date = v_lastDate and firmId = firmRights.firmId and code = firmRights.code ), 0)
            where b_date = firmRights.b_date and firmId = firmRights.firmId and code = firmRights.code;

            -- 更新银行清算权益计算费用表的当日余额
            update F_FirmRightsComputeFunds f
            set balance = nvl((select bc.fieldsign*c.value as amount
                               from f_clientledger c, f_bankclearledgerconfig bc
                               where c.b_date = firmRights.b_date and c.firmId = firmRights.firmId and c.code = firmRights.code and c.code = bc.ledgercode ), 0)
            where b_date = firmRights.b_date and firmId = firmRights.firmId and code = firmRights.code;

            -- 更新银行清算权益计算费用表的当日余额为：当日余额 + 上日余额
            --（这样就可以不用到交易系统中去取这些资金项）
            update F_FirmRightsComputeFunds f
            set balance = balance + lastBalance
            where b_date = firmRights.b_date and firmId = firmRights.firmId and code = firmRights.code;

        end loop;


   -- 更新交易商清算资金

     -- 删除交易商清算资金表的当日数据
     delete from F_FirmClearFunds where b_date = p_beginDate;

     -- 将交易商当前资金表的余额插入交易商清算资金表
     insert into F_FirmClearFunds(B_date, Firmid, Balance)
     select p_beginDate, f.firmid, f.balance from f_firmfunds f;

     for firmClearFunds in (select b_date, firmId from F_FirmClearFunds where b_date = p_beginDate)
     loop
         -- 计算交易商手续费
         select nvl(sum(value), 0) sumFirmFee into v_sumFirmFee
         from F_ClientLedger c
         where b_date = firmClearFunds.b_date and firmId = firmClearFunds.firmId
         and c.code in (select LedgerCode from F_BankClearLedgerConfig where FeeType = 0);

           -- 更新交易商清算资金表的交易商手续费
           update F_FirmClearFunds
           set firmFee = v_sumFirmFee
           where b_date = firmClearFunds.b_date and firmId = firmClearFunds.firmId;

         -- 计算市场手续费

         -- 计算交易商权益冻结资金

            -- 统计银行清算权益计算费用的当日余额
            select nvl(sum(Balance), 0) sumBalance into v_sumBalance from F_FirmRightsComputeFunds where b_date = firmClearFunds.b_date and firmId = firmClearFunds.firmId;

            -- 判断是否启用订单系统
            select count(*) into v_cnt from c_trademodule where moduleId = 15 and isbalancecheck = 'Y';
            if(v_cnt > 0) then

               -- 统计订单持仓盈亏
               select nvl(sum(FloatingLoss), 0) sumFL into v_sumFL from T_H_FirmHoldSum t where t.cleardate = firmClearFunds.b_date and t.firmid = firmClearFunds.firmId;

               update F_FirmClearFunds
               set RightsFrozenFunds = v_sumBalance + v_sumFL
               where b_date = firmClearFunds.b_date and firmId = firmClearFunds.firmId;

            else
               update F_FirmClearFunds
               set RightsFrozenFunds = v_sumBalance
               where b_date = firmClearFunds.b_date and firmId = firmClearFunds.firmId;

            end if;

         -- 计算交易商权益
         update F_FirmClearFunds
         set Rights = Balance + RightsFrozenFunds
         where b_date = firmClearFunds.b_date and firmId = firmClearFunds.firmId;

     end loop;

end;
/

prompt
prompt Creating procedure SP_F_PUTVOUCHERTOBOOK
prompt ========================================
prompt
create or replace procedure SP_F_PutVoucherToBook(p_beginDate date) as
begin
     --清除开始日期以后的帐簿
     delete from f_accountbook where b_Date>=p_beginDate;
     --将凭证记入会计账簿
     insert into f_accountbook
     (b_date,summaryno,summary,voucherno,debitcode,creditcode,amount,contractno)
      select a.b_date,a.summaryNo,a.summary,a.voucherno,a.accountcode,b.accountcode,
          case
            when (m.debitcount=n.creditcount) then a.debitamount
            when (m.debitcount<n.creditcount) then b.creditamount
            else a.debitamount
          end amount,a.contractno
      from (  select v.b_date,v.summaryNo,v.summary,v.voucherno,v.contractno,v.audittime,ve.accountcode,ve.debitamount
              from f_voucher v,f_voucherentry ve
              where v.b_date>=p_beginDate and v.voucherno=ve.voucherNo and ve.debitamount<>0
            ) a,
           (  select v.voucherno,ve.accountcode,ve.creditamount
              from f_voucher v,f_voucherentry ve
              where v.b_date>=p_beginDate and v.voucherno=ve.voucherNo and ve.creditamount<>0
            ) b,
           (  select ve.voucherno,count(1) debitcount
              from f_voucherentry ve,f_voucher v
              where ve.voucherno=v.voucherno
                and v.b_date>=p_beginDate and debitamount<>0
              group by ve.voucherno
            ) m,
           (  select ve.voucherno,count(1) creditcount
              from f_voucherentry ve,f_voucher v
              where ve.voucherno=v.voucherno
                and v.b_date>=p_beginDate and creditamount<>0
              group by ve.voucherno
            ) n
      where a.voucherno = b.voucherno and a.voucherno=m.voucherno and a.voucherno=n.voucherno;

     update f_voucher set status='accounted' where status='audited' and b_date>=p_beginDate;
end;
/

prompt
prompt Creating function FN_F_BALANCE
prompt ==============================
prompt
create or replace function FN_F_Balance
(
    p_beginDate date:=null --从哪一天开始结算
) return number
/**
 增加返回值-101，结算日期为空
**/
is
  v_lastDate date;
  v_beginDate date;
  v_b_date f_systemstatus.b_date%type;
  v_status f_systemstatus.status%type;
  v_cnt number(10);
  v_rtn number(10);
  v_errorcode      number;
    v_errormsg       varchar2(200);
begin
/*  if(p_beginDate is null) then
   p_beginDate := trunc(sysdate);
  end if;*/
   update F_systemstatus
           set status = 1,
               note = '结算中';
  commit; --此处提交是为了结算中状态外围能看到。

   --对财务系统状态表加锁，防止财务结算并发
   select b_date,status into v_b_date,v_status from F_systemstatus for update;

  --结算开始
  SP_F_ClearAction_Done(p_actionid => 0);

  --抽取电脑凭证
  v_rtn := FN_F_ExtractVoucher();
  SP_F_ClearAction_Done(p_actionid => 1);

  if p_beginDate is not null then
   v_beginDate:=trunc(p_beginDate);
  else
    v_beginDate:= trunc(sysdate);
  end if;
 /* --最近结算日
  select nvl(max(b_date),to_date('2000-01-01','yyyy-MM-dd')) into v_lastDate from f_dailybalance;
  --如果有新加入最近结算日的凭证，最近结算日提前一天。
  select count(*) into v_cnt from f_voucher where b_date=v_lastDate and status='audited';
  if(v_cnt>0) then
    v_lastDate:=v_lastDate-1;
  end if;

  if(v_beginDate is null) then
    v_beginDate := v_lastDate + 1;
  else
    --判断指定结算日期和最后结算日间是否有凭证，如果有从最近结算日后一天开始
    select count(*) into v_cnt from f_voucher where b_date>v_lastDate and b_date<p_beginDate;
    if(v_cnt>0) then
      v_beginDate := v_lastDate + 1;
    end if;
  end if;*/

  --归属流水及凭证日期
  update f_fundflow set b_date=v_beginDate;
  update f_voucher set b_date=v_beginDate where status='audited';
  SP_F_ClearAction_Done(p_actionid => 2);



  insert into f_log
    (occurtime, type, userid, description)
  values
    (sysdate, 'sysinfo', 'system', 'Balance specify date:'||nvl(to_char(p_beginDate,'yyyy-MM-dd'),'No')||' ->exec date:'||to_char(v_beginDate,'yyyy-MM-dd'));

  --将凭证记入会计账簿
  SP_F_PutVoucherToBook(v_beginDate);
  SP_F_ClearAction_Done(p_actionid => 3);
  --结算账户
  SP_F_BalanceAccount(v_beginDate);
  SP_F_ClearAction_Done(p_actionid => 4);
  --生成客户总账
  SP_F_ClientLedger(v_beginDate);
  SP_F_ClearAction_Done(p_actionid => 5);


  --插入历史流水表
  insert into f_h_fundflow
  select * from f_fundflow where b_date is not null;
  --删除当前流水表记录
  delete from F_Fundflow where b_date is not null;

  --插入冻结资金历史流水表
  insert into f_h_frozenfundflow
  select * from f_frozenfundflow;

  --删除当前的冻结资金流水表
  delete from f_frozenfundflow;
  SP_F_ClearAction_Done(p_actionid => 6);

  -- 生成交易商清算资金数据 by 2014-04-21 zhaodc
  SP_F_ComputeFirmRights(v_beginDate);
  SP_F_ClearAction_Done(p_actionid => 7);

  update F_systemstatus
           set b_date = v_beginDate,
               status = 2,
               note = '结算完成',
               cleartime = sysdate;
 SP_F_ClearAction_Done(p_actionid => 8);
  return 1;
 exception
    when others then
        rollback;

        -- 恢复状态为未结算
        update f_systemstatus
           set status = 0,
               note = '未结算';
        commit;

        return -100;
end;
/

prompt
prompt Creating function FN_F_BALANCE_OLD
prompt ==================================
prompt
create or replace function FN_F_Balance_old
(
    p_beginDate date:=null --从哪一天开始结算
) return number
/**
 增加返回值-101，结算日期为空
**/
is
  v_lastDate date;
  v_beginDate date;
  v_b_date f_systemstatus.b_date%type;
  v_status f_systemstatus.status%type;
  v_cnt number(10);
  v_rtn number(10);
  v_errorcode      number;
    v_errormsg       varchar2(200);
begin
/*  if(p_beginDate is null) then
   p_beginDate := trunc(sysdate);
  end if;*/
   update F_systemstatus
           set status = 1,
               note = '结算中';
  commit; --此处提交是为了结算中状态外围能看到。

   --对财务系统状态表加锁，防止财务结算并发
   select b_date,status into v_b_date,v_status from F_systemstatus for update;

  --结算开始
  SP_F_ClearAction_Done(p_actionid => 0);

  --抽取电脑凭证
  v_rtn := FN_F_ExtractVoucher();
  SP_F_ClearAction_Done(p_actionid => 1);

  if p_beginDate is not null then
   v_beginDate:=trunc(p_beginDate);
  else
    v_beginDate:= trunc(sysdate);
  end if;
 /* --最近结算日
  select nvl(max(b_date),to_date('2000-01-01','yyyy-MM-dd')) into v_lastDate from f_dailybalance;
  --如果有新加入最近结算日的凭证，最近结算日提前一天。
  select count(*) into v_cnt from f_voucher where b_date=v_lastDate and status='audited';
  if(v_cnt>0) then
    v_lastDate:=v_lastDate-1;
  end if;

  if(v_beginDate is null) then
    v_beginDate := v_lastDate + 1;
  else
    --判断指定结算日期和最后结算日间是否有凭证，如果有从最近结算日后一天开始
    select count(*) into v_cnt from f_voucher where b_date>v_lastDate and b_date<p_beginDate;
    if(v_cnt>0) then
      v_beginDate := v_lastDate + 1;
    end if;
  end if;*/

  --归属流水及凭证日期
  update f_fundflow set b_date=v_beginDate;
  update f_voucher set b_date=v_beginDate where status='audited';
  SP_F_ClearAction_Done(p_actionid => 2);



  insert into f_log
    (occurtime, type, userid, description)
  values
    (sysdate, 'sysinfo', 'system', 'Balance specify date:'||nvl(to_char(p_beginDate,'yyyy-MM-dd'),'No')||' ->exec date:'||to_char(v_beginDate,'yyyy-MM-dd'));

  --将凭证记入会计账簿
  SP_F_PutVoucherToBook(v_beginDate);
  SP_F_ClearAction_Done(p_actionid => 3);
  --结算账户
  SP_F_BalanceAccount(v_beginDate);
  SP_F_ClearAction_Done(p_actionid => 4);
  --生成客户总账
  SP_F_ClientLedger(v_beginDate);
  SP_F_ClearAction_Done(p_actionid => 5);


  --插入历史流水表
  insert into f_h_fundflow
  select * from f_fundflow where b_date is not null;
  --删除当前流水表记录
  delete from F_Fundflow where b_date is not null;

  --插入冻结资金历史流水表
  insert into f_h_frozenfundflow
  select * from f_frozenfundflow;

  --删除当前的冻结资金流水表
  delete from f_frozenfundflow;
  SP_F_ClearAction_Done(p_actionid => 6);


  update F_systemstatus
           set b_date = v_beginDate,
               status = 2,
               note = '结算完成',
               cleartime = sysdate;
 SP_F_ClearAction_Done(p_actionid => 7);
  return 1;
 exception
    when others then
        rollback;

        -- 恢复状态为未结算
        update f_systemstatus
           set status = 0,
               note = '未结算';
        commit;

        return -100;
end;
/

prompt
prompt Creating function FN_F_B_FIRMADD
prompt ================================
prompt
create or replace function FN_F_B_firmADD
(
    p_FirmID m_firm.firmid%type --交易商代码
)
return integer is
  /**
  * 银行系统添加交易商
  * 返回值： 1 成功
  **/
  v_cnt                number(4); --数字变量
  v_name               m_firm.name%type;
begin
  select count(*) into v_cnt from F_B_FIRMUSER where firmid = p_FirmID;
  if (v_cnt <= 0) then
	select name into v_name from m_firm where firmid = p_FirmID;
    insert into F_B_FIRMUSER (firmID,name,maxPersgltransMoney,maxPertransMoney,maxPertranscount,status,registerDate,maxAuditMoney) values (p_FirmID,v_name,0,0,0,1,sysdate,0);
  end if;
  return 1;
end;
/

prompt
prompt Creating function FN_F_B_FIRMDEL
prompt ================================
prompt
create or replace function FN_F_B_FirmDEL
(
    p_FirmID   m_firm.firmid%type --交易商代码
)
return integer is
  /**
  * 删除交易商
  * 返回值： 1 成功
  **/
  v_cnt                number(4); --数字变量
  v_firmstatus         F_B_FIRMUSER.status%type; --交易商状态
  RET_TradeModuleError integer := -901;--与errorInfo配合使用
begin
  --检查交易商是否存在签约信息
  select count(*) into v_cnt from F_B_FIRMIDANDACCOUNT where isOpen=1 and firmid=p_FirmID;
  if (v_cnt > 0) then
    return -1;
  end if;

  --检查交易商是否存在
  select count(*) into v_cnt from F_B_FIRMUSER where firmid=p_FirmID;
  if (v_cnt = 0) then
    return 1;
  end if;

  --检查交易商状态
  select status into v_firmstatus from F_B_FIRMUSER where firmid=p_FirmID;
  if (v_firmstatus = 1) then
	return 1;
  end if;

  --注销交易商
  update F_B_FIRMUSER set status=1 where firmid=p_FirmID;

  return 1;
end;
/

prompt
prompt Creating function FN_F_EXTRACTVOUCHERPRE
prompt ========================================
prompt
create or replace function FN_F_ExtractVoucherPre
return number
/***
 * 远期结算
 * 返回：-1:远期结算不成功
 *       -2：存在小于等于远期当前结算日的流水，未设结算日
 ***/
as
  v_lastDate date;
  v_beginDate date;
  v_b_date date;
  v_cnt number(10);
  v_rtn varchar2(10);
  v_enabled char(1);
begin
  return 1;
end;
/

prompt
prompt Creating function FN_F_FIRMADD
prompt ==============================
prompt
create or replace function FN_F_firmADD
(
    p_FirmID m_firm.firmid%type --交易商代码
)
return integer is
  /**
  * 现货系统添加交易商
  * 返回值： 1 成功
  **/
  v_cnt                number(4); --数字变量
  v_enabled char(1);
begin
  select count(*) into v_cnt from f_account where Code='200100'||p_FirmID;
  if(v_cnt=0)then
    insert into f_account(Code,Name,accountLevel,dCFlag)
    select '200100'||p_FirmID,name||p_FirmID,3,'C' from f_account
    where code='200100';
  end if;
  select count(*) into v_cnt from f_account where Code='200101'||p_FirmID;
  if(v_cnt=0)then
    insert into f_account(Code,Name,accountLevel,dCFlag)
    select '200101'||p_FirmID,name||p_FirmID,3,'C' from f_account
    where code='200101';
  end if;
  select count(*) into v_cnt from f_firmfunds where firmid=p_FirmID;
  if(v_cnt=0)then
    insert into f_firmfunds
      (firmid, balance, frozenfunds)
    values
      (p_FirmID, 0, 0);
  end if;

  return 1;
end;
/

prompt
prompt Creating function FN_F_FIRMDEL
prompt ==============================
prompt
create or replace function FN_F_FirmDel
(
    p_FirmID   m_firm.firmid%type--交易商代码
)
return integer is
  /**
  * 删除交易商
  * 返回值： 1 成功
  *          -900 资金不为0
  **/
 -- v_cnt                number(4); --数字变量
  v_balance      f_firmfunds.balance%type;
  RET_FundNotZero integer := -901;

begin

   select balance - frozenfunds into v_balance from f_firmfunds where firmid = p_FirmID;
   if(v_balance <>0) then
            return RET_FundNotZero;
   end if;

  /*---mengyu 2013.8.29 注销交易商表数据不变也不删除--start-*/
  /*select count(*) into v_cnt from f_voucherentry f where f.accountcode='20100'||p_FirmID;
  if(v_cnt>0) then
    select count(*) into v_cnt from f_account f where code='200100'||p_FirmID||'_';
     if(v_cnt=0) then
        update f_account set code='200100'||p_FirmID||'_' where code='200100'||p_FirmID;
     else
        delete from f_account where Code='200100'||p_FirmID;
     end if;
  else
    delete from f_account where Code='200100'||p_FirmID;
  end if;
  */
   /*---mengyu 2013.8.29 注销交易商表数据不变也不删除--end-*/
  /*select count(*) into v_cnt from f_voucherentry f where f.accountcode='200101'||p_FirmID;
  if(v_cnt>0) then
    select count(*) into v_cnt from f_account f where code='200101'||p_FirmID||'_';
     if(v_cnt=0) then
        update f_account set code='200101'||p_FirmID||'_' where code='200101'||p_FirmID;
     else
        delete from f_account where Code='200101'||p_FirmID;
     end if;
  else
  delete from f_account where Code='200101'||p_FirmID;
  end if;*/
 /*---mengyu 2013.8.29 注销交易商表数据不变也不删除--start-*/
 -- delete from f_firmfunds where firmid=p_FirmID;

 -- update f_accountbook set debitcode=debitcode||'_' where debitcode in ('200100'||p_FirmID/*, '20101'||p_FirmID*/);
 -- update f_accountbook set creditcode=creditcode||'_' where creditcode in ('200100'||p_FirmID/*, '20101'||p_FirmID*/);
 -- update f_clientledger set firmid=firmid||'_' where firmid=p_FirmID;
 -- update f_dailybalance set accountcode=accountcode||'_' where accountcode in ('200100'||p_FirmID/*, '20101'||p_FirmID*/);
 -- update f_firmbalance set firmid=firmid||'_' where firmid=p_FirmID;
 -- update f_h_fundflow set firmid=firmid||'_' where firmid=p_FirmID;
 -- update f_voucherentry set accountcode=accountcode||'_' where accountcode in ('200100'||p_FirmID/*, '20101'||p_FirmID*/);
 /*---mengyu 2013.8.29 注销交易商表数据不变也不删除--end-*/
  return 1;
end;
/

prompt
prompt Creating function FN_F_FIRMTOSTATUS
prompt ===================================
prompt
create or replace function FN_F_FirmToStatus
(
    p_FirmID   m_firm.firmid%type--交易商代码
)
return integer is
  /**
  * 修改交易商状态
  * 返回值： 1 成功
  **/
  v_cnt                number(4); --数字变量
begin

    return 1;
end;
/

prompt
prompt Creating function FN_F_GETREALFUNDS
prompt ===================================
prompt
create or replace function FN_F_GetRealFunds
(
  p_firmid varchar2,   --交易商代码
  p_lock number      --是否上锁 1:上锁 0：不上锁
) return number
/***
 * 获取可用资金
 * version 1.0.0.1 公用方法
 * 返回值：可用余额
 ****/
is
  v_realfunds number(15,2);
begin
  if(p_lock=1) then
    select balance-frozenfunds into v_realfunds from f_firmfunds where firmid=p_firmid for update;
  else
    select balance-frozenfunds into v_realfunds from f_firmfunds where firmid=p_firmid;
  end if;
  return v_realfunds;
end;
/

prompt
prompt Creating function FN_F_SETVOUCHERBDATE
prompt ======================================
prompt
create or replace function FN_F_SetVoucherBDate(
  p_endAuditTime date, --审核时间截止时间
  p_b_date date --归属结算日
)
return number
as
/***
 * 凭证划分结算日
 * version 1.0.0.1
 *
 *
 ****/

  v_cnt number(8):=0;
  v_endAuditTime date;
  v_b_date date;

begin
  v_endAuditTime:=p_endAuditTime;
  if(p_endAuditTime is null) then
    v_endAuditTime:= sysdate;
  end if;
  v_b_date:=p_b_date;
  if(p_b_date is null) then
    v_b_date:= trunc(sysdate);
  end if;

  update f_voucher set b_date=v_b_date where b_date is null and audittime<=v_endAuditTime and status='audited';

  v_cnt:=SQL%ROWCOUNT;

  update f_fundflow set b_date=v_b_date where b_date is null and createtime<=v_endAuditTime;

  return v_cnt;

end;
/

prompt
prompt Creating function FN_F_UPDATEFROZENFUNDS
prompt ========================================
prompt
create or replace function FN_F_UpdateFrozenFunds
(
  p_firmid varchar2,   --交易商代码
  p_amount number,     --发生额（正值增加，负值减少）
  p_moduleID char   --交易模块ID 15：远期 23：现货 21：竞价
)  return number
/***
 * 更新冻结资金
 * version 1.0.0.1 此方法公用
 *
 * 返回值：冻结资金余额
 ****/
is
  v_frozenfunds number(15,2);
  v_moduleFrozenfunds number(15,2);
begin
  update f_firmfunds set frozenfunds=frozenfunds + p_amount where firmid=p_firmid
  returning frozenfunds into v_frozenfunds;
  if(SQL%ROWCOUNT = 0) then
    Raise_application_error(-21001, 'FirmID not existed !'); --不存在的交易商代码
  end if;

  update f_frozenfunds set frozenfunds=frozenfunds + p_amount where moduleid=p_moduleID and firmid=p_firmid;
  if(SQL%ROWCOUNT = 0) then
    insert into f_frozenfunds
      (moduleid, firmid, frozenfunds)
    values
      (p_moduleID, p_FirmID, p_amount);
  end if;

  --不允许银行接口将冻结资金减为负值
  if(p_moduleID = '28') then
    select frozenfunds into v_moduleFrozenfunds from f_frozenfunds where moduleid=p_moduleID and firmid=p_firmid;
    if(v_moduleFrozenfunds<0)then
      Raise_application_error(-21011, 'Module 28:frozen funds<0!');
    end if;
  end if;

  return v_frozenfunds;
end;
/

prompt
prompt Creating function FN_M_FIRMADD
prompt ==============================
prompt
create or replace function FN_M_FirmAdd
(
    p_FirmID   m_firm.firmid%type, --交易商代码
    p_UserID   m_Trader.Userid%type, -- 用户名
    p_Password m_Trader.Password%type, -- 密码
    errorInfo OUT VARCHAR2--当某个模块添加交易商发生错的时候存放错误信息
)
return integer is
  /**
  * 同步交易商到各个模块
  * 返回值： 1 成功
  *          -900 交易商已经存在
  *          -901 用户名已经存在
  *          -902 某个交易模块发生错误
  **/
  v_cnt                number(4); --数字变量
  Module_RET           number(4); --模块添加交易商返回值
  IS_Error             boolean;--调用其它模块时是否发生错误
  CodeInfo_RET         varchar2(1024);--错误信息
  E_CNName             varchar2(64);--各个系统中文名称
  v_errorcode          number(4); --数字变量
  RET_FoundFirmID      integer := -900;
  RET_FoundUserID      integer := -901;
  RET_TradeModuleError integer := -902;--与errorInfo配合使用
begin
  --检查交易商是否已经存在
  select count(*) into v_cnt from m_trader where traderid = p_FirmID;
  if (v_cnt > 0) then
    return RET_FoundFirmID;
  end if;
  --检查用户是否存在
  select count(*) into v_cnt from m_trader where userID = p_UserID;
  if (v_cnt > 0) then
    return RET_FoundUserID;
  end if;

  IS_Error:=false;
  --循环调用每一个交易模块的添加交易商函数；从交易模块表中查询添加交易商函数长度大于5（FN_xx_）的字段
   for AddFirmFnStr in (select trim(AddFirmFn) as AddFirmFn,ModuleID from C_TradeModule where  lengthb(AddFirmFn)>5)
    loop
        --调试使用 dbms_output.put_line('BEGIN :Module_RET :='||AddFirmFnStr.AddFirmFn||'(:firmid); END;');
        --调用交易模块表中的添加交易商函数
        execute immediate 'BEGIN :Module_RET :='||AddFirmFnStr.AddFirmFn||'(:firmid); END;' using OUT Module_RET,IN p_FirmID;
        --如果返回值不是1则回滚返回交易模块发生错误
        if(Module_RET!=1)then
            IS_Error:=true;
            --获取错误信息
            select count(*) into v_errorcode from m_procedures_errorcode p where p.moduleid=AddFirmFnStr.Moduleid and p.errorcode=Module_RET;
            if(v_errorcode = 1)then
                select p.errorinfo into CodeInfo_RET from m_procedures_errorcode p where p.moduleid=AddFirmFnStr.Moduleid and p.errorcode=Module_RET;
                CodeInfo_RET:='错误信息:'||CodeInfo_RET;
            end if;
            select m.cnname into E_CNName from c_trademodule m where m.moduleid=AddFirmFnStr.Moduleid;
            errorInfo:=errorInfo||'\n'||E_CNName||'，返回码:'||Module_RET||CodeInfo_RET||';';
            CodeInfo_RET:='';

        end if;
    end loop;

    if(IS_Error)then
      rollback;
      return RET_TradeModuleError;
    end if;
    --写入交易商交易模块表
    --insert into m_firmmodule(moduleid, firmid, enabled)
        --select moduleid, p_FirmID, 'Y' from C_TradeModule where ISFirmSet='Y';
    --写入交易员交易模块表
    insert into m_tradermodule
            (moduleid, traderid, enabled)
        select moduleid, FirmID, enabled from m_firmmodule where FirmID=p_FirmID;
    --写入交易员表
    insert into m_trader
           (traderid, firmid, name, userid, password, status, type, createtime, modifytime, keycode, enablekey)
    values
           (p_FirmID, p_FirmID, p_FirmID, p_UserID, FN_M_MD5(p_FirmID||p_Password), 'N', 'A', sysdate, sysdate, '', 'N');

    return 1;
end;
/

prompt
prompt Creating function FN_M_FIRMDEL
prompt ==============================
prompt
create or replace function FN_M_FirmDel
(
    p_FirmID   m_firm.firmid%type, --交易商代码
    errorInfo OUT VARCHAR2--当某个模块删除交易商发生错的时候存放错误信息
)
return integer is
  /**
  * 删除交易商
  * 返回值： 1 成功
  *          -900 交易商不存在
  *          -901 某个交易模块发生错误
  **/
  v_cnt                number(4); --数字变量
  Module_RET           number(4); --模块删除交易商返回值
  IS_Error             boolean;--调用其它模块时是否发生错误
  CodeInfo_RET         varchar2(1024);--错误信息
  E_CNName             varchar2(64);--各个系统中文名称
  v_errorcode                number(4); --数字变量
  RET_NOFoundFirmID      integer := -900;
  RET_TradeModuleError integer := -901;--与errorInfo配合使用
begin
  --检查交易商是否存在
  select count(*) into v_cnt from m_firm where firmid=p_FirmID;
  if (v_cnt = 0) then
    return RET_NOFoundFirmID;
  end if;

  IS_Error:=false;
  --循环调用每一个交易模块的删除交易商函数；从交易模块表中查询删除交易商函数长度大于5（FN_xx_）的字段
   for DelFirmFnStr in (select trim(DelFirmFn) as DelFirmFn,ModuleID from C_TradeModule where  lengthb(DelFirmFn)>5)
    loop
        --调用交易模块表中的删除交易商函数
        execute immediate 'BEGIN :Module_RET :='||DelFirmFnStr.DelFirmFn||'(:firmid); END;' using OUT Module_RET,IN p_FirmID;
        --如果返回值不是1则回滚返回交易模块发生错误
        if(Module_RET!=1)then
            IS_Error:=true;
            --获取错误信息
            select count(*) into v_errorcode from m_procedures_errorcode p where p.moduleid=DelFirmFnStr.Moduleid and p.errorcode=Module_RET;
            if(v_errorcode = 1)then
                select p.errorinfo into CodeInfo_RET from m_procedures_errorcode p where p.moduleid=DelFirmFnStr.Moduleid and p.errorcode=Module_RET;
                CodeInfo_RET:='错误信息:'||CodeInfo_RET;
            end if;
            select m.cnname into E_CNName from c_trademodule m where m.moduleid=DelFirmFnStr.Moduleid;
            errorInfo:=errorInfo||'\n'||E_CNName||'，返回码:'||Module_RET||CodeInfo_RET||';';
            CodeInfo_RET:='';
        end if;
    end loop;

    if(IS_Error) then
      rollback;
      return RET_TradeModuleError;
    end if;

    delete from m_tradermodule where traderid in (select traderid from m_trader where firmid=p_firmid);
   --mengyu 2013.08.29 注销交易商不删除表数据
   -- delete from m_trader where firmid=p_firmid;
    delete from m_firmmodule where firmid=p_firmid;
    update m_firm set status=PKG_C_Base.FIRM_STATUS_ERASE where firmid=p_firmid;

    return 1;
end;
/

prompt
prompt Creating function FN_M_FIRMTOSTATUS
prompt ===================================
prompt
create or replace function FN_M_FirmToStatus
(
    p_FirmID m_firm.firmid%type,
    p_ToStatus m_firm.status%type,   -- 目标状态
    errorInfo OUT VARCHAR2--当某个模块修改交易商状态发生错的时候存放错误信息
)
return integer is
/**
 * 客户状态改变：冻结，解冻
 * 返回值： 1 成功
 *          -900 交易商状态不正确
 *          -901 不存在的交易商
 *          -920 某一个模块在修改交易商状态时发生错误
 **/
    v_cnt                number(4); --数字变量
    v_status       m_firm.status%type;--当前状态
    Module_RET           number(4); --模块修改交易商状态返回值
    IS_Error             boolean;--调用其它模块时是否发生错误
    CodeInfo_RET         varchar2(1024);--错误信息
    E_CNName             varchar2(64);--各个系统中文名称
    v_errorcode          number(4); --数字变量
    RET_StatusError integer := -900;
    RET_NotFoundError integer := -901;
    RET_TradeModuleError integer := -902;
begin
     --修改的目标状态只能是正常或者禁用
     if(p_ToStatus != PKG_C_Base.FIRM_STATUS_NORMAL and p_ToStatus!=PKG_C_Base.FIRM_STATUS_DISABLE) then
        return RET_StatusError;
     end if;

      --检查建议商是否已经存在
      select count(*) into v_cnt from m_firm where firmid = p_FirmID;
      if (v_cnt = 0) then
         return RET_NotFoundError;
      end if;

     --当前状态
    select status into v_status from m_firm t where t.firmid = p_FirmID for update;

    if(p_ToStatus = PKG_C_Base.FIRM_STATUS_DISABLE) then --客户冻结
        if(v_status != PKG_C_Base.FIRM_STATUS_NORMAL) then
            return RET_StatusError;
        end if;

    end if;

    if(p_ToStatus = PKG_C_Base.FIRM_STATUS_NORMAL) then --客户解冻
        if(v_status != PKG_C_Base.FIRM_STATUS_DISABLE) then
            return RET_StatusError;
        end if;
    end if;
    IS_Error:=false;
    --循环调用每一个交易模块的修改交易商状态函数；从交易模块表中查询修改交易商状态长度大于5（FN_xx_）的字段
    for UpdateFirmStatusFnStr in (select trim(UpdateFirmStatusFn) as UpdateFirmStatusFn,ModuleID from C_TradeModule where  lengthb(UpdateFirmStatusFn)>5)
       loop
           --调用交易模块表中的添加交易商函数
           execute immediate 'BEGIN :Module_RET :='||UpdateFirmStatusFnStr.UpdateFirmStatusFn||'(:firmid); END;' using OUT Module_RET,IN p_FirmID;
           --如果返回值不是1则回滚返回交易模块发生错误
           if(Module_RET!=1)then
              IS_Error:=true;
               --获取错误信息
              select count(*) into v_errorcode from m_procedures_errorcode p where p.moduleid=UpdateFirmStatusFnStr.Moduleid and p.errorcode=Module_RET;
              if(v_errorcode = 1)then
                  select p.errorinfo into CodeInfo_RET from m_procedures_errorcode p where p.moduleid=UpdateFirmStatusFnStr.Moduleid and p.errorcode=Module_RET;
                  CodeInfo_RET:='错误信息:'||CodeInfo_RET;
              end if;
              select m.cnname into E_CNName from c_trademodule m where m.moduleid=UpdateFirmStatusFnStr.Moduleid;
              errorInfo:=errorInfo||'\n'||E_CNName||'，返回码:'||Module_RET||CodeInfo_RET||';';
              CodeInfo_RET:='';

           end if;
     end loop;

     if(IS_Error)then
     rollback;
     return RET_TradeModuleError;
     end if;

     update m_firm set status = p_ToStatus where firmid = p_FirmID;

     return 1;
end;
/

prompt
prompt Creating function FN_T_ADDTRADEDAYS
prompt ===================================
prompt
create or replace function FN_T_AddTradeDAYS
/**
  * 添加交易日
  */
 return number is
  v_curdate date;
  v_cnt     number;
begin

  delete from t_tradedays;
  begin
    select max(cleardate) + 1 into v_curdate from t_h_trade;
  exception
    when NO_DATA_FOUND then
      select tradedate into v_curdate from t_systemstatus;
  end;

  if (v_curdate is null) then
    select tradedate into v_curdate from t_systemstatus;
  end if;

  for i in 1 .. 2000 loop
    select count(*)
      into v_cnt
      from t_a_nottradeday t
     where t.week like '%' || to_char(v_curdate, 'D') || '%';

    if (v_cnt = 0) then
      --交易日
      select count(*)
        into v_cnt
        from t_a_nottradeday t
       where t.day like '%' || to_char(v_curdate, 'YYYY-MM-DD') || '%';
      if (v_cnt = 0) then
        insert into t_tradedays (day) values (v_curdate);
      end if;
    end if;
    v_curdate := v_curdate + 1;
  end loop;

  return 0;
end;
/

prompt
prompt Creating function FN_T_COMPUTEASSURE
prompt ====================================
prompt
create or replace function FN_T_ComputeAssure(
    p_FirmID varchar2,
    p_CommodityID varchar2,
    p_bs_flag        number,
    p_quantity number,
    p_price number
) return number
/****
 * 计算担保金
 * 返回值 成功返回担保金;-1 计算所需数据不全;-100 其它错误
****/
as
	v_version varchar2(10):='1.0.0.1';
    v_marginRate_b         number(10,4);
    v_marginRate_s         number(10,4);
    v_marginAlgr         number(2);
    v_contractFactor     number(12,2);
    v_margin             number(15,2) default 0;
begin
    --获取商品信息：合约因子，交易担保金，保证金算法
    select marginAssure_b,marginAssure_s,marginalgr,contractfactor
    into v_marginRate_b,v_marginRate_s,v_marginAlgr,v_contractFactor
    from T_Commodity where CommodityID=p_CommodityID;

    begin
        --获取特户的交易担保金，保证金算法
        select marginAssure_b,marginAssure_s,marginalgr
    	into v_marginRate_b,v_marginRate_s,v_marginAlgr
        from T_A_FirmMargin
        where FirmID=p_FirmID and CommodityID=p_CommodityID;
    exception
        when NO_DATA_FOUND then
            null;
    end;
    if(v_marginAlgr=1) then  --应收保证金=数量*合约因子*价格*担保金
    	if(p_bs_flag = 1) then  --买
        	v_margin:=p_quantity*v_contractFactor*p_price*v_marginRate_b;
        elsif(p_bs_flag = 2) then  --卖
        	v_margin:=p_quantity*v_contractFactor*p_price*v_marginRate_s;
        end if;
    elsif(v_marginAlgr=2) then  --应收保证金=数量*担保金
    	if(p_bs_flag = 1) then  --买
        	v_margin:=p_quantity*v_marginRate_b;
        elsif(p_bs_flag = 2) then  --卖
        	v_margin:=p_quantity*v_marginRate_s;
        end if;
    end if;
    if(v_margin is null) then
    	rollback;
        return -1;
    end if;
    return v_margin;
exception
    when no_data_found then
    	rollback;
        return -1;
    when others then
    	rollback;
    	return -100;
end;
/

prompt
prompt Creating function FN_T_COMPUTEMARGIN
prompt ====================================
prompt
create or replace function FN_T_ComputeMargin(
    p_FirmID varchar2,
    p_CommodityID varchar2,
    p_bs_flag        number,
    p_quantity number,
    p_price number
) return number
/****
 * 计算保证金
 * 返回值 成功返回保证金;-1 计算所需数据不全;-100 其它错误
****/
as
	v_version varchar2(10):='1.0.0.1';
    v_marginRate_b         number(10,4);
    v_marginRate_s         number(10,4);
    v_marginAlgr         number(2);
    v_contractFactor     number(12,2);
    v_margin             number(15,2) default 0;
begin
    --获取商品信息：合约因子，交易保证金，保证金算法
    select marginrate_b,marginrate_s,marginalgr,contractfactor
    into v_marginRate_b,v_marginRate_s,v_marginAlgr,v_contractFactor
    from T_Commodity where CommodityID=p_CommodityID;

    begin
        --获取特户的交易保证金，保证金算法
        select marginrate_b,marginrate_s,marginalgr
    	into v_marginRate_b,v_marginRate_s,v_marginAlgr
        from T_A_FirmMargin
        where FirmID=p_FirmID and CommodityID=p_CommodityID;
    exception
        when NO_DATA_FOUND then
            null;
    end;
    if(v_marginAlgr=1) then  --应收保证金=数量*合约因子*价格*保证金
    	if(p_bs_flag = 1) then  --买
		    if(v_marginRate_b = -1) then --  -1表示收全款
		    	v_margin:=p_quantity*v_contractFactor*p_price;
		    else
			    v_margin:=p_quantity*v_contractFactor*p_price*v_marginRate_b;
		    end if;
        elsif(p_bs_flag = 2) then  --卖
		    if(v_marginRate_s = -1) then --  -1表示收全款
		    	v_margin:=p_quantity*v_contractFactor*p_price;
		    else
			    v_margin:=p_quantity*v_contractFactor*p_price*v_marginRate_s;
		    end if;
        end if;
    elsif(v_marginAlgr=2) then  --应收保证金=数量*保证金
    	if(p_bs_flag = 1) then  --买
		    if(v_marginRate_b = -1) then --  -1表示收全款
		    	v_margin:=p_quantity*v_contractFactor*p_price;
		    else
			    v_margin:=p_quantity*v_marginRate_b;
		    end if;
        elsif(p_bs_flag = 2) then  --卖
		    if(v_marginRate_s = -1) then --  -1表示收全款
		    	v_margin:=p_quantity*v_contractFactor*p_price;
		    else
			    v_margin:=p_quantity*v_marginRate_s;
		    end if;
        end if;
    end if;

    if(v_margin is null) then
    	rollback;
        return -1;
    end if;
    return v_margin;
exception
    when no_data_found then
    	rollback;
        return -1;
    when others then
	    rollback;
    	return -100;
end;
/

prompt
prompt Creating function FN_T_COMPUTEPAYOUT
prompt ====================================
prompt
create or replace function FN_T_ComputePayout(
    p_FirmID varchar2,
    p_CommodityID varchar2,
    p_bs_flag        number,
    p_quantity number,
    p_price number
) return number
/****
 * 计算交收货款
 * 返回值 成功返回交收货款;-1 计算所需数据不全;-100 其它错误
 *
 * 新添加在计算比例货款时，如果商品含税，扣除其税费   by 张天骥  2015/09/11
****/
as
	v_version varchar2(10):='1.0.0.1';
    v_marginRate_b         number(10,4);
    v_marginAlgr_b         number(2);
    v_contractFactor     number(12,2);
    v_margin             number(15,2) default 0;
    v_taxinclusive      number(1);                              --商品是否含税 1为不含税 0为含税
    v_addedtax         number(10,4);                          --商品税率
    
begin
    --获取商品信息：合约因子，交收货款系数，交收货款算法 , 商品是否含税，商品税率
    select PayoutRate,PayoutAlgr,contractfactor,taxinclusive,addedtax
    into v_marginRate_b,v_marginAlgr_b,v_contractFactor,v_taxinclusive,v_addedtax
    from T_Commodity where CommodityID=p_CommodityID;

    begin
        --获取特殊的交收货款系数，交收货款算法
        select PayoutRate,PayoutAlgr
    	into v_marginRate_b,v_marginAlgr_b
        from T_A_FirmSettleMargin
        where FirmID=p_FirmID and CommodityID=p_CommodityID;
    exception
        when NO_DATA_FOUND then
            null;
    end;
  
	if(v_marginAlgr_b = 1) then  
             --如果商品不含税
            if(v_taxinclusive = 1 ) then --应收交收货款 =数量 * 合约因子 * 价格 * 交收货款系数 按照百分比算
            v_margin:=p_quantity*v_contractFactor*p_price*v_marginRate_b;
            else -- 商品含税 应收交收货款 =数量 * 合约因子 * 价格 * 交收货款系数 * 商品含税系数  按照百分比算
             v_margin:=p_quantity*v_contractFactor*p_price*v_marginRate_b*(1/(1+v_addedtax));
             end if;
    elsif(v_marginAlgr_b = 2) then  --应收交收货款 =数量 * 交收货款系数 按绝对值算
		v_margin:=p_quantity*v_marginRate_b;
    end if;

    if(v_margin is null) then
    	rollback;
        return -1;
    end if;
    return v_margin;
exception
    when no_data_found then
    	rollback;
        return -1;
    when others then
    	rollback;
    	return -100;
end;
/

prompt
prompt Creating function FN_T_COMPUTESETTLEFEE
prompt =======================================
prompt
create or replace function FN_T_ComputeSettleFee(
    p_FirmID     varchar2,
    p_CommodityID varchar2,
    p_bs_flag        number,
    p_quantity       number,
    p_price          number
) return number
/****
 * 计算交收手续费
 * 返回值 成功返回手续费;-1 计算交易费用所需数据不全;-100 其它错误
****/
as
	v_version varchar2(10):='1.0.0.1';
    v_feeRate_b         number(15,9);
    v_feeRate_s         number(15,9);
    v_feeAlgr       number(2);
    v_contractFactor  number(12,2);
    v_LowestSettleFee             number(15,2) default 0;
    v_fee             number(15,2) default 0;
begin
    --获取商品信息：合约因子，手续费系数，手续费算法。
    select SettleFeeRate_B,SettleFeeRate_S,SettleFeeAlgr,contractfactor,LowestSettleFee
    into v_feeRate_b,v_feeRate_s,v_feeAlgr,v_contractFactor,v_LowestSettleFee
    from T_Commodity where CommodityID=p_CommodityID;

    begin
        --获取特户的手续费系数，手续费算法
        select SettleFeeRate_B,SettleFeeRate_S,SettleFeeAlgr
   		into v_feeRate_b,v_feeRate_s,v_feeAlgr
        from T_A_FirmSettleFee
        where FirmID=p_FirmID and CommodityID=p_CommodityID;
    exception
        when NO_DATA_FOUND then
            null;
    end;
    if(v_feeAlgr=1) then  --应收手续费=数量*合约因子*价格*手续费
    	if(p_bs_flag = 1) then  --买
        	v_fee:=p_quantity*v_contractFactor*p_price*v_feeRate_b;
        elsif(p_bs_flag = 2) then  --卖
        	v_fee:=p_quantity*v_contractFactor*p_price*v_feeRate_s;
        end if;
    elsif(v_feeAlgr=2) then  --应收手续费=数量*手续费
    	if(p_bs_flag = 1) then  --买
        	v_fee:=p_quantity*v_feeRate_b;
        elsif(p_bs_flag = 2) then  --卖
        	v_fee:=p_quantity*v_feeRate_s;
        end if;
    end if;
    if(v_fee is null) then
    	rollback;
        return -1;
    end if;
    --交收手续费和最低交收手续费取最大者，
    --2009-07-06改成不比较了，直接返回计算的手续费，让函数外围去比较
	/*
    if(v_fee >= v_LowestSettleFee) then
        return v_fee;
	else
	    return v_LowestSettleFee;
    end if;
    */
    return v_fee;
exception
    when no_data_found then
    	rollback;
        return -1;
    when others then
    	rollback;
   		return -100;
end;
/

prompt
prompt Creating function FN_T_SUBHOLDSUM
prompt =================================
prompt
CREATE OR REPLACE FUNCTION FN_T_SubHoldSum
(
  p_HoldQty      number,   --持仓数量
  p_GageQty      number,   --抵数量
  p_Margin      number,   --保证金
  p_Assure      number,   --担保金
  p_CommodityID varchar2, --商品代码
  p_ContractFactor        number, --合约因子
  p_BS_Flag        number, --买卖标志
  p_FirmID varchar2,   --交易商代码
  p_HoldFunds      number,   --交易商持仓金额
  p_CustomerID varchar2,   --交易客户代码
  p_CustomerHoldFunds      number,   --交易客户持仓金额
  p_GageMode number,     --抵顶模式，0全抵顶；1半抵顶
  p_FrozenQty number     --交易客户冻结数量
)  return number
/***
 * 减少交易客户，交易商的持仓合计信息
 *
 * 返回值：1成功
 ****/
is
  v_version varchar2(10):='1.0.0.10';
  v_num   number(10);
begin
    --更改交易客户持仓合计表中的持仓记录
    update T_CustomerHoldSum
    set holdqty = holdqty - p_HoldQty,
        GageQty = GageQty - p_GageQty,
        FrozenQty = FrozenQty - p_FrozenQty,
        holdfunds = holdfunds - p_CustomerHoldFunds,
        HoldMargin = HoldMargin - p_Margin,
        HoldAssure = HoldAssure - p_Assure,
        evenprice = decode((holdqty+GageQty - p_HoldQty-p_GageQty),0,0,(holdfunds - p_CustomerHoldFunds)/((holdqty+GageQty - p_HoldQty-p_GageQty)*p_ContractFactor))
    where CustomerID = p_CustomerID
      and CommodityID = p_CommodityID
      and bs_flag = p_BS_Flag;
    --更改交易商持仓合计表中的持仓记录
    update T_FirmHoldSum
    set holdqty = holdqty - p_HoldQty,
        GageQty = GageQty - p_GageQty,
        holdfunds = holdfunds - p_HoldFunds,
        HoldMargin = HoldMargin - p_Margin,
        HoldAssure = HoldAssure - p_Assure,
        evenprice = decode(p_GageMode,1,decode((holdqty+GageQty - p_HoldQty-p_GageQty),0,0,(holdfunds - p_HoldFunds)/((holdqty+GageQty - p_HoldQty-p_GageQty)*p_ContractFactor)),
        decode((holdqty - p_HoldQty),0,0,(holdfunds - p_HoldFunds)/((holdqty - p_HoldQty)*p_ContractFactor)))
    where Firmid = p_FirmID
      and CommodityID = p_CommodityID
      and bs_flag = p_BS_Flag;

   return 1;
end;
/

prompt
prompt Creating function FN_T_AHEADSETTLEONE
prompt =====================================
prompt
create or replace function FN_T_AheadSettleOne(
    p_CommodityID varchar2,   --商品代码
  p_Price         number,  --交收价
  p_BS_Flag     number,  --买卖标志
    p_CustomerID    varchar2,     --交易客户ID
    p_HoldQty      number,   --交收持仓数量，即非抵顶数量
  p_GageQty      number   --交收抵顶数量
) return number
/****
 * 买卖单方向提前交收
 * 1、注意不要提交commit，因为别的函数要调用它；
 * 返回值
 * 1 成功
 * -1  可交收持仓数量不足
 * -2  可交收抵顶数量不足
 * -3  交收持仓数量大于可交收持仓数量
 * -4  交收抵顶数量大于可抵顶数量
 * -100 其它错误
****/
as
  v_version varchar2(10):='1.0.2.1';
    v_CommodityID varchar2(16);
    v_CustomerID        varchar2(40);
    v_FirmID varchar2(32);
    v_HoldQty  number;
    v_HoldSumQty     number(10);
    v_frozenQty      number(10);
    v_Margin         number(15,2):=0;
    v_Margin_one         number(15,2):=0;
    v_closeFL_one         number(15,2):=0;    --一条记录的交收盈亏
    v_CloseFL         number(15,2):=0;        --交收盈亏累加
    v_Fee_one         number(15,2):=0;    --一条记录的交收手续费
    v_Fee         number(15,2):=0;        --交收手续费累加
  v_Assure         number(15,2):=0;
  v_Assure_one         number(15,2):=0;
    v_Payout         number(15,2):=0;
    v_Payout_one         number(15,2):=0;
    v_BS_Flag           number(2);
    v_Price         number(15,2);
    v_ContractFactor    number(12,2);
    v_MarginPriceType           number(1);
    v_MarginPrice    number(15,2);  --计算成交保证金的价格
  v_HoldFunds    number(15,2):=0;  --平仓时应退持仓金额，不包括抵顶的
  v_CustomerHoldFunds    number(15,2):=0;  --平仓时应退持仓金额，包括抵顶的
    v_TradeDate date;
  v_A_HoldNo number(15);
  v_ID number(15);
  v_AddedTaxFactor T_Commodity.AddedTaxFactor%type;--增值税率系数=AddedTax/(1+AddedTax)
  v_GageQty     number(10);
  v_CloseAddedTax_one   number(15,2); --交收盈亏增值税
  v_CloseAddedTax         number(15,2):=0;        --交收盈亏增值税累加
  v_unCloseQty     number(10):=p_HoldQty; --未平数量，用于中间计算
  v_unCloseQtyGage     number(10):=p_GageQty; --未平数量，用于中间计算
  v_tradedAmount   number(10):=0;  --成交数量
  v_tradedAmountGage   number(10):=0;  --成交数量
  v_CloseAlgr           number(2);
  v_num            number(10);
  v_Balance    number(15,2);
  v_F_FrozenFunds   number(15,2);
  type cur_T_HoldPosition is ref cursor;
  v_HoldPosition cur_T_HoldPosition;
  v_sql varchar2(500);
  v_orderby  varchar2(100);
  v_closeTodayHis        number(2);    --平今仓还是历史仓(0平今仓；1平历史仓)
  v_YesterBalancePrice    number(15,2);
  v_AtClearDate          date;
  v_LowestSettleFee             number(15,2) default 0;
  v_GageMode number(2);--抵顶模式，分0全抵顶和1半抵顶，半抵顶时要计算浮亏，2009-10-14
  v_TaxInclusive     number(1);   --商品是否含税 0含税  1不含税   duanbaodi 20150730
begin
    v_CustomerID := p_CustomerID;
      v_CommodityID := p_CommodityID;
        v_BS_Flag := p_BS_Flag;
        --锁住交易客户持仓合计，以防止并发更新
        select HoldQty,FrozenQty,GageQty
        into v_HoldSumQty, v_frozenQty,v_GageQty
        from T_CustomerHoldSum
        where CustomerID = v_CustomerID
          and CommodityID = v_CommodityID
          and bs_flag = v_BS_Flag for update;
        --可交收持仓数量不足
        if(p_HoldQty > v_HoldSumQty-v_frozenQty) then
            rollback;
            return -1;
        end if;
        --可交收抵顶数量不足
        if(p_GageQty > v_GageQty) then
            rollback;
            return -2;
        end if;
        --获取平仓算法,抵顶模式，保证金计算类型，增值税，合约因子, 是否含税
        select CloseAlgr,GageMode into v_CloseAlgr,v_GageMode from T_A_Market;

       /*select Contractfactor,MarginPriceType,AddedTaxFactor,LastPrice,LowestSettleFee
        into v_ContractFactor,v_MarginPriceType,v_AddedTaxFactor,v_YesterBalancePrice,v_LowestSettleFee
        from T_Commodity where CommodityID=v_CommodityID;            20150730*/

        select Contractfactor,MarginPriceType,AddedTaxFactor,LastPrice,LowestSettleFee,TaxInclusive  /* 增加是否含税字段  duanbaodi 20150730  */
        into v_ContractFactor,v_MarginPriceType,v_AddedTaxFactor,v_YesterBalancePrice,v_LowestSettleFee,v_TaxInclusive
        from T_Commodity where CommodityID=v_CommodityID;

     select TradeDate into v_TradeDate from T_SystemStatus;


        --根据平仓算法(0先开先平；1后开先平；2持仓均价平仓(不排序)选择排序条件
        if(v_CloseAlgr = 0) then
          v_orderby := ' order by a.A_HoldNo ';
      elsif(v_CloseAlgr = 1) then
          v_orderby := ' order by a.A_HoldNo desc ';
      end if;

      v_sql := 'select a.a_holdno,FirmID,price,(a.HoldQty-nvl(b.FrozenQty,0)),GageQty,nvl(b.FrozenQty,0),a.AtClearDate from T_holdposition a,(select A_HoldNo,nvl(sum(FrozenQty),0) FrozenQty from T_SpecFrozenHold group by A_HoldNo) b ' ||
                 ' where (a.HoldQty+a.GageQty) > 0 and a.A_HoldNo=b.A_HoldNo(+) and CustomerID=''' || v_CustomerID ||
                 ''' and CommodityID =''' || v_CommodityID || ''' and bs_flag = ' || v_BS_Flag || v_orderby;

        --遍历持仓明细的数量并过滤掉指定平仓冻结的数量
            open v_HoldPosition for v_sql;
            loop
                fetch v_HoldPosition into v_a_holdno, v_FirmID, v_price, v_holdqty,v_GageQty,v_frozenQty,v_AtClearDate;
                exit when v_HoldPosition%NOTFOUND;
                --如果此笔持仓全部被指定平仓冻结且没有抵顶则指向下一条记录
              --2011-01-12 by chenxc 修改当持仓明细的持仓数量为0，抵顶数量不为0，提前交收非抵顶的会插入一条持仓记录都是0的到交收持仓明细表，反之依然
                if((v_holdqty <> 0 and v_unCloseQty>0) or (v_GageQty <> 0 and v_unCloseQtyGage>0)) then
                  --清0
                  v_tradedAmount:=0;
                  v_tradedAmountGage:=0;
                  v_Payout_one := 0;
                  --1、计算应退款项
                  if(v_holdqty > 0) then
                    if(v_holdqty<=v_unCloseQty) then
                        v_tradedAmount:=v_holdqty;
                    else
                        v_tradedAmount:=v_unCloseQty;
                    end if;
                    --计算应退保证金，根据设置选择开仓价还是昨结算价来算
            if(v_MarginPriceType = 1) then
                  v_MarginPrice := v_YesterBalancePrice;
              elsif(v_MarginPriceType = 2) then
              --判断是平今仓还是平历史仓
                if(trunc(v_TradeDate) = trunc(v_AtClearDate)) then
                    v_closeTodayHis := 0;
                else
                  v_closeTodayHis := 1;
                end if;
              if(v_closeTodayHis = 0) then  --平今仓
                v_MarginPrice := v_price;
              else  --平历史仓
                    v_MarginPrice := v_YesterBalancePrice;
                end if;
            else  -- default type is 0
              v_MarginPrice := v_price;
            end if;
                    v_Margin_one := FN_T_ComputeMargin(v_FirmID,v_CommodityID,v_BS_Flag,v_tradedAmount,v_MarginPrice);
                    if(v_Margin_one < 0) then
                        Raise_application_error(-20040, 'computeMargin error');
                    end if;
                --计算担保金
                v_Assure_one := FN_T_ComputeAssure(v_FirmID,v_CommodityID,v_BS_Flag,v_tradedAmount,v_MarginPrice);
                if(v_Assure_one < 0) then
                    Raise_application_error(-20041, 'computeAssure error');
                end if;
                --保证金应加上担保金
                v_Margin_one := v_Margin_one + v_Assure_one;
                    v_Margin:=v_Margin + v_Margin_one;
                    v_Assure:=v_Assure + v_Assure_one;
                  --计算应退持仓金额，不包括抵顶的
                  v_HoldFunds := v_HoldFunds + v_tradedAmount*v_price*v_ContractFactor;
                  end if;
                  --2、计算持仓明细中交收的抵顶数量
          if(v_GageQty > 0) then
                    if(v_GageQty<=v_unCloseQtyGage) then
                        v_tradedAmountGage:=v_GageQty;
                    else
                        v_tradedAmountGage:=v_unCloseQtyGage;
                    end if;
                  end if;
              --如果是半抵顶模式则交易商持仓金额要退抵顶的
              if(v_GageMode=1) then
                v_HoldFunds := v_HoldFunds + v_tradedAmountGage*v_price*v_ContractFactor;
              end if;
                  --二级客户合计金额，包括抵顶的
                  v_CustomerHoldFunds := v_CustomerHoldFunds + (v_tradedAmount+v_tradedAmountGage)*v_price*v_ContractFactor;
                --3、计算交收款项
          --计算买方交收货款，提前交收不用收交收保证金
          if(v_BS_Flag = 1) then
                v_Payout_one := FN_T_ComputePayout(v_FirmID,v_CommodityID,v_BS_Flag,v_tradedAmount+v_tradedAmountGage,p_Price);
                  if(v_Payout_one < 0) then
                      Raise_application_error(-20043, 'computePayout error');
                  end if;
                end if;
              --计算交收手续费
          v_Fee_one := FN_T_ComputeSettleFee(v_FirmID,v_CommodityID,v_BS_Flag,v_tradedAmount+v_tradedAmountGage,p_Price);
                if(v_Fee_one < 0) then
                  Raise_application_error(-20031, 'computeFee error');
                end if;

                --计算税前交收盈亏
                if(v_BS_Flag = 1) then
                    v_closeFL_one := (v_tradedAmount+v_tradedAmountGage)*(p_Price-v_price)*v_contractFactor; --税前盈亏
                else
                    v_closeFL_one := (v_tradedAmount+v_tradedAmountGage)*(v_price-p_Price)*v_contractFactor; --税前盈亏
                end if;


                --计算交收增值税,v_AddedTaxFactor增值税系数=AddedTax/(1+AddedTax)
              --  v_CloseAddedTax_one := round(v_closeFL_one*v_AddedTaxFactor,2);
                  v_CloseAddedTax_one :=0;

                --计算税后的交收盈亏 duanbaodi 20150730   xief 20150811
               /* if(v_TaxInclusive=1) then
                     --不含税 扣除增值税
                     v_closeFL_one := v_closeFL_one - v_CloseAddedTax_one; --税后盈亏
                end if;
                */

                /*--计算税后交收盈亏
                v_closeFL_one := v_closeFL_one - v_CloseAddedTax_one; --税后盈亏              20150730*/
          --累计金额
              v_Payout := v_Payout + v_Payout_one;
              v_Fee := v_Fee + v_Fee_one;
          v_CloseFL:=v_CloseFL + v_closeFL_one;  --税后盈亏合计
          v_CloseAddedTax:=v_CloseAddedTax + v_CloseAddedTax_one;  --交收增值税合计
              --将当前持仓记录和交收费用插入交收持仓明细表，并更新持仓数量和抵顶数量为实际交收的数量
          select SEQ_T_SettleHoldPosition.nextval into v_ID from dual;
          --按字段名插入交收持仓明细表
              insert into t_settleholdposition
            (id, settleprocessdate, a_holdno, a_tradeno, customerid, commodityid, bs_flag, price, holdqty, openqty, holdtime, holdmargin, firmid, gageqty, holdassure, floatingloss, settlemargin, payout, settlefee, settle_pl, settleaddedtax, settleprice, settletype, holdtype, atcleardate)
              select v_ID,v_TradeDate,a_holdno, a_tradeno, customerid, commodityid, bs_flag, price, holdqty, openqty, holdtime, holdmargin, firmid, gageqty, holdassure, floatingloss,0,v_Payout_one,v_Fee_one,v_closeFL_one,v_CloseAddedTax_one,p_Price,2, holdtype, atcleardate
              from t_holdposition
              where A_HoldNo=v_A_HoldNo;

              update T_SettleHoldPosition set HoldQty=v_tradedAmount,GageQty=v_tradedAmountGage where ID=v_ID;

                  --更新持仓记录
                    update T_holdposition
                    set holdqty = holdqty - v_tradedAmount,HoldMargin=HoldMargin-v_Margin_one,HoldAssure=HoldAssure-v_Assure_one,GageQty = GageQty - v_tradedAmountGage
                    where a_holdno = v_a_holdno;

                  v_unCloseQty:=v_unCloseQty - v_tradedAmount;
                  v_unCloseQtyGage:=v_unCloseQtyGage - v_tradedAmountGage;
                  exit when v_unCloseQty=0 and v_unCloseQtyGage=0;
                end if;
            end loop;
            close v_HoldPosition;
            if(v_unCloseQty>0) then --交收持仓数量大于可交收持仓数量
                rollback;
                return -3;
            end if;
            if(v_unCloseQtyGage>0) then --交收抵顶数量大于可抵顶数量
                rollback;
                return -4;
            end if;
    --减少交易客户，交易商的持仓合计信息2009-10-15
        v_num := FN_T_SubHoldSum(p_HoldQty,p_GageQty,v_Margin,v_Assure,v_CommodityID,v_ContractFactor,v_BS_Flag,v_FirmID,v_HoldFunds,v_CustomerID,v_CustomerHoldFunds,v_GageMode,0);

    --写合计的流水
        --扣除交收货款,同时退保证金和担保金
        update T_Firm
        set runtimemargin = runtimemargin - v_Margin,
            RuntimeAssure = RuntimeAssure - v_Assure
        where Firmid = v_FirmID;
        --更新冻结资金，释放个人部分的保证金
    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(v_FirmID,-(v_Margin-v_Assure),'15');
        --插入扣除交收货款资金流水
    v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15008',v_Payout,null,v_CommodityID,null,null);
        --更新资金,同时插入交收手续费资金流水
    --如果手续费低于最低交收手续费，则按最低交收手续费收取，并且将此交易商最后一笔明细的手续费更新成加上差额的手续费
    if(v_ID is not null) then  --表示必须是有持仓做了交收，因为不判断当没有持仓时也会收取最低交收手续费的
        if(v_Fee >= v_LowestSettleFee) then
            v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15010',v_Fee,null,v_CommodityID,null,null);
      else
          v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15010',v_LowestSettleFee,null,v_CommodityID,null,null);
            update T_SettleHoldPosition
            set SettleFee=SettleFee+(v_LowestSettleFee-v_Fee)
            where ID=v_ID;
        end if;
      end if;
    --更新资金余额，并写付交收盈利或收交收亏损流水( 商品不含税，交易期间要进行扣税 )
    --商品含不含税，均不扣税
   /* if(v_TaxInclusive=1) then
    if(v_CloseFL >= 0) then
      v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15011',v_CloseFL,null,v_CommodityID,v_CloseAddedTax,null);
    else
      v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15012',-v_CloseFL,null,v_CommodityID,-v_CloseAddedTax,null);
    end if;
    end if;*/

    ---xief 20150811
    if(v_CloseFL >= 0) then
      v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15011',v_CloseFL,null,v_CommodityID,null,null);
    else
      v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15012',-v_CloseFL,null,v_CommodityID,null,null);
    end if;

    return 1;

end;
/

prompt
prompt Creating function FN_T_COMPUTEFPSUBTAX
prompt ======================================
prompt
create or replace function FN_T_ComputeFPSubTax(
    p_EvenPrice         number, --持仓均价
    p_Price         number, --行情价
    p_HoldQty number, --持仓数量
    p_ContractFactor    number, --合约因子
    p_BS_Flag number, --买卖标志
	p_AddedTax number,--增值税率
    p_FloatingProfitSubTax number --浮动盈亏是否扣税  0不扣税；1扣税
) return number
/****
 * 计算浮动盈亏
 * 返回值 成功返回浮动盈亏
****/
as
	v_version varchar2(10):='1.0.0.1';
    v_FL_new number(15,2) default 0;
begin
    --计算浮动盈亏
    if(p_BS_Flag = 1) then
      v_FL_new := (p_Price-p_EvenPrice)*p_HoldQty*p_ContractFactor;
    else
      v_FL_new := (p_EvenPrice-p_Price)*p_HoldQty*p_ContractFactor;
    end if;
    if(p_FloatingProfitSubTax=1) then
    	v_FL_new := v_FL_new/(1+p_AddedTax);
    end if;
    return v_FL_new;
end;
/

prompt
prompt Creating function FN_T_UPDATEFLOATINGLOSS
prompt =========================================
prompt
create or replace function FN_T_UpdateFloatingLoss(
    p_b_firmid varchar2,  --起始交易商
    p_e_firmid varchar2,  --截止交易商
    p_LastTime timestamp  --上次更新时间，null表示全部更新
) return timestamp
/****
 * 更新浮亏
 * 返回更新时间
****/
as
    v_version varchar2(10):='1.0.0.10';
    v_b_firmid varchar2(32);    --起始交易商
    v_e_firmid varchar2(32);    --截止交易商
    v_price      number(15,2);  --行情结算价
    v_lasttime timestamp;
    v_FloatingLossComputeType number(2);
    v_FloatingProfitSubTax number(1);
    v_F_FrozenFunds number(15,2);
    v_fl number(15,2);
    v_Status         number(2);
    v_GageMode number(2);--抵顶模式，分0全抵顶和1半抵顶，半抵顶时要计算浮亏，2009-10-14
begin
	select FloatingLossComputeType,FloatingProfitSubTax,GageMode into v_FloatingLossComputeType,v_FloatingProfitSubTax,v_GageMode from T_A_Market;
	--2009-09-08 每日无负债方式，交易结算或财务结算后按当日结算价算盈亏，否则按昨结算价，所以需要状态
	--解决每日无负债方式在交易结算或财务结算后做抵顶，交收业务，调用此浮亏计算会出现按昨结算价计算的问题
    if(v_FloatingLossComputeType = 4) then
        select Status into v_Status from T_SystemStatus;
    end if;
    v_b_firmid := p_b_firmid;
    if(v_b_firmid is null) then
        v_b_firmid := '0';
    end if;
    v_e_firmid := p_e_firmid;
    if(v_e_firmid is null) then
        v_e_firmid := 'zzzzzzzzzz';
    end if;
    if(p_lasttime is null) then
        v_lasttime := to_date('2000-01-01','yyyy-MM-dd');
    else
        v_lasttime := p_lasttime;
    end if;

    for commodity in (select c.AddedTax,c.ContractFactor,c.MarginAlgr,c.MarginRate_B,c.MarginRate_S,c.lastprice,q.commodityid,q.price,q.createtime
                      from T_Commodity c,T_Quotation q where c.CommodityID=q.CommodityID and q.createtime>v_lasttime order by q.createtime)
    loop
        if(commodity.createtime>v_lasttime) then
            v_lasttime:=commodity.createtime;
        end if;

        if(v_FloatingLossComputeType = 4) then  --盘中不算盈亏，即每日无负债
        	if(v_Status=3 or v_Status=10) then  --交易结算或财务结算后按当日结算价算盈亏，否则按昨结算价
            	v_price := commodity.price;
            else
            	v_price := commodity.lastprice;
            end if;
    	else
      	    v_price := commodity.price;
        end if;

        for holdsum in (select rowid,floatingloss,bs_flag,HoldQty,GageQty,EvenPrice from T_Firmholdsum
                        where CommodityID=commodity.CommodityID and firmid>=v_b_firmid and firmid<=v_e_firmid)
        loop
            if(holdsum.bs_flag=1) then
                if(commodity.MarginRate_B = -1 or (commodity.MarginAlgr=1 and commodity.MarginRate_B >= 1)) then
                    v_fl := 0;
                else
                    --v_fl := (v_Price-holdsum.EvenPrice)*holdsum.HoldQty*commodity.ContractFactor;
                    if(v_GageMode=1) then --半抵顶
                    	v_fl := FN_T_ComputeFPSubTax(holdsum.EvenPrice,v_Price,holdsum.HoldQty+holdsum.GageQty,commodity.ContractFactor,holdsum.bs_flag,commodity.AddedTax,v_FloatingProfitSubTax);
                    else  --全抵顶
                    	v_fl := FN_T_ComputeFPSubTax(holdsum.EvenPrice,v_Price,holdsum.HoldQty,commodity.ContractFactor,holdsum.bs_flag,commodity.AddedTax,v_FloatingProfitSubTax);
                    end if;
                end if;
            end if;
            if(holdsum.bs_flag=2) then
                if(commodity.MarginRate_S = -1 or (commodity.MarginAlgr=1 and commodity.MarginRate_S >= 1)) then
                    v_fl := 0;
                else
                    --v_fl := (holdsum.EvenPrice-v_Price)*holdsum.HoldQty*commodity.ContractFactor;
                    if(v_GageMode=1) then --半抵顶
                    	v_fl := FN_T_ComputeFPSubTax(holdsum.EvenPrice,v_Price,holdsum.HoldQty+holdsum.GageQty,commodity.ContractFactor,holdsum.bs_flag,commodity.AddedTax,v_FloatingProfitSubTax);
                    else  --全抵顶
                    	v_fl := FN_T_ComputeFPSubTax(holdsum.EvenPrice,v_Price,holdsum.HoldQty,commodity.ContractFactor,holdsum.bs_flag,commodity.AddedTax,v_FloatingProfitSubTax);
                    end if;
                end if;
            end if;

            if(holdsum.floatingloss<>v_fl) then
                update T_Firmholdsum set floatingloss = v_fl where rowid=holdsum.rowid;
                commit;
            end if;
        end loop;
        /*
        --更新特殊交易商，暂时注释掉，一般不会出现此情况
		--买方
        for firmMargin_b in (
        	 select b.firmid,b.commodityid
             from T_A_FirmMargin b,(select commodityid from T_Quotation where createtime>v_lasttime order by createtime) c
             where b.firmid>=v_b_firmid and b.firmid<=v_e_firmid and b.commodityid=c.commodityid
             and (b.marginrate_b=-1 or (b.MarginAlgr=1 and b.MarginRate_B >= 1))
             )
        loop
        	select floatingloss into v_fl from T_Firmholdsum where firmid=firmMargin_b.firmid and commodityid=firmMargin_b.commodityid and bs_flag=1;
            if(v_fl<>0) then
                update T_Firmholdsum set floatingloss = 0 where firmid=firmMargin_b.firmid and commodityid=firmMargin_b.commodityid and bs_flag=1;
                commit;
            end if;
        end loop;
		--卖方
        for firmMargin_s in (
        	 select b.firmid,b.commodityid
             from T_A_FirmMargin b,(select commodityid from T_Quotation where createtime>v_lasttime order by createtime) c
             where b.firmid>=v_b_firmid and b.firmid<=v_e_firmid and b.commodityid=c.commodityid
             and (b.marginrate_s=-1 or (b.MarginAlgr=1 and b.MarginRate_S >= 1))
             )
        loop
        	select floatingloss into v_fl from T_Firmholdsum where firmid=firmMargin_s.firmid and commodityid=firmMargin_s.commodityid and bs_flag=2;
            if(v_fl<>0) then
                update T_Firmholdsum set floatingloss = 0 where firmid=firmMargin_s.firmid and commodityid=firmMargin_s.commodityid and bs_flag=2;
                commit;
            end if;
        end loop;
		*/
    end loop;

    if(p_lasttime is null or v_lasttime <> p_lasttime) then
        if(v_FloatingLossComputeType = 0) then     --商品分买卖
            for fz in (select a.firmid,a.FloatingLoss-b.runtimefl diff
                 from (select firmid,sum(case when FloatingLoss>0 then 0 else -FloatingLoss end) FloatingLoss from
                       T_FirmHoldSum where firmid>=v_b_firmid and firmid<=v_e_firmid group by firmid) a,
                       t_firm b where a.firmid=b.firmid)
            loop
                if(fz.diff <> 0) then
                    update T_Firm
                    set RuntimeFL = RuntimeFL + fz.diff
                    where FirmID = fz.firmid;
                    --更新冻结资金，释放或扣除变化的浮亏
      			        v_F_FrozenFunds := FN_F_UpdateFrozenFunds(fz.firmid,fz.diff,'15');
                    commit;
                end if;
            end loop;
        elsif(v_FloatingLossComputeType = 1) then  --商品不分买卖
            for fz in (select a.firmid,a.FloatingLoss-b.runtimefl diff
                   from (select firmid,sum(case when FloatingLoss>0 then 0 else -FloatingLoss end) FloatingLoss from
                          (select firmid,sum(FloatingLoss) FloatingLoss from T_FirmHoldSum
                           where firmid>=v_b_firmid and firmid<=v_e_firmid group by firmid,commodityID) group by firmid
                        ) a,t_firm b where a.firmid=b.firmid)
            loop
                if(fz.diff <> 0) then
                    update T_Firm
                    set RuntimeFL = RuntimeFL + fz.diff
                    where FirmID = fz.firmid;
                    --更新冻结资金，释放或扣除变化的浮亏
      			        v_F_FrozenFunds := FN_F_UpdateFrozenFunds(fz.firmid,fz.diff,'15');
                    commit;
                end if;
            end loop;
  			elsif(v_FloatingLossComputeType = 2) then  --不分商品
            for fz in (select a.firmid,a.FloatingLoss-b.runtimefl diff
                       from ( select firmid,case when sum(FloatingLoss)>0 then 0 else -sum(FloatingLoss) end FloatingLoss
                              from T_FirmHoldSum where firmid>=v_b_firmid and firmid<=v_e_firmid group by firmid) a,
                         t_firm b where a.firmid=b.firmid)
            loop
                if(fz.diff <> 0) then
                    update T_Firm
                    set RuntimeFL = RuntimeFL + fz.diff
                    where FirmID = fz.firmid;
                    --更新冻结资金，释放或扣除变化的浮亏
      			        v_F_FrozenFunds := FN_F_UpdateFrozenFunds(fz.firmid,fz.diff,'15');
                    commit;
                end if;
            end loop;
  			elsif(v_FloatingLossComputeType = 3 or v_FloatingLossComputeType = 4) then  --盘中算盈亏或不算盈亏
            for fz in (select a.firmid,a.FloatingLoss-b.runtimefl diff
                       from ( select firmid,-sum(FloatingLoss) FloatingLoss
                              from T_FirmHoldSum where firmid>=v_b_firmid and firmid<=v_e_firmid group by firmid) a,
                         t_firm b where a.firmid=b.firmid)
            loop
                if(fz.diff <> 0) then
                    update T_Firm
                    set RuntimeFL = RuntimeFL + fz.diff
                    where FirmID = fz.firmid;
                    --更新冻结资金，释放或扣除变化的浮亏
      			        v_F_FrozenFunds := FN_F_UpdateFrozenFunds(fz.firmid,fz.diff,'15');
                    commit;
                end if;
            end loop;
  			end if;
    end if;

    return v_lasttime;
end;
/

prompt
prompt Creating function FN_T_AHEADSETTLE
prompt ==================================
prompt
create or replace function FN_T_AheadSettle(
    p_ApplyID       number,     --申请单号
    p_CommodityID varchar2, --商品代码
    p_BillID         varchar2, --仓单号
    p_Quantity      number,   --仓单数量，即交收数量，包括抵顶的
 	p_Price         number,  --交收价
	p_sCustomerID    varchar2,     --卖方交易客户ID
	p_sGageQty      number default 0,    --其中卖交收抵顶数量
    p_bCustomerID    varchar2,     --买方交易客户ID
 	p_bGageQty      number default 0,   --其中买交收抵顶数量，业务上不存在此参数，实现上保留
    p_Modifier      varchar2,   --创建人
	p_ApplyType     number,    --申请种类:3：已有仓单转提前交收;6：提前交收
	p_ValidID       number    --生效仓单号，只有申请种类为3：已有仓单转提前交收才需要
) return number
/****
 * 提前交收
 * 返回值
 * 1 成功
 * 2 已处理过
 * -1  可交收买持仓数量不足
 * -2  可交收买抵顶数量不足
 * -3  交收买持仓数量大于可交收买持仓数量
 * -4  交收买抵顶数量大于可买抵顶数量
 * -11  可交收卖持仓数量不足
 * -12  可交收卖抵顶数量不足
 * -13  交收卖持仓数量大于可交收卖持仓数量
 * -14  交收卖抵顶数量大于可卖抵顶数量
 * -100 其它错误
****/
as
 	v_version varchar2(10):='1.0.0.9';
 	v_FirmID varchar2(10);      --卖方交易商ID
	v_bFirmID varchar2(10);      --买方交易商ID
    bRet            number(5);
    sRet            number(5);
    v_FL_ret            timestamp;
    v_num            number(10);
    v_errorcode      number;
    v_errormsg       varchar2(200);
    v_Payout         number(15,2):=0;
    v_ContractFactor T_Commodity.ContractFactor%type;
begin
 	bRet := FN_T_AheadSettleOne(p_CommodityID,p_Price,1,p_bCustomerID,p_Quantity-p_bGageQty,p_bGageQty); --买
 	if(bRet = 1) then
  		sRet := FN_T_AheadSettleOne(p_CommodityID,p_Price,2,p_sCustomerID,p_Quantity-p_sGageQty,p_sGageQty);  --卖
  		if(sRet = 1) then
	        --插入生效仓单表，不管是已有仓单转提前交收还是提前交收都应该插入新申请的有效仓单
            select FirmID into v_FirmID from T_Customer where CustomerID=p_sCustomerID;--找出卖方交易商ID
   			--2009-09-08增加提前交收完后直接插入交收配对表
   			--1、计算买方交收货款
   			select FirmID into v_bFirmID from T_Customer where CustomerID=p_bCustomerID;--找出买方交易商ID
	        v_Payout := FN_T_ComputePayout(v_bFirmID,p_CommodityID,1,p_Quantity,p_Price);
            if(v_Payout < 0) then
                Raise_application_error(-20043, 'computePayout error');
            end if;
            --2、插入交收配对表，提前交收不计算交收保证金
            select ContractFactor into v_ContractFactor from T_Commodity where CommodityID=p_CommodityID;
			insert into T_SettleMatch (MatchID,CommodityID,ContractFactor,Quantity,HL_Amount,Status,Result,FirmID_B,BuyPrice,BuyPayout_Ref,BuyPayout,BuyMargin,TakePenalty_B,PayPenalty_B,SettlePL_B,
			   		FirmID_S,SellPrice,SellIncome_Ref,SellIncome,SellMargin,TakePenalty_S,PayPenalty_S,SettlePL_S,CreateTime,ModifyTime)
			   		values ('ATS_'||seq_T_SettleMatch.nextVal,p_CommodityID,v_ContractFactor,p_Quantity,0,0,1,v_bFirmID,p_Price,p_Quantity*p_Price*v_ContractFactor,v_Payout,0,0,0,0,
			   		v_FirmID,p_Price,p_Quantity*p_Price*v_ContractFactor,0,0,0,0,0,sysdate,sysdate);

   			commit;
   			--提交后计算买卖双方浮亏
   			v_FL_ret := FN_T_UpdateFloatingLoss(null,null,null);

      		return 1;
     	elsif(sRet = -1) then
      		rollback;
   			return -11;
  		elsif(sRet = -2) then
      		rollback;
   			return -12;
  		elsif(sRet = -3) then
      		rollback;
   			return -13;
  		elsif(sRet = -4) then
      		rollback;
   			return -14;
  		else
      		rollback;
   			return -100;
  		end if;
 	else
  		rollback;
  		return bRet;
 	end if;
exception
    when OTHERS then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_AheadSettle',v_errorcode,v_errormsg);
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_T_COMPUTESETTLEMARGIN
prompt ==========================================
prompt
create or replace function FN_T_ComputeSettleMargin(
    p_FirmID varchar2,
    p_CommodityID varchar2,
    p_bs_flag        number,
    p_quantity number,
    p_price number
) return number
/****
 * 计算交收保证金
 * 返回值 成功返回交收保证金;-1 计算所需数据不全;-100 其它错误
****/
as
	v_version varchar2(10):='1.0.0.1';
    v_marginRate_b         number(10,4);
    v_marginRate_s         number(10,4);
    v_marginAlgr_b         number(2);
    v_marginAlgr_s         number(2);
    v_contractFactor     number(12,2);
    v_margin             number(15,2) default 0;
    v_settleMarginType number;   --交收保证金计算方式
    v_BeforeDays number;   --提前几日
    v_price number;
    tradeFundSum         number(15,2);
    tradeQtySum  number(10);
    v_SettleDate date;
    v_num            number(10);
    v_Quantity  number(10);
    i            number(4);
begin
select settleMargintype into v_settleMarginType from t_commodity where commodityid=p_CommodityID;--查询交收保证金计算方式  add by lizhenli 2011-12-5
if(v_settleMarginType = 0) then  --按交收日的闭市结算价
	    --找出交收日的行情结算价
	    begin
	    	select nvl(Price,0) into v_price from T_Quotation where CommodityID=p_CommodityID;
	    exception
	        when NO_DATA_FOUND then
	            select nvl(Price,0) into v_price from T_H_Quotation where CommodityID=p_CommodityID and ClearDate in(select max(ClearDate) from T_H_Quotation where CommodityID=p_CommodityID);
	    end;
      elsif(v_settleMarginType = 1) then  --按交收日前几日的闭市结算价的加权平均价
		--找出提前日，交收日期
	    select SettleDate,BeforeDays_M into v_SettleDate,v_BeforeDays from T_Commodity where CommodityID=p_CommodityID;
        tradeQtySum := 0;
        tradeFundSum := 0;
        --判断是否资金结算完成，不根据状态，因为重做结算时状态会变化
        --如果资金结算完成的话当前成交会删除，从而导致当天的价格没有参与计算 2010-05-24 by chenxc
        select count(*) into v_num from T_H_Quotation where CommodityID=p_CommodityID and ClearDate = v_SettleDate;
        if(v_num = 0) then
		    --从当前表中计算交收金额和数量
		    begin
		    	select nvl(Price,0) into v_price from T_Quotation where CommodityID=p_CommodityID;
		    	select nvl(sum(Quantity),0) into v_Quantity from T_Trade where CommodityID=p_CommodityID;
		    	tradeFundSum := tradeFundSum + v_price*v_Quantity;
				tradeQtySum := tradeQtySum + v_Quantity;
		    	i := 1;
		    exception
		        when NO_DATA_FOUND then
		           i := 0;
		    end;
        else
			i := 0;
		end if;
	    --循环计算交收日前的v_BeforeDays的金额和数量，包括交收日当天的v_BeforeDays的交易日期
        while i<v_BeforeDays loop
        	--加上下面的判断是表示如果设置的提前几日的加权价的天数大于实际的交易天数时不造成循环超出变量的范围，也即是设置的天数大于交易天数则按交易天数计算加权价格
            if(v_BeforeDays>=999 or i>=999) then
            	exit;
   			end if;
		    --从历史表中计算交收金额和数量
		    begin
		    	select nvl(Price,0) into v_price from T_H_Quotation where CommodityID=p_CommodityID and ClearDate = v_SettleDate-i;
		    	select nvl(sum(Quantity),0) into v_Quantity from T_H_Trade where CommodityID=p_CommodityID and ClearDate = v_SettleDate-i;
		    	tradeFundSum := tradeFundSum + v_price*v_Quantity;
		    	tradeQtySum := tradeQtySum + v_Quantity;
		    exception
		        when NO_DATA_FOUND then
		            v_BeforeDays := v_BeforeDays + 1;
		    end;
            i := i+1;
        end loop;
        --计算加权平均价，如果数量为0的话则用上面查出的交收价
		if(tradeQtySum <> 0) then
        	v_price := round(tradeFundSum/tradeQtySum,0);
        end if;

        else   --如果按订立价。则使用传递过来的价格
        v_price:=p_price;
     end if;
    --获取商品信息：合约因子，交收保证金系数，交收保证金算法
    select Settlemarginrate_b,Settlemarginrate_s,SettleMarginAlgr_B,SettleMarginAlgr_S,contractfactor
    into v_marginRate_b,v_marginRate_s,v_marginAlgr_b,v_marginAlgr_s,v_contractFactor
    from T_Commodity where CommodityID=p_CommodityID;

    begin
        --获取特殊的交收保证金系数，交收保证金算法
        select Settlemarginrate_b,Settlemarginrate_s,SettleMarginAlgr_B,SettleMarginAlgr_S
    	into v_marginRate_b,v_marginRate_s,v_marginAlgr_b,v_marginAlgr_s
        from T_A_FirmSettleMargin
        where FirmID=p_FirmID and CommodityID=p_CommodityID;
    exception
        when NO_DATA_FOUND then
            null;
    end;
    --交收保证金算法分买卖
    if(p_bs_flag = 1) then  --买
		if(v_marginAlgr_b = 1) then  --应收交收保证金=数量*合约因子*价格*交收保证金系数
			if(v_marginRate_b = -1) then --  -1表示收全款
				v_margin:=p_quantity*v_contractFactor*v_price;
			else
        		v_margin:=p_quantity*v_contractFactor*v_price*v_marginRate_b;
        	end if;
        elsif(v_marginAlgr_b = 2) then  --应收交收保证金=数量*交收保证金系数
			if(v_marginRate_b = -1) then --  -1表示收全款
				v_margin:=p_quantity*v_contractFactor*v_price;
			else
				v_margin:=p_quantity*v_marginRate_b;
			end if;
        end if;
    elsif(p_bs_flag = 2) then  --卖
    	if(v_marginAlgr_s = 1) then  --应收交收保证金=数量*合约因子*价格*交收保证金系数
			if(v_marginRate_s = -1) then --  -1表示收全款
				v_margin:=p_quantity*v_contractFactor*v_price;
			else
        		v_margin:=p_quantity*v_contractFactor*v_price*v_marginRate_s;
        	end if;
        elsif(v_marginAlgr_s = 2) then  --应收交收保证金=数量*交收保证金系数
			if(v_marginRate_s = -1) then --  -1表示收全款
				v_margin:=p_quantity*v_contractFactor*v_price;
			else
				v_margin:=p_quantity*v_marginRate_s;
			end if;
        end if;
    end if;
    if(v_margin is null) then
    	rollback;
        return -1;
    end if;
    return v_margin;
exception
    when no_data_found then
    	rollback;
        return -1;
    when others then
    	rollback;
    	return -100;
end;
/

prompt
prompt Creating function FN_T_AHEADSETTLEONEQTY
prompt ========================================
prompt
create or replace function FN_T_AheadSettleOneQty(
  p_ApplyID   varchar2,    --交收配对编号
  p_CommodityID varchar2,   --商品代码
  p_Price         number,  --交收价
  p_BS_Flag     number,  --买卖标志
    p_CustomerID    varchar2,     --交易客户ID
    p_OCustomerID    varchar2,     --对方交易客户ID
    p_HoldQty      number,   --交收持仓数量，即非抵顶数量
  p_GageQty      number   --交收抵顶数量
) return number
/****
 * 买卖单方向提前交收
 * 1、注意不要提交commit，因为别的函数要调用它；
 * 返回值
 * 1 成功
 * -1  可交收持仓数量不足
 * -2  可交收抵顶数量不足
 * -3  交收持仓数量大于可交收持仓数量
 * -4  交收抵顶数量大于可抵顶数量
 * -100 其它错误
****/
as
  v_version varchar2(10):='1.0.2.1';
    v_CommodityID varchar2(16);
    v_CustomerID        varchar2(40);
    v_FirmID varchar2(32);
    v_HoldQty  number;
    v_HoldSumQty     number(10);
    v_frozenQty      number(10);
    v_Margin         number(15,2):=0;
    v_Margin_one         number(15,2):=0;
    v_closeFL_one         number(15,2):=0;    --一条记录的交收盈亏
    v_CloseFL         number(15,2):=0;        --交收盈亏累加
    v_Fee_one         number(15,2):=0;    --一条记录的交收手续费
    v_Fee         number(15,2):=0;        --交收手续费累加
  v_Assure         number(15,2):=0;
  v_Assure_one         number(15,2):=0;
    v_Payout         number(15,2):=0;
    v_Payout_one         number(15,2):=0;
    v_BS_Flag           number(2);
    v_Price         number(15,2);
    v_ContractFactor    number(12,2);
    v_MarginPriceType           number(1);
    v_MarginPrice    number(15,2);  --计算成交保证金的价格
  v_HoldFunds    number(15,2):=0;  --平仓时应退持仓金额，不包括抵顶的
  v_CustomerHoldFunds    number(15,2):=0;  --平仓时应退持仓金额，包括抵顶的
    v_TradeDate date;
  v_A_HoldNo number(15);
  v_ID number(15);
  v_AddedTaxFactor T_Commodity.AddedTaxFactor%type;--增值税率系数=AddedTax/(1+AddedTax)
  v_GageQty     number(10);
  v_CloseAddedTax_one   number(15,2); --交收盈亏增值税
  v_CloseAddedTax         number(15,2):=0;        --交收盈亏增值税累加
  v_unCloseQty     number(10):=p_HoldQty; --未平数量，用于中间计算
  v_unCloseQtyGage     number(10):=p_GageQty; --未平数量，用于中间计算
  v_tradedAmount   number(10):=0;  --成交数量
  v_tradedAmountGage   number(10):=0;  --成交数量
  v_CloseAlgr           number(2);
  v_num            number(10);
  v_Balance    number(15,2);
  v_F_FrozenFunds   number(15,2);
  type cur_T_HoldPosition is ref cursor;
  v_HoldPosition cur_T_HoldPosition;
  v_sql varchar2(500);
  v_orderby  varchar2(100);
  v_closeTodayHis        number(2);    --平今仓还是历史仓(0平今仓；1平历史仓)
  v_YesterBalancePrice    number(15,2);
  v_AtClearDate          date;
  v_LowestSettleFee             number(15,2) default 0;
  v_GageMode number(2);--抵顶模式，分0全抵顶和1半抵顶，半抵顶时要计算浮亏，2009-10-14

  v_GageFrozenQty number(10);--add by yukx 20100428 抵顶冻结数量

  v_IsChargeMargin number(2);-- 是否收取交收保证金(0 不收取，1收取)  add by zhangjian- 20110713
  v_SettlementMargin_one     number(15,2):=0;-- 交收保证金
  v_SettlementMargin     number(15,2):=0;-- 交收保证金累加
  v_aheadSettlePriceType number(2);--提前交收价格类型 0:按订立价交收 1：按自主价交收
  v_settlePrice number(15,2);--交收价格
  v_settleMachID number(10):=0;--交收持仓明细表 ID
  v_totalRef         number(15,2):=0;  --基准货款的总值
  v_bFirmID   varchar2(32);  --买方交易商ID
  v_SettlementMargin_B      number(15,2):=0; --买方交收保证金
  v_settlePirce_B    number(15,6):=0;--买方交收价格
  v_bPayout         number(15,2):=0; --买方货款
   v_TaxInclusive     number(1);   --商品是否含税 0含税  1不含税   duanbaodi 20150730
begin
    v_CustomerID := p_CustomerID;
      v_CommodityID := p_CommodityID;
        v_BS_Flag := p_BS_Flag;
        --锁住交易客户持仓合计，以防止并发更新
        select HoldQty,FrozenQty,GageQty,GageFrozenQty
        into v_HoldSumQty, v_frozenQty,v_GageQty,v_GageFrozenQty
        from T_CustomerHoldSum
        where CustomerID = v_CustomerID
          and CommodityID = v_CommodityID
          and bs_flag = v_BS_Flag for update;
        /*  可交收持仓数量不足和可交收抵顶数量不足的判断用冻结数量和抵顶冻结数量判断
        --可交收持仓数量不足
        if(p_HoldQty > v_HoldSumQty-v_frozenQty) then
            rollback;
            return -1;
        end if;
        --可交收抵顶数量不足
        if(p_GageQty > v_GageQty) then
            rollback;
            return -2;
        end if;
        */
        --可交收持仓数量不足
        if(p_HoldQty > v_frozenQty) then
            rollback;
            return -1;
        end if;
        --可交收抵顶数量不足
        if(p_GageQty > v_GageFrozenQty) then
            rollback;
            return -2;
        end if;
         --select   seq_T_SettleMatch.nextVal into v_settleMachNumber from dual;
         --v_settleMachNumber:=p_settleMachNumber;

        --获取平仓算法,抵顶模式,是否收取交收保证金 , 保证金计算类型，增值税，合约因子,是否含税
        select CloseAlgr,GageMode,ASMarginType into v_CloseAlgr,v_GageMode,v_IsChargeMargin from T_A_Market;
       /* select Contractfactor,MarginPriceType,AddedTaxFactor,LastPrice,LowestSettleFee
        into v_ContractFactor,v_MarginPriceType,v_AddedTaxFactor,v_YesterBalancePrice,v_LowestSettleFee
        from T_Commodity where CommodityID=v_CommodityID;   duanbaodi 20150730 */

         select Contractfactor,MarginPriceType,AddedTaxFactor,LastPrice,LowestSettleFee,TaxInclusive
        into v_ContractFactor,v_MarginPriceType,v_AddedTaxFactor,v_YesterBalancePrice,v_LowestSettleFee,v_TaxInclusive
        from T_Commodity where CommodityID=v_CommodityID;  -- 增加 是否含税字段查询 duanbaodi 20150730

      select TradeDate into v_TradeDate from T_SystemStatus;

        --根据平仓算法(0先开先平；1后开先平；2持仓均价平仓(不排序)选择排序条件
        if(v_CloseAlgr = 0) then
         v_orderby := ' order by a.A_HoldNo ';
        elsif(v_CloseAlgr = 1) then
           v_orderby := ' order by a.A_HoldNo desc ';
       end if;

         select  aheadSettlePriceType  into v_aheadSettlePriceType from t_commodity  where commodityid=p_CommodityID;--获取提前交收交收价格类型


      v_sql := 'select  a.a_holdno,FirmID,price,(a.HoldQty-nvl(b.FrozenQty,0)),GageQty,nvl(b.FrozenQty,0),a.AtClearDate from T_holdposition a,(select A_HoldNo,nvl(sum(FrozenQty),0) FrozenQty from T_SpecFrozenHold group by A_HoldNo) b ' ||
                 ' where (a.HoldQty+a.GageQty) > 0 and a.A_HoldNo=b.A_HoldNo(+) and CustomerID=''' || v_CustomerID ||
                 ''' and CommodityID =''' || v_CommodityID || ''' and bs_flag = ' || v_BS_Flag || v_orderby;


         --遍历持仓明细的数量并过滤掉指定平仓冻结的数量
            open v_HoldPosition for v_sql;
            loop
                fetch v_HoldPosition into v_a_holdno, v_FirmID, v_price, v_holdqty,v_GageQty,v_frozenQty,v_AtClearDate;
                exit when v_HoldPosition%NOTFOUND;

                if(v_aheadSettlePriceType=0)then --如果按订立价交收
                      v_settlePrice:=v_Price;
                      else                   --如果按自主价交收
                       v_settlePrice:=p_Price;
                      end  if;

                --如果此笔持仓全部被指定平仓冻结且没有抵顶则指向下一条记录
              --2011-01-12 by chenxc 修改当持仓明细的持仓数量为0，抵顶数量不为0，提前交收非抵顶的会插入一条持仓记录都是0的到交收持仓明细表，反之依然
                if((v_holdqty <> 0 and v_unCloseQty>0) or (v_GageQty <> 0 and v_unCloseQtyGage>0)) then
                  --清0
                  v_tradedAmount:=0;
                  v_tradedAmountGage:=0;
                  v_Payout_one := 0;
                  --1、计算应退款项
                  if(v_holdqty > 0) then
                    if(v_holdqty<=v_unCloseQty) then
                        v_tradedAmount:=v_holdqty;
                    else
                        v_tradedAmount:=v_unCloseQty;
                    end if;
                    --计算应退保证金，根据设置选择开仓价还是昨结算价来算
            if(v_MarginPriceType = 1) then
                  v_MarginPrice := v_YesterBalancePrice;
              elsif(v_MarginPriceType = 2) then
              --判断是平今仓还是平历史仓
                if(trunc(v_TradeDate) = trunc(v_AtClearDate)) then
                    v_closeTodayHis := 0;
                else
                  v_closeTodayHis := 1;
                end if;
              if(v_closeTodayHis = 0) then  --平今仓
                v_MarginPrice := v_price;
              else  --平历史仓
                    v_MarginPrice := v_YesterBalancePrice;
                end if;
            else  -- default type is 0
              v_MarginPrice := v_price;
            end if;
                    v_Margin_one := FN_T_ComputeMargin(v_FirmID,v_CommodityID,v_BS_Flag,v_tradedAmount,v_MarginPrice);
                    if(v_Margin_one < 0) then
                        Raise_application_error(-20040, 'computeMargin error');
                    end if;
                --计算担保金
                v_Assure_one := FN_T_ComputeAssure(v_FirmID,v_CommodityID,v_BS_Flag,v_tradedAmount,v_MarginPrice);
                if(v_Assure_one < 0) then
                    Raise_application_error(-20041, 'computeAssure error');
                end if;
                --保证金应加上担保金
                v_Margin_one := v_Margin_one + v_Assure_one;
                    v_Margin:=v_Margin + v_Margin_one;
                    v_Assure:=v_Assure + v_Assure_one;
                  --计算应退持仓金额，不包括抵顶的
                  v_HoldFunds := v_HoldFunds + v_tradedAmount*v_price*v_ContractFactor;
                  end if;
                  --2、计算持仓明细中交收的抵顶数量
          if(v_GageQty > 0) then
                    if(v_GageQty<=v_unCloseQtyGage) then
                        v_tradedAmountGage:=v_GageQty;
                    else
                        v_tradedAmountGage:=v_unCloseQtyGage;
                    end if;
                  end if;
              --如果是半抵顶模式则交易商持仓金额要退抵顶的
              if(v_GageMode=1) then
                v_HoldFunds := v_HoldFunds + v_tradedAmountGage*v_price*v_ContractFactor;
              end if;
                  --二级客户合计金额，包括抵顶的
                  v_CustomerHoldFunds := v_CustomerHoldFunds + (v_tradedAmount+v_tradedAmountGage)*v_price*v_ContractFactor;
                --3、计算交收款项

         --根据市场参数设置来决定是否收取交收保证金 ---add by zhangjian start
         if(v_IsChargeMargin = 1 )then  --如果收取保证金
          --计算交收保证金
          v_SettlementMargin_one := FN_T_ComputeSettleMargin(v_FirmID,v_CommodityID,v_BS_Flag,v_tradedAmount+v_tradedAmountGage,v_settlePrice);
            if(v_SettlementMargin_one < 0) then
                Raise_application_error(-20042, 'ComputeSettleMargin error');
            end if;
         end if;   --add by zhangjian end


          --计算买方交收货款，提前交收不用收交收保证金
          if(v_BS_Flag = 1) then
                v_Payout_one := FN_T_ComputePayout(v_FirmID,v_CommodityID,v_BS_Flag,v_tradedAmount+v_tradedAmountGage,v_settlePrice);
                  if(v_Payout_one < 0) then
                      Raise_application_error(-20043, 'computePayout error');
                  end if;
          end if;
          --计算交收手续费
          v_Fee_one := FN_T_ComputeSettleFee(v_FirmID,v_CommodityID,v_BS_Flag,v_tradedAmount+v_tradedAmountGage,v_settlePrice);
                if(v_Fee_one < 0) then
                  Raise_application_error(-20031, 'computeFee error');
                end if;
                --计算税前交收盈亏
                if(v_BS_Flag = 1) then
                    v_closeFL_one := (v_tradedAmount+v_tradedAmountGage)*(v_settlePrice-v_price)*v_contractFactor; --税前盈亏
                else
                    v_closeFL_one := (v_tradedAmount+v_tradedAmountGage)*(v_price-v_settlePrice)*v_contractFactor; --税前盈亏
                end if;
                --计算交收增值税,v_AddedTaxFactor增值税系数=AddedTax/(1+AddedTax)
              --  v_CloseAddedTax_one := round(v_closeFL_one*v_AddedTaxFactor,2);   xief 20150811
                  v_CloseAddedTax_one := 0;
                --计算税后交收盈亏
                --v_closeFL_one := v_closeFL_one - v_CloseAddedTax_one; --税后盈亏   duanbaodi 20150730   xief 20150811
               /* if(v_TaxInclusive = 1) then
                     --不含税 扣除增值税  duanbaodi 20150730
                     v_closeFL_one := v_closeFL_one - v_CloseAddedTax_one;
                end if ;
                */

          --累计金额
              v_Payout := v_Payout + v_Payout_one;
              v_Fee := v_Fee + v_Fee_one;
          v_CloseFL:=v_CloseFL + v_closeFL_one;  --税后盈亏合计
          v_CloseAddedTax:=v_CloseAddedTax + v_CloseAddedTax_one;  --交收增值税合计
          v_SettlementMargin:=v_SettlementMargin + v_SettlementMargin_one; --交收保证金合计 add by zhangjian
              --将当前持仓记录和交收费用插入交收持仓明细表，并更新持仓数量和抵顶数量为实际交收的数量
          select SEQ_T_SettleHoldPosition.nextval into v_ID from dual;
          --按字段名插入交收持仓明细表
              insert into t_settleholdposition
            (id, settleprocessdate, a_holdno, a_tradeno, customerid, commodityid, bs_flag, price, holdqty, openqty, holdtime, holdmargin, firmid, gageqty, holdassure, floatingloss, settlemargin, payout, settlefee, settle_pl, settleaddedtax, settleprice, settletype, holdtype, atcleardate, MatchQuantity ,happenMATCHQTY)
              select v_ID,v_TradeDate,a_holdno, a_tradeno, customerid, commodityid, bs_flag, price, holdqty, openqty, holdtime, holdmargin, firmid, gageqty, holdassure, floatingloss,v_SettlementMargin_one,v_Payout_one,v_Fee_one,v_closeFL_one,v_CloseAddedTax_one,v_settlePrice,2, holdtype, atcleardate, holdqty, v_tradedAmount
              from t_holdposition
              where A_HoldNo=v_A_HoldNo;
           --添加配对交收持仓明细表关联关系  add by zhangjian 2011年12月15日13:16:45 start

           insert into T_MatchSettleholdRelevance values (p_ApplyID,v_ID,v_tradedAmount,v_settlePrice,v_Payout_one,v_SettlementMargin_one);

           --end  by zhangjian 2011年12月15日13:16:55

              update T_SettleHoldPosition set HoldQty=v_tradedAmount,GageQty=v_tradedAmountGage where ID=v_ID;

                  --更新持仓记录
                    update T_holdposition
                    set holdqty = holdqty - v_tradedAmount,HoldMargin=HoldMargin-v_Margin_one,HoldAssure=HoldAssure-v_Assure_one,GageQty = GageQty - v_tradedAmountGage
                    where a_holdno = v_a_holdno;

                  v_unCloseQty:=v_unCloseQty - v_tradedAmount;
                  v_unCloseQtyGage:=v_unCloseQtyGage - v_tradedAmountGage;
                  exit when v_unCloseQty=0 and v_unCloseQtyGage=0;
                end if;

       end loop;
       close v_HoldPosition;
      if(v_unCloseQty>0) then --交收持仓数量大于可交收持仓数量
          rollback;
          return -3;
      end if;
      if(v_unCloseQtyGage>0) then --交收抵顶数量大于可抵顶数量
          rollback;
          return -4;
      end if;
    --减少交易客户，交易商的持仓合计信息2009-10-15
        v_num := FN_T_SubHoldSum(p_HoldQty,p_GageQty,v_Margin,v_Assure,v_CommodityID,v_ContractFactor,v_BS_Flag,v_FirmID,v_HoldFunds,v_CustomerID,v_CustomerHoldFunds,v_GageMode,p_HoldQty);

    --写合计的流水
        --扣除交收货款和交收保证金,同时退保证金和担保金 --modify by zhangjian
        update T_Firm
        set runtimemargin = runtimemargin - v_Margin,
            RuntimeAssure = RuntimeAssure - v_Assure,
            RuntimeSettleMargin = RuntimeSettleMargin + v_SettlementMargin
        where Firmid = v_FirmID;
        --更新冻结资金，释放个人部分的保证金
    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(v_FirmID,-(v_Margin-v_Assure),'15');
        --插入扣除交收货款资金流水
    v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15008',v_Payout,null,v_CommodityID,null,null);
        --写交收保证金流水 add by zhangjian
        if(v_IsChargeMargin = 1 )then
    v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15013',v_SettlementMargin,null,v_CommodityID,null,null);
        end if;
        --更新资金,同时插入交收手续费资金流水
    --如果手续费低于最低交收手续费，则按最低交收手续费收取，并且将此交易商最后一笔明细的手续费更新成加上差额的手续费
    if(v_ID is not null) then  --表示必须是有持仓做了交收，因为不判断当没有持仓时也会收取最低交收手续费的
        if(v_Fee >= v_LowestSettleFee) then
            v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15010',v_Fee,null,v_CommodityID,null,null);
      else
          v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15010',v_LowestSettleFee,null,v_CommodityID,null,null);
            update T_SettleHoldPosition
            set SettleFee=SettleFee+(v_LowestSettleFee-v_Fee)
            where ID=v_ID;
        end if;
      end if;
    --更新资金余额，并写付交收盈利或收交收亏损流水
    --商品含不含税，在交易过程中均不扣税
   /* if(v_CloseFL >= 0) then
      v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15011',v_CloseFL,null,v_CommodityID,v_CloseAddedTax,null);
    else
      v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15012',-v_CloseFL,null,v_CommodityID,-v_CloseAddedTax,null);
    end if;*/
    ------xief  20150811
    if(v_CloseFL >= 0) then
      v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15011',v_CloseFL,null,v_CommodityID,null,null);
    else
      v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15012',-v_CloseFL,null,v_CommodityID,null,null);
    end if;

    --存储合并项  add  by  zhangjian  　2011年12月26日 14:52:34

    if(v_aheadSettlePriceType=0)then  --如果按订立价交收则在此处交收配对数据的插入
       select sum(m.quantity*m.price*v_ContractFactor)
       into v_totalRef
       from T_MatchSettleholdRelevance m, T_SettleHoldPosition s
       where m.settleid = s.id
       and matchid = p_ApplyID
       and bs_flag = p_BS_Flag;
       if(p_BS_Flag=1)then --如果是买 则插入新的交收配对数据

           --2.5 插入交收配对表
         insert into T_SettleMatch (MatchID,CommodityID,ContractFactor,Quantity,HL_Amount,Status,Result,SettleType,FirmID_B,BuyPrice,BuyPayout_Ref,BuyPayout,BuyMargin,TakePenalty_B,PayPenalty_B,SettlePL_B,
               FirmID_S,SellPrice,SellIncome_Ref,SellIncome,SellMargin,TakePenalty_S,PayPenalty_S,SettlePL_S,CreateTime,ModifyTime,SettleDate)
               values (p_ApplyID,p_CommodityID,v_ContractFactor,(p_HoldQty+p_GageQty),0,0,1,2,v_FirmID,v_settlePrice,v_totalRef,v_Payout,v_settlementmargin,0,0,0,
               v_FirmID,v_settlePrice,v_totalRef,0,v_SettlementMargin,0,0,0,sysdate,sysdate,v_TradeDate);
       elsif(p_BS_Flag=2)then  --如果是卖方则更新交收配对数据表
       update T_SettleMatch set FirmID_S=v_FirmID , SellPrice=v_settlePrice,SellIncome_Ref=v_totalRef,SellMargin=v_settlementmargin where MatchID=p_ApplyID;
       end if;
    elsif(v_aheadSettlePriceType=1) then
       if(p_BS_Flag=2)then --如果是卖 则插入新的交收配对数据
           --1、计算买方交收货款
           select FirmID into v_bFirmID from T_Customer where CustomerID=p_OCustomerID;--找出买方交易商ID
           v_bPayout := FN_T_ComputePayout(v_bFirmID,p_CommodityID,1,(p_HoldQty+p_GageQty),p_Price);
           if(v_bPayout < 0) then
              Raise_application_error(-20043, 'computePayout error');
           end if;
           --2、插入交收配对表，提前交收不计算交收保证金
           --2.提前交收根据市场参数设定来判断是否收取保证金 -- modify by zhangjian
           select ASMarginType into v_IsChargeMargin from t_a_market;
           if(v_IsChargeMargin = 1 )then  --如果收取保证金
              --计算买方交收保证金
              v_SettlementMargin_B := FN_T_ComputeSettleMargin(v_bFirmID,p_CommodityID,1,p_HoldQty+p_GageQty,p_Price);
              if(v_SettlementMargin_B < 0) then
                 Raise_application_error(-20042, 'ComputeSettleMargin error');
              end if;
              --计算卖方交收保证金
             /* v_SettlementMargin_S := FN_T_ComputeSettleMargin(v_FirmID,p_CommodityID,2,(p_HoldQty+p_GageQty),p_Price);
              if(v_SettlementMargin_S < 0) then
                  Raise_application_error(-20042, 'ComputeSettleMargin error');
              end if;*/
           end if;   --add by zhangjian end

           --2.5 插入交收配对表
           select ContractFactor into v_ContractFactor from T_Commodity where CommodityID=p_CommodityID;
           insert into T_SettleMatch (MatchID,CommodityID,ContractFactor,Quantity,HL_Amount,Status,Result,SettleType,FirmID_B,BuyPrice,BuyPayout_Ref,BuyPayout,BuyMargin,TakePenalty_B,PayPenalty_B,SettlePL_B,
           FirmID_S,SellPrice,SellIncome_Ref,SellIncome,SellMargin,TakePenalty_S,PayPenalty_S,SettlePL_S,CreateTime,ModifyTime,SettleDate)
           values (p_ApplyID,p_CommodityID,v_ContractFactor,(p_HoldQty+p_GageQty),0,0,1,2,v_bFirmID,p_Price,(p_HoldQty+p_GageQty)*p_Price*v_ContractFactor,v_bPayout,v_SettlementMargin_B,0,0,0,
           v_FirmID,p_Price,(p_HoldQty+p_GageQty)*p_Price*v_ContractFactor,0,v_SettlementMargin,0,0,0,sysdate,sysdate,v_TradeDate);
       end if;
    end if;
    return 1;

end;
/

prompt
prompt Creating function FN_T_AHEADSETTLEQTY
prompt =====================================
prompt
create or replace function FN_T_AheadSettleQty(
    p_ApplyID       varchar2,     --申请单号
    p_CommodityID varchar2, --商品代码
    --p_BillID         varchar2, --仓单号-- mod by yukx 20100428
    p_Quantity      number,   --仓单数量，即交收数量，包括抵顶的
   p_Price         number,  --交收价
  p_sCustomerID    varchar2,     --卖方交易客户ID
  p_sGageQty      number default 0,    --其中卖交收抵顶数量
    p_bCustomerID    varchar2,     --买方交易客户ID
   p_bGageQty      number default 0,   --其中买交收抵顶数量，业务上不存在此参数，实现上保留
    p_Modifier      varchar2,   --创建人
  p_ApplyType     number    --申请种类: 1:提前交收  mod by yukx /*3：已有仓单转提前交收;6：提前交收*/
  --p_ValidID       number    --生效仓单号，只有申请种类为3：已有仓单转提前交收才需要
) return number
/****
 * 提前交收
 * 返回值
 * 1 成功
 * 2 已处理过
 * -1  可交收买持仓数量不足
 * -2  可交收买抵顶数量不足
 * -3  交收买持仓数量大于可交收买持仓数量
 * -4  交收买抵顶数量大于可买抵顶数量
 * -11  可交收卖持仓数量不足
 * -12  可交收卖抵顶数量不足
 * -13  交收卖持仓数量大于可交收卖持仓数量
 * -14  交收卖抵顶数量大于可卖抵顶数量
 * -100 其它错误
****/
as
   v_version varchar2(10):='1.0.0.9';
   v_FirmID varchar2(32);      --卖方交易商ID
  v_bFirmID varchar2(32);      --买方交易商ID
    bRet            number(5);
    sRet            number(5);
    v_FL_ret            timestamp;
    v_num            number(10);
    v_errorcode      number;
    v_errormsg       varchar2(200);
    v_Payout         number(15,2):=0;
    v_ContractFactor T_Commodity.ContractFactor%type;
  v_IsChargeMargin       number(2):=0;    --是否收取保证金 -add by zhangjian
  v_SettlementMargin_S     number(15,2):=0; --卖方交收保证金
  v_SettlementMargin_B      number(15,2):=0; --买方交收保证金
  v_settlePirce_B    number(15,6):=0;--买方交收价格
  v_settlePirce_S    number(15,6):=0;--卖方交收价格
  v_alreadyAheadSettleQty number(15):=0;  --已存在的提前交收申请数量
  v_holdPrice  number(15):=0;--每一笔持仓明细中的订立价
  v_holdQty  number(15):=0;--每一笔持仓明细中的持仓数量
  v_HoldSum number(15):=0;--累积提前交收申请数量
  v_tempQty number(15):=0;--临时变量数量
  v_holdPirceSum number(15):=0;--本次需要冻结持仓明细订立价格累加
  v_priceType number(2);--交收价类型  0:按订立价交收  1:按自主价交收 add by zhangjian
  v_sql varchar2(500);
  v_orderby  varchar2(100);
  v_CloseAlgr number;
  type cur_T_HoldPosition is ref cursor;
  v_HoldPosition cur_T_HoldPosition;
  v_settleMachNumber number(15);
  v_aheadSettlePriceType number(2);--提前交收价格类型 0:按订立价交收 1：按自主价交收

begin
    /* -- mod by yukx 20100428
    select count(*) into v_num from T_ValidBill where BillID = p_BillID and Status=1 and BillType=4;
    if(v_num >0) then
        rollback;
        return 2;  --已处理过
    end if;
    */
select aheadSettlePriceType into v_aheadSettlePriceType  from t_commodity where commodityid=p_CommodityID;
  --这里应该调用FN_T_AheadSettleOneQty，以前调用FN_T_AheadSettleOne
  --增加传递 提前交收申请单号。用来当提前交收价格类型为 按订立价交收的时候更新提前交收价格
   bRet := FN_T_AheadSettleOneQty(p_ApplyID,p_CommodityID,p_Price,1,p_bCustomerID,p_sCustomerID,p_Quantity-p_bGageQty,p_bGageQty); --买
   if(bRet = 1) then
      sRet := FN_T_AheadSettleOneQty(p_ApplyID,p_CommodityID,p_Price,2,p_sCustomerID,p_bCustomerID,p_Quantity-p_sGageQty,p_sGageQty);  --卖

      if(sRet = 1) then
          select FirmID into v_FirmID from T_Customer where CustomerID=p_sCustomerID;--找出卖方交易商ID
          --3有抵顶交收则增加生效仓单抵顶表的数量
          update T_ValidGageBill set Quantity=Quantity+p_sGageQty where FirmID=v_FirmID and commodityId=p_CommodityID;
          commit;
          --提交后计算买卖双方浮亏
          v_FL_ret := FN_T_UpdateFloatingLoss(null,null,null);

          return 1;
       elsif(sRet = -1) then
         rollback;
         return -11;
      elsif(sRet = -2) then
         rollback;
         return -12;
      elsif(sRet = -3) then
         rollback;
         return -13;
      elsif(sRet = -4) then
         rollback;
         return -14;
      else
         rollback;
         return -100;
      end if;
   else
      rollback;
      return bRet;
   end if;
exception
    when OTHERS then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_AheadSettleQty',v_errorcode,v_errormsg);
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_T_D_COMPUTEDELAYDAYS
prompt =========================================
prompt
create or replace function FN_T_D_ComputeDelayDays return number
/****
 * 计算延期补偿费的天数
 * 返回计算延期补偿费的天数
****/
as
	v_version varchar2(10):='1.0.2.3';
	v_TradeDate date;
    v_Week        varchar2(30);   --非交易的星期几
    v_Day    varchar2(1024);   --非交易的日期
    v_destWeek    varchar2(10);   --下个日期对应的星期几
    v_pos      number(15,2):=0;   --位置
    v_bLoop      boolean;   --是否需要循环标志
    v_Days       number(10); --延期的天数
begin
	--1、获取结算日期
	select TradeDate into v_TradeDate from T_SystemStatus;
	--2、查询非交易日，未设置非交易日时返回1,2010-03-29  by chenxc
	begin
		select Week,Day
		into v_Week,v_Day
	    from T_A_NotTradeDay;
	exception
	    when NO_DATA_FOUND then
	        return 1;
	end;
    if(v_Week is null and v_Day is null) then
    	return 1;
    end if;
	--3、推算延期天数
	v_Days := 1;
	v_bLoop := true;
    while v_bLoop loop
    	<<top>>
    	select ',' || TO_CHAR(v_TradeDate+v_Days,'D') || ',' into v_destWeek  from dual;
    	if(v_Week is not null) then
    		select INSTR(',' || v_Week || ',',v_destWeek,1,1) into v_pos  from dual;
    		if(v_pos > 0) then
    			v_bLoop := true;
    			v_Days := v_Days+1;
    			goto top;
    		else
    			v_bLoop := false;
    		end if;
    	end if;
    	if(v_Day is not null) then
    		select INSTR(',' || v_Day || ',',to_char(v_TradeDate+v_Days,'yyyy-MM-dd'),1,1) into v_pos  from dual;
    		if(v_pos > 0) then
    			v_bLoop := true;
    			v_Days := v_Days+1;
    			goto top;
    		else
    			v_bLoop := false;
    		end if;
    	end if;
    end loop;
	--4、返回延期天数
    return v_Days;
end;
/

prompt
prompt Creating function FN_T_D_PAYDELAYFUND
prompt =====================================
prompt
create or replace function FN_T_D_PayDelayFund(
	p_CommodityID    varchar2, --商品代码
    p_DelayFunds     number   --延期补偿费
) return number
/****
 * 付交易商延期补偿费
 * 返回付交易商的延期补偿费
****/
as
	v_version varchar2(10):='1.0.2.2';
    v_OrderQtySum        number(10);   --总量
    v_DelayFundOneInit    number(15,4);   --某交易商应付延期费，未化零
    v_DelayFundOne    number(15,2);   --某交易商应付延期费，化零精确到分
    v_DelayFunds      number(15,2):=0;   --延期补偿费合计
    v_Balance      number(15,2);   --可用资金
    v_OrderQtyOne       number(10); --交易商量
begin
	--1、计算应得补偿费的总数量
	select nvl(sum(DiffQty),0)
	into v_OrderQtySum
    from
    (
    	(select nvl(sum(Quantity-TradeQty),0) DiffQty from T_DelayOrders where DelayOrderType=1 and Status in(5,6) and WithdrawType=4 and CommodityID=p_CommodityID) union all
        (select nvl(sum(TradeQty),0) DiffQty from T_DelayOrders where DelayOrderType=2 and CommodityID=p_CommodityID)
    );

	--2、申报后未能交收的交易商和参与中立仓成交的交易商按量平均分配总补偿费
    for cur_DelayFund in(
		select FirmID,nvl(sum(DiffQty),0) DiffQty
		from
		(
			(select FirmID,nvl(sum(Quantity-TradeQty),0) DiffQty from T_DelayOrders where DelayOrderType=1 and Status in(5,6) and WithdrawType=4 and CommodityID=p_CommodityID group by FirmID) union all
			(select FirmID,nvl(sum(TradeQty),0) DiffQty from T_DelayOrders where DelayOrderType=2 and CommodityID=p_CommodityID group by FirmID)
		)
		group by FirmID
    )
    loop
    	v_OrderQtyOne := cur_DelayFund.DiffQty;
		if(v_OrderQtyOne > 0) then
			--某交易商应补补偿金＝总补偿费÷总数量×此交易商应得数量,采用小数化零的原则，精确到分
			v_DelayFundOneInit := p_DelayFunds/v_OrderQtySum*v_OrderQtyOne;
			v_DelayFundOne := trunc(v_DelayFundOneInit,2);
	        --付交易商延期费 ，并写流水
    		v_Balance := FN_F_UpdateFundsFull(cur_DelayFund.FirmID,'15021',v_DelayFundOne,null,p_CommodityID,null,null);
    		v_DelayFunds := v_DelayFunds + v_DelayFundOne;
		end if;
    end loop;
	--3、返回总补的延期费
    return v_DelayFunds;
end;
/

prompt
prompt Creating function FN_T_D_CHARGEDELAYFUND
prompt ========================================
prompt
create or replace function FN_T_D_ChargeDelayFund(
	p_CommodityID    varchar2, --商品代码
	p_BS_Flag        number, --收取延期费方向；1买2卖
    p_DelayFunds     number   --延期补偿费
) return number
/****
 * 收取交易商延期补偿费
 * 返回收取的交易商延期补偿费
 * 根据配置，修改收取交易商补偿费时是按净订货量还是单边订货量（不包含中立仓的数量）来计算 by chenxc 2011-09-21
****/
as
	v_version varchar2(10):='1.0.2.2';
	v_TradeDate date;
    v_NotOrderQtySum        number(10);   --未申报订货总量
    v_DelayFundOneInit    number(15,4);   --某交易商应缴延期费，未进位
    v_DelayFundOne    number(15,2);   --某交易商应缴延期费，进位精确到分
    v_DelayFunds      number(15,2):=0;   --延期补偿费合计
    v_Balance      number(15,2);   --可用资金
    v_NotOrderQtyOne       number(10); --交易商未申报订货量
	v_ChargeDelayFeeType       number(2); --收取延期补偿金类型
begin
	--1、获取结算日期
	select TradeDate into v_TradeDate from T_SystemStatus;
	--收取延期补偿金类型字段，0按净订货量收取（默认）；1按单边订货总量收取
	select ChargeDelayFeeType into v_ChargeDelayFeeType from T_A_Market;
	--2、查询未申报订货总量
	--根据配置，修改收取交易商补偿费时是按净订货量还是单边订货量（不包含中立仓的数量）来计算 by chenxc 2011-09-21
	select decode(v_ChargeDelayFeeType,1,
		nvl(sum(
			decode(p_BS_Flag,1,BuyCleanQty,SellCleanQty)),0)
		,
		nvl(sum(
			decode(p_BS_Flag,1,
			case when BuyCleanQty-SellCleanQty<=0 then 0 else BuyCleanQty-SellCleanQty end,
			case when SellCleanQty-BuyCleanQty<=0 then 0 else SellCleanQty-BuyCleanQty end
			)
		),0))
	into v_NotOrderQtySum
	from
	(
		select (a.BuyQty-nvl(b.BuyNeutralQty,0)-nvl(c.BuyNotTradeQty,0)) BuyCleanQty,(a.SellQty-nvl(b.SellNeutralQty,0)-nvl(c.SellNotTradeQty,0)) SellCleanQty
		from
			(select FirmID,nvl(sum(decode(BS_Flag,1,HoldQty+GageQty,0)),0) BuyQty,nvl(sum(decode(BS_Flag,2,HoldQty+GageQty,0)),0) SellQty
			from T_FirmHoldSum
			where CommodityID=p_CommodityID
			group by FirmID) a,
			(select FirmID,nvl(sum(decode(BS_Flag,1,HoldQty+GageQty,0)),0) BuyNeutralQty,nvl(sum(decode(BS_Flag,2,HoldQty+GageQty,0)),0) SellNeutralQty
			from T_HoldPosition
			where CommodityID=p_CommodityID and AtClearDate=v_TradeDate and HoldType=2
			group by FirmID) b,
			(select FirmID,nvl(sum(decode(BS_Flag,1,Quantity-TradeQty,0)),0) BuyNotTradeQty,nvl(sum(decode(BS_Flag,2,Quantity-TradeQty,0)),0) SellNotTradeQty
			from T_DelayOrders
			where CommodityID=p_CommodityID and DelayOrderType=1 and Status in(5,6) and WithdrawType=4
			group by FirmID) c
		where a.FirmID=b.FirmID(+) and a.FirmID=c.FirmID(+)
	);
	--2.5、更新延期行情的净订货量
	update T_DelayQuotation set DelayCleanHoldQty=v_NotOrderQtySum where CommodityID=p_CommodityID;
	--3、计算某交易商应缴补偿金＝总补偿费÷未申报订货总量×此交易商未申报订货量，采用小数进整的原则，精确到分
    for cur_DelayFund in(
		select a.FirmID,(a.BuyQty-nvl(b.BuyNeutralQty,0)-nvl(c.BuyNotTradeQty,0)) BuyCleanQty,(a.SellQty-nvl(b.SellNeutralQty,0)-nvl(c.SellNotTradeQty,0)) SellCleanQty
		from
			(select FirmID,nvl(sum(decode(BS_Flag,1,HoldQty+GageQty,0)),0) BuyQty,nvl(sum(decode(BS_Flag,2,HoldQty+GageQty,0)),0) SellQty
			from T_FirmHoldSum
			where CommodityID=p_CommodityID
			group by FirmID) a,
			(select FirmID,nvl(sum(decode(BS_Flag,1,HoldQty+GageQty,0)),0) BuyNeutralQty,nvl(sum(decode(BS_Flag,2,HoldQty+GageQty,0)),0) SellNeutralQty
			from T_HoldPosition
			where CommodityID=p_CommodityID and AtClearDate=v_TradeDate and HoldType=2
			group by FirmID) b,
			(select FirmID,nvl(sum(decode(BS_Flag,1,Quantity-TradeQty,0)),0) BuyNotTradeQty,nvl(sum(decode(BS_Flag,2,Quantity-TradeQty,0)),0) SellNotTradeQty
			from T_DelayOrders
			where CommodityID=p_CommodityID and DelayOrderType=1 and Status in(5,6) and WithdrawType=4
			group by FirmID) c
		where a.FirmID=b.FirmID(+) and a.FirmID=c.FirmID(+)
    )
    loop
    	--根据配置，修改收取交易商补偿费时是按净订货量还是单边订货量（不包含中立仓的数量）来计算 by chenxc 2011-09-21
		if(v_ChargeDelayFeeType = 1) then
	    	if(p_BS_Flag = 1) then
				v_NotOrderQtyOne := cur_DelayFund.BuyCleanQty;
			else
				v_NotOrderQtyOne := cur_DelayFund.SellCleanQty;
			end if;
		else
	    	if(p_BS_Flag = 1) then
				if(cur_DelayFund.BuyCleanQty-cur_DelayFund.SellCleanQty<=0) then
					v_NotOrderQtyOne := 0;
				else
					v_NotOrderQtyOne := cur_DelayFund.BuyCleanQty-cur_DelayFund.SellCleanQty;
				end if;
			else
				if(cur_DelayFund.SellCleanQty-cur_DelayFund.BuyCleanQty<=0) then
					v_NotOrderQtyOne := 0;
				else
					v_NotOrderQtyOne := cur_DelayFund.SellCleanQty-cur_DelayFund.BuyCleanQty;
				end if;
			end if;
		end if;
		if(v_NotOrderQtyOne > 0) then
			--某交易商应缴补偿金＝总补偿费÷未申报订货总量×此交易商未申报订货量,采用小数进整的原则，精确到分
			v_DelayFundOneInit := p_DelayFunds/v_NotOrderQtySum*v_NotOrderQtyOne;
			v_DelayFundOne := trunc(v_DelayFundOneInit,2);
			if(v_DelayFundOneInit > v_DelayFundOne) then
				v_DelayFundOne := v_DelayFundOne + 0.01;
			end if;
	        --收交易商延期费 ，并写流水
    		v_Balance := FN_F_UpdateFundsFull(cur_DelayFund.FirmID,'15020',v_DelayFundOne,null,p_CommodityID,null,null);
    		v_DelayFunds := v_DelayFunds + v_DelayFundOne;
		end if;
    end loop;
	--4、返回总收的延期费
    return v_DelayFunds;
end;
/

prompt
prompt Creating function FN_T_D_CLOSEPROCESS
prompt =====================================
prompt
create or replace function FN_T_D_CloseProcess return number
/****
 * 延期交易结算处理
 * 返回值
 * 1  成功提交
 * 修改延期补偿费按买卖收取 2011-09-20 by chenxc
****/
as
	v_version varchar2(10):='1.0.2.2';
    v_DelayRecoupRate        number(7,5);   --买方延期补偿比例
	v_DelayRecoupRate_S        number(7,5);   --卖方延期补偿比例,2011-09-05 by chenxc
    v_ContractFactor    number(12,2);   --合约因子
    v_DelayFeeWay    number(2);   --延期费收取方式
    v_DelayFunds      number(20,6):=0;   --延期补偿费
    v_Price      number(10,2);   --行情结算价
    v_ChargeDelayFund  number(15,2); --收延期费
    v_PayDelayFund       number(15,2); --付延期费
    v_DiffFund      number(15,2); --风险准备金
    v_Balance      number(15,2); --可用资金
    v_TradeDate date;
    v_DelayDays    number(5);   --延期天数
    v_errorcode number;
    v_errormsg  varchar2(200);
    v_StoreFunds number(20,6):=0;   --仓储补偿费
    v_StoreRecoupRate number(7,5);   --仓储补偿比例
begin
	--0、计算延期天数
	v_DelayDays := FN_T_D_ComputeDelayDays();
	--1、轮询商品计算延期补偿费＝交收申报差×合约因子×当日结算价×补偿比率
    for delayOrder in(select CommodityID,max(BS_Flag) BS_Flag,nvl(sum(DiffQty),0) DiffQty
                      from ((select CommodityID,max(decode(BS_Flag,1,2,1)) BS_Flag,nvl(sum(Quantity-TradeQty),0) DiffQty from T_DelayOrders where DelayOrderType=1 and Status in(5,6) and WithdrawType=4 group by CommodityID) union all
                           (select  CommodityID,max(BS_Flag) BS_Flag,nvl(sum(TradeQty),0) DiffQty from T_DelayOrders where DelayOrderType=2  group by CommodityID))
                      group by CommodityID)
    loop
    	select StoreRecoupRate,DelayRecoupRate,DelayRecoupRate_S,ContractFactor,DelayFeeWay into v_StoreRecoupRate, v_DelayRecoupRate,v_DelayRecoupRate_S,v_ContractFactor,v_DelayFeeWay from T_Commodity where CommodityID = delayOrder.CommodityID;
    	select Price into v_Price from T_Quotation where CommodityID = delayOrder.CommodityID;
    	if(v_DelayFeeWay = 1) then  --按自然日逐日收取
			--如果收买方的补偿费，则把卖方补偿比率赋给买方补偿比率，delayOrder.BS_Flag是指收交易商补偿费的方向，而不是付给交易商补偿费方向,2011-09-05 by chenxc
			if(delayOrder.BS_Flag = 1) then
				v_DelayRecoupRate := v_DelayRecoupRate_S;
			end if;
    		v_DelayFunds := delayOrder.DiffQty * v_ContractFactor * v_Price * v_DelayRecoupRate * v_DelayDays;
    		-- 增加仓储补偿费功能,当卖方大于买方数量时才收取即延期费方向等于买方 2011-2-23 by feijl
			if (delayOrder.BS_Flag = 1) then
			    v_StoreFunds := delayOrder.DiffQty * v_ContractFactor * v_StoreRecoupRate * v_DelayDays;
			else
			    v_StoreFunds := 0;
			end if;
			--2、收延期费
    		v_ChargeDelayFund := FN_T_D_ChargeDelayFund(delayOrder.CommodityID,delayOrder.BS_Flag,v_DelayFunds+v_StoreFunds);
    		--3、付延期费
    		v_PayDelayFund := FN_T_D_PayDelayFund(delayOrder.CommodityID,v_DelayFunds+v_StoreFunds);
    		/*
    		if(v_ChargeDelayFund < v_PayDelayFund) then
    			rollback;
    			return -1;--延期费收取不足
    		end if;
    		--4、多的钱计入风险准备金，改在财务中做
    		v_DiffFund := v_ChargeDelayFund - v_PayDelayFund;
    		if(v_DiffFund > 0) then
		        --付风险金 ，并写流水
	    		v_Balance := FN_F_UpdateFundsFull(null,'15022',v_DiffFund,null,delayOrder.CommodityID,null,null);
    		end if;
    		*/
    	end if;

    end loop;

	--5、获取结算日期
	select TradeDate into v_TradeDate from T_SystemStatus;
    --6、导入历史延期委托表并删除当日数据
    insert into T_H_DelayOrders select v_TradeDate,a.* from T_DelayOrders a;
    delete from T_DelayOrders;
    --7、导入历史延期成交表并删除当日数据
    insert into T_H_DelayTrade select v_TradeDate,a.* from T_DelayTrade a;
    delete from T_DelayTrade;
    --8、删除历史当日数据并导入历史延期行情
	delete from T_H_DelayQuotation where ClearDate=v_TradeDate;
    insert into T_H_DelayQuotation select v_TradeDate,a.* from T_DelayQuotation a;

    return 1;

end;
/

prompt
prompt Creating function FN_T_RECOMPUTEFLOATLOSS
prompt =========================================
prompt
create or replace function FN_T_ReComputeFloatLoss
return number
/****
 * 重算临时浮亏，但并不更新交易商冻结资金
 * 注意不要提交commit，因为闭市处理函数要调用它；
 * 返回值
 * 1 成功
 * -100 其它错误
****/
as
	v_version varchar2(10):='1.0.0.10';
	v_FloatingLossComputeType number(2);
	v_FloatingProfitSubTax number(1);
	v_F_FrozenFunds number(15,2);
	v_GageMode number(2);--抵顶模式，分0全抵顶和1半抵顶，半抵顶时要计算浮亏，2009-10-14
begin
	    --获取浮亏计算类型，盈亏是否扣税
	    select FloatingLossComputeType,FloatingProfitSubTax,GageMode into v_FloatingLossComputeType,v_FloatingProfitSubTax,v_GageMode from T_A_Market;
		--更新持仓明细上的浮动盈亏
        update
        (select /*+ BYPASS_UJVC */a.Price HoldPrice,HoldQty,GageQty,bs_flag,floatingloss,b.AddedTax,b.ContractFactor,b.price from T_HoldPosition a,
            (select c.AddedTax,c.ContractFactor,c.commodityid,q.price from T_Commodity c,T_Quotation q where c.CommodityID=q.CommodityID) b
        where a.commodityid=b.commodityid)
        --set floatingloss = decode(bs_flag,1,(Price-HoldPrice),(HoldPrice-Price))*HoldQty*ContractFactor;
        set floatingloss = FN_T_ComputeFPSubTax(HoldPrice,Price,HoldQty+decode(v_GageMode,1,GageQty,0),ContractFactor,bs_flag,AddedTax,v_FloatingProfitSubTax);

		--更新特殊商品持仓明细上的浮动盈亏
        update
        (
         select /*+ BYPASS_UJVC */floatingloss
         from T_HoldPosition a,T_Commodity b
         where a.bs_flag=1 and a.commodityid=b.commodityid
         and (b.marginrate_b=-1 or (b.MarginAlgr=1 and b.MarginRate_B >= 1))
        )
        set floatingloss = 0;
        update
        (
         select /*+ BYPASS_UJVC */floatingloss
         from T_HoldPosition a,T_Commodity b
         where a.bs_flag=2 and a.commodityid=b.commodityid
         and (b.marginrate_s=-1 or (b.MarginAlgr=1 and b.MarginRate_S >= 1))
        )
        set floatingloss = 0;

		--更新特殊交易商持仓明细上的浮动盈亏
        update
        (
         select /*+ BYPASS_UJVC */floatingloss
         from T_HoldPosition a,T_A_FirmMargin b
         where a.bs_flag=1 and a.commodityid=b.commodityid and a.firmid=b.firmid
         and (b.marginrate_b=-1 or (b.MarginAlgr=1 and b.MarginRate_B >= 1))
        )
        set floatingloss = 0;
        update
        (
         select /*+ BYPASS_UJVC */floatingloss
         from T_HoldPosition a,T_A_FirmMargin b
         where a.bs_flag=2 and a.commodityid=b.commodityid and a.firmid=b.firmid
         and (b.marginrate_s=-1 or (b.MarginAlgr=1 and b.MarginRate_S >= 1))
        )
        set floatingloss = 0;

      --更新交易客户持仓合计中的浮动盈亏
	  update T_CustomerHoldSum a
      set FloatingLoss=
      (
          select sum(x.FloatingLoss)
          from T_HoldPosition x
          where x.CustomerID = a.CustomerID and x.CommodityID = a.CommodityID and x.BS_Flag = a.BS_Flag
          group by x.CustomerID,x.CommodityID,x.BS_Flag
      );
      --更新交易商持仓合计中的浮动盈亏
	  update T_FirmHoldSum a
      set FloatingLoss=
      (
          select sum(x.FloatingLoss)
          from T_CustomerHoldSum x
          where x.FirmID = a.FirmID and x.CommodityID = a.CommodityID and x.BS_Flag = a.BS_Flag
          group by x.FirmID,x.CommodityID,x.BS_Flag
      );

      --更新交易商临时浮亏
	  if(v_FloatingLossComputeType = 0) then     --分商品分买卖
            for fz in (select a.firmid,a.FloatingLoss-b.runtimefl diff
                 from (select firmid,sum(case when FloatingLoss>0 then 0 else -FloatingLoss end) FloatingLoss from
                       T_FirmHoldSum group by firmid) a,
                       t_firm b where a.firmid=b.firmid)
            loop
                if(fz.diff <> 0) then
                    update T_Firm
                    set RuntimeFL = RuntimeFL + fz.diff
                    where FirmID = fz.firmid;
                    --更新冻结资金，释放或扣除变化的浮亏
      			    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(fz.firmid,fz.diff,'15');
                end if;
            end loop;
	  elsif(v_FloatingLossComputeType = 1) then  --分商品不分买卖
            for fz in (select a.firmid,a.FloatingLoss-b.runtimefl diff
                   from (select firmid,sum(case when FloatingLoss>0 then 0 else -FloatingLoss end) FloatingLoss from
                          (select firmid,sum(FloatingLoss) FloatingLoss from T_FirmHoldSum
                           group by firmid,commodityID) group by firmid
                        ) a,t_firm b where a.firmid=b.firmid)
            loop
                if(fz.diff <> 0) then
                    update T_Firm
                    set RuntimeFL = RuntimeFL + fz.diff
                    where FirmID = fz.firmid;
                    --更新冻结资金，释放或扣除变化的浮亏
      			    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(fz.firmid,fz.diff,'15');
                end if;
            end loop;
	  elsif(v_FloatingLossComputeType = 2) then  --不分商品
            for fz in (select a.firmid,a.FloatingLoss-b.runtimefl diff
                       from ( select firmid,case when sum(FloatingLoss)>0 then 0 else -sum(FloatingLoss) end FloatingLoss
                              from T_FirmHoldSum group by firmid) a,
                         t_firm b where a.firmid=b.firmid)
            loop
                if(fz.diff <> 0) then
                    update T_Firm
                    set RuntimeFL = RuntimeFL + fz.diff
                    where FirmID = fz.firmid;
                    --更新冻结资金，释放或扣除变化的浮亏
      			    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(fz.firmid,fz.diff,'15');
                end if;
            end loop;
	  elsif(v_FloatingLossComputeType = 3 or v_FloatingLossComputeType = 4) then  --盘中算盈亏或不算盈亏
            for fz in (select a.firmid,a.FloatingLoss-b.runtimefl diff
                       from ( select firmid,-sum(FloatingLoss) FloatingLoss
                              from T_FirmHoldSum group by firmid) a,
                         t_firm b where a.firmid=b.firmid)
            loop
                if(fz.diff <> 0) then
                    update T_Firm
                    set RuntimeFL = RuntimeFL + fz.diff
                    where FirmID = fz.firmid;
                    --更新冻结资金，释放或扣除变化的浮亏
      			    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(fz.firmid,fz.diff,'15');
                end if;
            end loop;
	  end if;

      return 1;

end;
/

prompt
prompt Creating function FN_T_COMPUTEASSUREBYARGS
prompt ==========================================
prompt
create or replace function FN_T_ComputeAssureByArgs(
    p_bs_flag        number,
    p_quantity number,
    p_price number,
    p_contractFactor        number,
    p_marginAlgr number,
    p_marginRate_b number,
    p_marginRate_s number
) return number
/****
 * 根据参数计算担保金
 * 返回值 成功返回担保金;-1 计算所需数据不全;-100 其它错误
****/
as
	v_version varchar2(10):='1.0.0.1';
    v_margin             number(15,2) default 0;
begin
    if(p_marginAlgr=1) then  --应收保证金=数量*合约因子*价格*担保金
    	if(p_bs_flag = 1) then  --买
        	v_margin:=p_quantity*p_contractFactor*p_price*p_marginRate_b;
        elsif(p_bs_flag = 2) then  --卖
        	v_margin:=p_quantity*p_contractFactor*p_price*p_marginRate_s;
        end if;
    elsif(p_marginAlgr=2) then  --应收保证金=数量*担保金
    	if(p_bs_flag = 1) then  --买
        	v_margin:=p_quantity*p_marginRate_b;
        elsif(p_bs_flag = 2) then  --卖
        	v_margin:=p_quantity*p_marginRate_s;
        end if;
    end if;
    if(v_margin is null) then
    	rollback;
        return -1;
    end if;
    return v_margin;
exception
    when no_data_found then
    	rollback;
        return -1;
    when others then
    	rollback;
    	return -100;
end;
/

prompt
prompt Creating function FN_T_COMPUTEMARGINBYARGS
prompt ==========================================
prompt
create or replace function FN_T_ComputeMarginByArgs(
    p_bs_flag        number,
    p_quantity number,
    p_price number,
    p_contractFactor        number,
    p_marginAlgr number,
    p_marginRate_b number,
    p_marginRate_s number
) return number
/****
 * 根据参数计算保证金
 * 返回值 成功返回保证金;-1 计算所需数据不全;-100 其它错误
****/
as
	v_version varchar2(10):='1.0.0.1';
    v_margin             number(15,2) default 0;
begin
    if(p_marginAlgr=1) then  --应收保证金=数量*合约因子*价格*保证金
    	if(p_bs_flag = 1) then  --买
		    if(p_marginRate_b = -1) then --  -1表示收全款
		    	v_margin:=p_quantity*p_contractFactor*p_price;
		    else
			    v_margin:=p_quantity*p_contractFactor*p_price*p_marginRate_b;
		    end if;
        elsif(p_bs_flag = 2) then  --卖
		    if(p_marginRate_s = -1) then --  -1表示收全款
		    	v_margin:=p_quantity*p_contractFactor*p_price;
		    else
			    v_margin:=p_quantity*p_contractFactor*p_price*p_marginRate_s;
		    end if;
        end if;
    elsif(p_marginAlgr=2) then  --应收保证金=数量*保证金
    	if(p_bs_flag = 1) then  --买
		    if(p_marginRate_b = -1) then --  -1表示收全款
		    	v_margin:=p_quantity*p_contractFactor*p_price;
		    else
			    v_margin:=p_quantity*p_marginRate_b;
		    end if;
        elsif(p_bs_flag = 2) then  --卖
		    if(p_marginRate_s = -1) then --  -1表示收全款
		    	v_margin:=p_quantity*p_contractFactor*p_price;
		    else
			    v_margin:=p_quantity*p_marginRate_s;
		    end if;
        end if;
    end if;

    if(v_margin is null) then
    	rollback;
        return -1;
    end if;
    return v_margin;
exception
    when no_data_found then
    	rollback;
        return -1;
    when others then
	    rollback;
    	return -100;
end;
/

prompt
prompt Creating function FN_T_COMPUTEFEE
prompt =================================
prompt
create or replace function FN_T_ComputeFee(
    p_FirmID     varchar2,
    p_CommodityID varchar2,
    p_bs_flag        number,
    p_quantity       number,
    p_price          number
) return number
/****
 * 计算手续费
 * 返回值 成功返回手续费;-1 计算交易费用所需数据不全;-100 其它错误
****/
as
	v_version varchar2(10):='1.0.0.1';
    v_feeRate_b         number(15,9);
    v_feeRate_s         number(15,9);
    v_feeAlgr       number(2);
    v_contractFactor  number(12,2);
    v_fee             number(15,2) default 0;
begin
    --获取商品信息：合约因子，手续费系数，手续费算法。
    select feerate_b,feerate_s,feealgr,contractfactor
    into v_feeRate_b,v_feeRate_s,v_feeAlgr,v_contractFactor
    from T_Commodity where CommodityID=p_CommodityID;

    begin
        --获取交易商对应套餐手续费系数，手续费算法
        select feerate_b,feerate_s,feealgr
   		into v_feeRate_b,v_feeRate_s,v_feeAlgr
        from T_A_Tariff
        where TariffID=(select TariffID from t_firm where FirmID=p_FirmID) and CommodityID=p_CommodityID;
    exception
        when NO_DATA_FOUND then
            null;
    end;

    begin
        --获取特户的手续费系数，手续费算法
        select feerate_b,feerate_s,feealgr
   		into v_feeRate_b,v_feeRate_s,v_feeAlgr
        from T_A_FirmFee
        where FirmID=p_FirmID and CommodityID=p_CommodityID;
    exception
        when NO_DATA_FOUND then
            null;
    end;
    if(v_feeAlgr=1) then  --应收手续费=数量*合约因子*价格*手续费
    	if(p_bs_flag = 1) then  --买
        	v_fee:=p_quantity*v_contractFactor*p_price*v_feeRate_b;
        elsif(p_bs_flag = 2) then  --卖
        	v_fee:=p_quantity*v_contractFactor*p_price*v_feeRate_s;
        end if;
    elsif(v_feeAlgr=2) then  --应收手续费=数量*手续费
    	if(p_bs_flag = 1) then  --买
        	v_fee:=p_quantity*v_feeRate_b;
        elsif(p_bs_flag = 2) then  --卖
        	v_fee:=p_quantity*v_feeRate_s;
        end if;
    end if;
    if(v_fee is null) then
    	rollback;
        return -1;
    end if;
    return v_fee;
exception
    when no_data_found then
    	rollback;
        return -1;
    when others then
    	rollback;
   		return -100;
end;
/

prompt
prompt Creating function FN_T_RECOMPUTEFUNDS
prompt =====================================
prompt
create or replace function FN_T_ReComputeFunds(
    p_MarginFBFlag number   --0：结算时调整；1：开市前调整；2：交易中调整。不是按开仓价算保证金时要区别，0按今结算价，1和2按昨结算价，但交易中调整且盘中按订立价要用开仓价重算当天的进行覆盖，同时2要重算委托冻结资金
)
return number
/****
 * 重算临时交易资金,包括交易保证金，担保金，冻结资金
 * 1、注意不要提交commit，因为闭市处理函数要调用它；
   2、不要从T_SystemStatus中取TradeDate，因为开市前调整时还没做交易日切换
 * 返回值
 * 1 成功
 * -100 其它错误
****/
as
	v_version varchar2(10):='1.0.2.1';
    v_FirmID varchar2(32);
    v_Margin         number(15,2):=0; --个人部分保证金
    v_HoldMargin         number(15,2):=0;
    v_HoldAssure         number(15,2):=0;
    v_diff         number(15,2);
	v_FrozenFunds   number(15,2);
	v_F_FrozenFunds   number(15,2);
	v_TradeDate date;
	v_GageMode number(2);--抵顶模式，分0全抵顶和1半抵顶，半抵顶时要计算浮亏，2009-10-14
    --委托中已冻结资金的游标
    cursor cur_T_Orders is select FirmID,sum(FrozenFunds-UnfrozenFunds) from T_Orders where OrderType=1 and Status in(1,2) group by FirmID;
    --交易商游标，用来更新临时保证金和担保金
    cursor cur_T_Firm is
    select a.FirmID,(a.RuntimeMargin-a.RuntimeAssure),nvl(b.HoldMargin,0),nvl(b.HoldAssure,0)
    from T_Firm a,(select FirmID,nvl(sum(HoldMargin),0) HoldMargin,nvl(sum(HoldAssure),0) HoldAssure from T_FirmHoldSum group by FirmID) b
    where a.FirmID=b.FirmID(+);
begin
	    --获取抵顶模式
	    select GageMode into v_GageMode from T_A_Market;
        --更新持仓明细保证金，担保金
        update
        (
          select /*+ BYPASS_UJVC */a.HoldQty,a.bs_flag,a.HoldMargin,a.HoldAssure,
          b.marginrate_b,b.marginrate_s,b.marginAssure_b,b.marginAssure_s,b.marginalgr,b.ContractFactor,
          decode(b.MarginPriceType,0,a.Price,decode(p_MarginFBFlag,0,b.price,b.YesterBalancePrice)) Price
          from T_HoldPosition a,
              (select c.MarginPriceType,c.marginrate_b,c.marginrate_s,c.marginAssure_b,c.marginAssure_s,c.marginalgr,c.ContractFactor,c.commodityid,q.price,q.YesterBalancePrice from T_Commodity c,T_Quotation q where c.CommodityID=q.CommodityID) b
          where a.commodityid=b.commodityid
        )
        set HoldMargin = FN_T_ComputeMarginByArgs(bs_flag,HoldQty,Price,contractFactor,marginAlgr,marginRate_b,marginRate_s)+FN_T_ComputeAssureByArgs(bs_flag,HoldQty,Price,contractFactor,marginAlgr,marginAssure_b,marginAssure_s),
            HoldAssure = FN_T_ComputeAssureByArgs(bs_flag,HoldQty,Price,contractFactor,marginAlgr,marginAssure_b,marginAssure_s);

        --更新特殊交易商的持仓明细保证金，担保金
        update
        (
          select /*+ BYPASS_UJVC */a.HoldQty,a.bs_flag,a.HoldMargin,a.HoldAssure,
          c.marginrate_b,c.marginrate_s,c.marginAssure_b,c.marginAssure_s,c.marginalgr,
          b.ContractFactor,decode(b.MarginPriceType,0,a.Price,decode(p_MarginFBFlag,0,b.price,b.YesterBalancePrice)) Price
          from T_HoldPosition a,
              (select c.MarginPriceType,c.ContractFactor,c.commodityid,q.price,q.YesterBalancePrice from T_Commodity c,T_Quotation q where c.CommodityID=q.CommodityID) b,
              T_A_FirmMargin c
          where a.commodityid=b.commodityid and a.commodityid=c.commodityid and a.firmid=c.firmid
        )
        set HoldMargin = FN_T_ComputeMarginByArgs(bs_flag,HoldQty,Price,contractFactor,marginAlgr,marginRate_b,marginRate_s)+FN_T_ComputeAssureByArgs(bs_flag,HoldQty,Price,contractFactor,marginAlgr,marginAssure_b,marginAssure_s),
            HoldAssure = FN_T_ComputeAssureByArgs(bs_flag,HoldQty,Price,contractFactor,marginAlgr,marginAssure_b,marginAssure_s);

        --如果是交易中调整，且保证金调整方式为2（盘中按订立价），则要重算当天开仓的保证金（按订立价），覆盖掉上面重算的当天开仓保证金（因为统一按昨结算价计算的）
		if(p_MarginFBFlag = 2) then
			select TradeDate into v_TradeDate from T_SystemStatus;
			--更新持仓明细保证金，担保金
	        update
	        (
	          select /*+ BYPASS_UJVC */a.HoldQty,a.bs_flag,a.HoldMargin,a.HoldAssure,a.Price,
	          b.marginrate_b,b.marginrate_s,b.marginAssure_b,b.marginAssure_s,b.marginalgr,b.ContractFactor
	          from T_HoldPosition a,T_Commodity b
	          where b.MarginPriceType=2 and trunc(a.AtClearDate)=trunc(v_TradeDate) and a.commodityid=b.commodityid
	        )
	        set HoldMargin = FN_T_ComputeMarginByArgs(bs_flag,HoldQty,Price,contractFactor,marginAlgr,marginRate_b,marginRate_s)+FN_T_ComputeAssureByArgs(bs_flag,HoldQty,Price,contractFactor,marginAlgr,marginAssure_b,marginAssure_s),
	            HoldAssure = FN_T_ComputeAssureByArgs(bs_flag,HoldQty,Price,contractFactor,marginAlgr,marginAssure_b,marginAssure_s);
	        --更新特殊交易商的持仓明细保证金，担保金
	        update
	        (
	          select /*+ BYPASS_UJVC */a.HoldQty,a.bs_flag,a.HoldMargin,a.HoldAssure,a.Price,
	          c.marginrate_b,c.marginrate_s,c.marginAssure_b,c.marginAssure_s,c.marginalgr,
	          b.ContractFactor
	          from T_HoldPosition a,T_Commodity b,T_A_FirmMargin c
	          where b.MarginPriceType=2 and trunc(a.AtClearDate)=trunc(v_TradeDate) and a.commodityid=b.commodityid and a.commodityid=c.commodityid and a.firmid=c.firmid
	        )
	        set HoldMargin = FN_T_ComputeMarginByArgs(bs_flag,HoldQty,Price,contractFactor,marginAlgr,marginRate_b,marginRate_s)+FN_T_ComputeAssureByArgs(bs_flag,HoldQty,Price,contractFactor,marginAlgr,marginAssure_b,marginAssure_s),
	            HoldAssure = FN_T_ComputeAssureByArgs(bs_flag,HoldQty,Price,contractFactor,marginAlgr,marginAssure_b,marginAssure_s);
        end if;
      --更新交易客户持仓合计中的数据，其中均价和持仓金额是包括抵顶的
	  update T_CustomerHoldSum a
      set (HoldMargin,HoldAssure,EvenPrice,HoldFunds) =
      (
          select sum(x.HoldMargin),sum(x.HoldAssure),decode(a.HoldQty+a.GageQty,0,0,sum(x.Price*(x.HoldQty+x.GageQty))/(a.HoldQty+a.GageQty)),sum(x.Price*(x.HoldQty+x.GageQty)*y.ContractFactor)
          from T_HoldPosition x,T_Commodity y
          where x.CommodityID=y.CommodityID and x.CustomerID = a.CustomerID and x.CommodityID = a.CommodityID and x.BS_Flag = a.BS_Flag
          group by x.CustomerID,x.CommodityID,x.BS_Flag
      ); 
      --更新交易商持仓合计中的数据，其中均价和持仓金额包不包括抵顶的根据抵顶模式来判断，所以从持仓明细中合计
	  update T_FirmHoldSum a
      set (HoldMargin,HoldAssure,EvenPrice,HoldFunds) =
      (
          select sum(x.HoldMargin),sum(x.HoldAssure),decode(a.HoldQty+decode(v_GageMode,1,a.GageQty,0),0,0,sum(x.Price*(x.HoldQty+decode(v_GageMode,1,x.GageQty,0)))/(a.HoldQty+decode(v_GageMode,1,a.GageQty,0))),sum(x.Price*(x.HoldQty+decode(v_GageMode,1,x.GageQty,0))*y.ContractFactor)
          from T_HoldPosition x,T_Commodity y
          where x.CommodityID=y.CommodityID and x.FirmID = a.FirmID and x.CommodityID = a.CommodityID and x.BS_Flag = a.BS_Flag
          group by x.FirmID,x.CommodityID,x.BS_Flag
      ); 
      --更新交易商临时保证金和担保金，并更新冻结资金
  	  open cur_T_Firm;
      loop
    	  fetch cur_T_Firm into v_FirmID,v_Margin,v_HoldMargin,v_HoldAssure;
    	  exit when cur_T_Firm%notfound;
    	  update T_Firm set RuntimeMargin=v_HoldMargin,RuntimeAssure=v_HoldAssure where FirmID=v_FirmID;
    	  v_diff := v_HoldMargin-v_HoldAssure - v_Margin;
    	  if(v_diff <> 0) then
    	  	  v_F_FrozenFunds := FN_F_UpdateFrozenFunds(v_FirmID,v_diff,'15');
    	  end if;
 	  end loop;
      close cur_T_Firm;
      --交易中调整要重算冻结资金
      if(p_MarginFBFlag = 2) then
          --1、先释放原来冻结的资金
      	  open cur_T_Orders;
          loop
        	  fetch cur_T_Orders into v_FirmID,v_FrozenFunds;
        	  exit when cur_T_Orders%notfound;
			  v_F_FrozenFunds := FN_F_UpdateFrozenFunds(v_FirmID,-v_FrozenFunds,'15');
     	  end loop;
          close cur_T_Orders;
      	  --2、重算委托表中的冻结和解冻资金
          --  mod by yukx 20100427如果为卖仓单则只算冻结手续费
          update
          (
            select /*+ BYPASS_UJVC */a.FirmID,a.CommodityID,a.BS_Flag,a.Quantity,a.TradeQty,a.FrozenFunds,a.UnfrozenFunds,a.BillTradeType,
            decode(b.MarginPriceType,1,b.LastPrice,a.Price) Price
            from T_Orders a,T_Commodity b
            where a.commodityid=b.commodityid and a.OrderType=1 and a.Status in(1,2)
          )
          set FrozenFunds=decode(BillTradeType,1,0,FN_T_ComputeMargin(FirmID,CommodityID,BS_Flag,Quantity,Price)) + FN_T_ComputeFee(FirmID,CommodityID,BS_Flag,Quantity,Price),  --mod by yukx 20100427
		      UnfrozenFunds=decode(BillTradeType,1,0,FN_T_ComputeMargin(FirmID,CommodityID,BS_Flag,TradeQty,Price)) + FN_T_ComputeFee(FirmID,CommodityID,BS_Flag,TradeQty,Price);  --mod by yukx 20100427

		  --3、重新扣除冻结资金
      	  open cur_T_Orders;
          loop
        	  fetch cur_T_Orders into v_FirmID,v_FrozenFunds;
        	  exit when cur_T_Orders%notfound;
			  v_F_FrozenFunds := FN_F_UpdateFrozenFunds(v_FirmID,v_FrozenFunds,'15');
     	  end loop;
          close cur_T_Orders;
      end if;

      return 1;
end;
/

prompt
prompt Creating function FN_T_UNFROZENBILL
prompt ===================================
prompt
create or replace function FN_T_UnfrozenBill(
    p_CommodityID varchar2
) return number
/****
 * 解冻仓单
 * 返回值： 1 成功、-2 已经解冻
****/
as
    v_BillID varchar2(16);  -- 仓单号
	  v_num    number(10);

    --利用游标获取下市商品的仓单号
    cursor cur_BillId is
        select billId
        from t_billfrozen
        where operation in (select to_char(id) from t_e_gagebill where CommodityID = p_CommodityID);

begin

    open cur_BillId;
      loop
    	  fetch cur_BillId into v_BillID;
    	  exit when cur_BillId%notfound;
          -- 解冻仓单
		     v_num := FN_BI_UnfrozenBill(15,v_BillID);
         if(v_num != 1) then

           -- 添加订单数据库日志
		    	 insert into t_dblog(err_date,name_proc,err_code,err_msg)
           values (sysdate, 'FN_T_UnfrozenBill',-2, '商品：'||p_CommodityID||',仓单：'||v_BillID||',解冻仓单失败！');
           -- 添加订单后台操作日志
           insert into c_globallog_all(ID, operator, operatetime, operatetype, operatecontent, operateresult, logtype )
           values (seq_c_globallog.nextval, 'system', sysdate, 1508, '商品：'||p_CommodityID||',仓单：'||v_BillID||',解冻仓单失败！', 0, 1);

           commit;

	    	 end if;
 	    end loop;
    close cur_BillId;

    return 1;

end;
/

prompt
prompt Creating function FN_T_COMPUTESETTLEPRICE
prompt =========================================
prompt
create or replace function FN_T_ComputeSettlePrice(
    p_CommodityID varchar2,  --商品代码
    p_SettlePriceType number    --计算交收价类型
) return number
/****
 * 计算交收价格
 * 计算交收价类型=2的按开仓价不用计算，直接按持仓明细中开仓价
 * 返回值 成功返回交收价格
****/
as
	v_version varchar2(10):='1.0.2.1';
    v_SettlePrice         number(15,2);
    tradeFundSum         number(15,2);
    tradeQtySum  number(10);
    v_BeforeDays  number(4);
    v_SettleDate date;
    v_Quantity  number(10);
    i            number(4);
    v_num            number(10);
begin
	if(p_SettlePriceType = 0) then  --按交收日的闭市结算价
	    --找出交收日的行情结算价
	    begin
	    	select nvl(Price,0) into v_SettlePrice from T_Quotation where CommodityID=p_CommodityID;
	    exception
	        when NO_DATA_FOUND then
           begin
	            select nvl(Price,0) into v_SettlePrice from T_H_Quotation where CommodityID=p_CommodityID and ClearDate in(select max(ClearDate) from T_H_Quotation where CommodityID=p_CommodityID);
	        exception
	        when NO_DATA_FOUND then
           return 0;
           end;
      end;
	elsif(p_SettlePriceType = 1) then  --按交收日前几日的闭市结算价的加权平均价
		--找出提前日，交收日期
	    select SettleDate,BeforeDays into v_SettleDate,v_BeforeDays from T_Commodity where CommodityID=p_CommodityID;
        tradeQtySum := 0;
        tradeFundSum := 0;
        --判断是否资金结算完成，不根据状态，因为重做结算时状态会变化
        --如果资金结算完成的话当前成交会删除，从而导致当天的价格没有参与计算 2010-05-24 by chenxc
        select count(*) into v_num from T_H_Quotation where CommodityID=p_CommodityID and ClearDate = v_SettleDate;
        if(v_num = 0) then
		    --从当前表中计算交收金额和数量
		    begin
		    	select nvl(Price,0) into v_SettlePrice from T_Quotation where CommodityID=p_CommodityID;
		    	select nvl(sum(Quantity),0) into v_Quantity from T_Trade where CommodityID=p_CommodityID;
		    	tradeFundSum := tradeFundSum + v_SettlePrice*v_Quantity;
				tradeQtySum := tradeQtySum + v_Quantity;
		    	i := 1;
		    exception
		        when NO_DATA_FOUND then
		           i := 0;
		    end;
		else
			i := 0;
		end if;
	    --循环计算交收日前的v_BeforeDays的金额和数量，包括交收日当天的v_BeforeDays的交易日期
        while i<v_BeforeDays loop
        	--加上下面的判断是表示如果设置的提前几日的加权价的天数大于实际的交易天数时不造成循环超出变量的范围，也即是设置的天数大于交易天数则按交易天数计算加权价格
            if(v_BeforeDays>=999 or i>=999) then
            	exit;
   			end if;
		    --从历史表中计算交收金额和数量
		    begin
		    	select nvl(Price,0) into v_SettlePrice from T_H_Quotation where CommodityID=p_CommodityID and ClearDate = v_SettleDate-i;
		    	select nvl(sum(Quantity),0) into v_Quantity from T_H_Trade where CommodityID=p_CommodityID and ClearDate = v_SettleDate-i;
		    	tradeFundSum := tradeFundSum + v_SettlePrice*v_Quantity;
		    	tradeQtySum := tradeQtySum + v_Quantity;
		    exception
		        when NO_DATA_FOUND then
		            v_BeforeDays := v_BeforeDays + 1;
		    end;
            i := i+1;
        end loop;
        --计算加权平均价，如果数量为0的话则用上面查出的交收价
		if(tradeQtySum <> 0) then
        	v_SettlePrice := round(tradeFundSum/tradeQtySum,0);
        end if;
	elsif(p_SettlePriceType = 3) then  --按指定交收价
		select SpecSettlePrice into v_SettlePrice from T_Commodity where CommodityID=p_CommodityID;
    end if;
    return v_SettlePrice;
end;
/

prompt
prompt Creating function FN_T_SETTLEPROCESS
prompt ====================================
prompt
create or replace function FN_T_SettleProcess(
    p_CommodityID varchar2,
    p_SettleType number   --0：自动交收；1：手动交收；
) return number
/****
 * 交收处理
 * 1、注意不要提交commit，因为闭市处理函数要调用它；
 * 2、交易结算之前调用做交收
 * 3、此函数并不退交易商临时浮亏，因为自动交收时闭市结算会重算，手工交收则通过外部触发计算浮亏线程来重算
 * 返回值
 * 1 成功
 * -1 交收时所需数据不全
 * -100 其它错误
****/
as
  v_version varchar2(10):='1.0.2.1';
    v_CommodityID varchar2(16):=p_CommodityID;
    v_BreedID number(10);  --FN_T_SettleProcess品种id, add by tangzy 2010-06-21
    v_FirmID varchar2(32);
    v_CustomerID        varchar2(40);
    v_HoldQty  number(10);
    v_Payout         number(15,2):=0;
    v_Payout_one         number(15,2):=0;
    v_Margin         number(15,2):=0;
    v_Margin_one         number(15,2):=0;
    v_Margin_b         number(15,2):=0;
    v_Margin_b_one         number(15,2):=0;
    v_Margin_s         number(15,2):=0;
    v_Margin_s_one         number(15,2):=0;
    v_closeFL_one         number(15,2):=0;    --一条记录的交收盈亏
    v_CloseFL         number(15,2):=0;        --交收盈亏累加
    v_Fee_one         number(15,2):=0;    --一条记录的交收手续费
    v_Fee         number(15,2):=0;        --交收手续费累加
    v_BS_Flag           number(2);
    v_Price         number(15,2);
    v_ContractFactor    number(12,2);
    v_LastFirmID varchar2(32) default null;
    v_TradeDate date;--插入历史表时以代理状态表中的日期插入，不能用当天的日期，因为存在今天结算昨天的
  v_SettlePriceType number(2);
  v_A_HoldNo number(15); --当前成交号
  v_Last_A_HoldNo number(15); --上一笔成交号
  v_AddedTaxFactor T_Commodity.AddedTaxFactor%type;--增值税率系数=AddedTax/(1+AddedTax)
  v_GageQty     number(10);
  v_SettlePrice         number(15,2);
  v_CloseAddedTax_one   number(15,2); --交收盈亏增值税
  v_CloseAddedTax         number(15,2):=0;        --交收盈亏增值税累加
  v_num            number(10);
  v_Balance    number(15,2);
  v_F_FrozenFunds   number(15,2);
  v_redoCal           number(2):=0;    --是否是重做结算，0：不是重做结算；1：是重做结算；
  v_sql  varchar2(1000);
  v_str  varchar2(100);
  v_EvenPrice         number(16,6);
    v_LowestSettleFee             number(15,2) default 0;
    v_TaxInclusive     number(1);   --商品是否含税 0含税  1不含税   xiefei 20150730
    --交收持仓明细表中计算交收资金游标
    type c_T_SettleHoldPosition is ref cursor;
  v_T_SettleHoldPosition c_T_SettleHoldPosition;
    --利用游标更新冻结资金，释放个人部分的保证金
    cursor cur_T_FirmHoldSum is
        select FirmID,HoldMargin-HoldAssure
        from T_FirmHoldSum
        where CommodityID=p_CommodityID;
    --交收持仓明细表中退交易商资金游标，只包括手动和自动交收
    cursor cur_BackFunds(c_TradeDate date,c_CommodityID varchar2) is
        select FirmID,sum(SettleMargin),sum(Payout),sum(SettleFee),sum(Settle_PL),sum(SettleAddedTax)
      from T_SettleHoldPosition
      where SettleProcessDate=c_TradeDate and CommodityID=c_CommodityID and SettleType in(0,1)
      group by FirmID;
    --交收持仓明细表中更新持仓均价游标，只包括手动和自动交收
    cursor cur_EvenPrice(c_TradeDate date,c_CommodityID varchar2) is
        select FirmID,BS_Flag,decode(nvl(sum(HoldQty+GageQty),0),0,0,nvl(sum(Price*(HoldQty+GageQty)),0)/sum(HoldQty+GageQty)) EvenPrice
        from T_SettleHoldPosition
        where SettleProcessDate=c_TradeDate and CommodityID=c_CommodityID and SettleType in(0,1)
        group by FirmID,BS_Flag;

    v_SettleType  number(10):= 1; --由于现在不分手动和自动交收，按期交收类型在数据库中为1,及设置类型等于1。
    v_billNum            number(10);
begin
    --1、获取交易日期
    select TradeDate into v_TradeDate from T_SystemStatus;
      --判断是否重做结算
      select count(*) into v_num from T_SettleHoldPosition where SettleProcessDate = v_TradeDate and CommodityID=v_CommodityID and SettleType in(0,1);
      if(v_num > 0) then
          v_redoCal := 1;
      end if;

/*
    select AddedTaxFactor,ContractFactor,SettlePriceType,LowestSettleFee
    into   v_AddedTaxFactor,v_ContractFactor,v_SettlePriceType,v_LowestSettleFee    20150730  xief */

    -----增加是否含税字段 xief  20150730
    select AddedTaxFactor,ContractFactor,SettlePriceType,LowestSettleFee,TaxInclusive
    into   v_AddedTaxFactor,v_ContractFactor,v_SettlePriceType,v_LowestSettleFee,v_TaxInclusive
      from T_Commodity
      where CommodityID=v_CommodityID;
      --2、退此商品的全部实时的保证金和担保金，不用去计算保证金和担保金，直接取
    update T_Firm a
      set RuntimeMargin = RuntimeMargin-
      nvl((
          select sum(HoldMargin)
          from T_FirmHoldSum
          where CommodityID=v_CommodityID and FirmID=a.FirmID
          group by FirmID
      ),0), RuntimeAssure = RuntimeAssure-
      nvl((
          select sum(HoldAssure)
          from T_FirmHoldSum
          where CommodityID=v_CommodityID and FirmID=a.FirmID
          group by FirmID
      ),0)
      where a.FirmID in (select distinct FirmID from T_FirmHoldSum where CommodityID=v_CommodityID);
      -- 2.5、利用游标更新冻结资金，释放个人部分的保证金
      open cur_T_FirmHoldSum;
      loop
        fetch cur_T_FirmHoldSum into v_FirmID,v_Margin;
        exit when cur_T_FirmHoldSum%notfound;
          --更新冻结资金，释放个人部分的保证金
      v_F_FrozenFunds := FN_F_UpdateFrozenFunds(v_FirmID,-v_Margin,'15');
    end loop;
      close cur_T_FirmHoldSum;

    --按字段名插入交收持仓明细表
    insert into t_settleholdposition
      (id, settleprocessdate, a_holdno, a_tradeno, customerid, commodityid, bs_flag, price, holdqty, openqty, holdtime, holdmargin, firmid, gageqty, holdassure, floatingloss, settlemargin, payout, settlefee, settle_pl, settleaddedtax, settleprice, settletype, holdtype, atcleardate,MATCHStatus)
      select SEQ_T_SettleHoldPosition.nextval,v_TradeDate,a_holdno, a_tradeno, customerid, commodityid, bs_flag, price, holdqty, openqty, holdtime, holdmargin, firmid, gageqty, holdassure, floatingloss,0,0,0,0,0,0,v_SettleType , holdtype, atcleardate , 0
      from t_holdposition
      where CommodityID=v_CommodityID and (HoldQty+GageQty) > 0;

    --交收后，在生效仓单抵顶表增加总数量  add by tangzy 2010-06-18
    select BREEDID into v_BreedID from T_Commodity where COMMODITYID=v_CommodityID;
    update t_validgagebill t
      set quantity = quantity +
                     nvl((select gageqty from t_firmholdsum a
                                  where a.commodityid = v_CommodityID
                                    and a.firmid = t.firmid
                                    and a.bs_flag = 2),
                         0)
      where t.commodityId=v_CommodityID;

      --7、删除此商品的交易客户持仓明细,交易客户持仓合计表，交易商持仓合计表
    delete from T_HoldPosition where CommodityID=v_CommodityID;
      delete from T_CustomerHoldSum where CommodityID=v_CommodityID;
      delete from T_FirmHoldSum where CommodityID=v_CommodityID;

      --如果是重做结算的话则要先退交易资金并写流水，相当于红冲,包括手动和自动交收
    if(v_redoCal = 1) then
        open cur_BackFunds(v_TradeDate,v_CommodityID);
        loop
          fetch cur_BackFunds into v_FirmID,v_Margin,v_Payout,v_Fee,v_CloseFL,v_CloseAddedTax;
          exit when cur_BackFunds%notfound;
          --退交收货款，交收手续费，付交收盈利或收交收亏损 ，并写流水
          v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15008',-v_Payout,null,v_CommodityID,null,null);
          v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15010',-v_Fee,null,v_CommodityID,null,null);
          --退盈亏也得反着来
          if(v_CloseFL >= 0) then
            v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15011',-v_CloseFL,null,v_CommodityID,-v_CloseAddedTax,null);
          else
            v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15012',v_CloseFL,null,v_CommodityID,v_CloseAddedTax,null);
          end if;
            --退交收保证金，并写流水
        update T_Firm set RuntimeSettleMargin=RuntimeSettleMargin-v_Margin where FirmID=v_FirmID;
          v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15013',-v_Margin,null,v_CommodityID,null,null);
      end loop;
        close cur_BackFunds;
          --重置清0
          v_Margin := 0;
          v_Payout := 0;
        v_Fee := 0;
        v_CloseFL := 0;
        v_CloseAddedTax := 0;

        v_str := ' and SettleType in(0,1) ';
    else
        v_str := ' and SettleType =' || v_SettleType;
      end if;

      --4、如果不是按开仓价则根据算法计算交收价
    if(v_SettlePriceType <> 2) then
        v_SettlePrice := FN_T_ComputeSettlePrice(v_CommodityID,v_SettlePriceType);
      end if;
    v_sql := 'select A_HoldNo,FirmID,BS_Flag,HoldQty,Price,GageQty,CustomerID ' ||
               'from T_SettleHoldPosition ' ||
               'where to_char(SettleProcessDate,''yyyy-MM-dd'')=''' || to_char(v_TradeDate,'yyyy-MM-dd') || ''' and CommodityID=''' || v_CommodityID || '''' ||
               v_str ||
               'order by FirmID ';
      --5、利用游标根据交收价来扣除交收货款，交收手续费，交收盈亏，并写资金流水，包括抵顶的
      --6、同时将持仓明细表转入交收持仓明细表，并删除持仓明细表中相应记录
      open v_T_SettleHoldPosition for v_sql;
      loop
          fetch v_T_SettleHoldPosition into v_A_HoldNo,v_FirmID,v_BS_Flag,v_HoldQty,v_Price,v_GageQty,v_CustomerID;
          exit when v_T_SettleHoldPosition%notfound;
            --判断是否是同一交易商
            if(v_LastFirmID is not null and v_LastFirmID <> v_FirmID) then
            --扣除交收货款，交收手续费，付交收盈利或收交收亏损 ，并写流水
          v_Balance := FN_F_UpdateFundsFull(v_LastFirmID,'15008',v_Payout,null,v_CommodityID,null,null);
          --如果手续费低于最低交收手续费，则按最低交收手续费收取，并且将此交易商最后一笔明细的手续费更新成加上差额的手续费
          if(v_Fee >= v_LowestSettleFee) then
              v_Balance := FN_F_UpdateFundsFull(v_LastFirmID,'15010',v_Fee,null,v_CommodityID,null,null);
        else
            v_Balance := FN_F_UpdateFundsFull(v_LastFirmID,'15010',v_LowestSettleFee,null,v_CommodityID,null,null);
              update T_SettleHoldPosition
              set SettleFee=SettleFee+(v_LowestSettleFee-v_Fee)
              where SettleProcessDate=v_TradeDate and A_HoldNo=v_Last_A_HoldNo and SettleType in(0,1); -- 2010-07-30 增加SettleType in(0,1)
          end if;

          if(v_CloseFL >= 0) then
            v_Balance := FN_F_UpdateFundsFull(v_LastFirmID,'15011',v_CloseFL,null,v_CommodityID,v_CloseAddedTax,null);
          else
            v_Balance := FN_F_UpdateFundsFull(v_LastFirmID,'15012',-v_CloseFL,null,v_CommodityID,-v_CloseAddedTax,null);
          end if;

            --扣除交收保证金，并写流水
        update T_Firm set RuntimeSettleMargin=RuntimeSettleMargin+v_Margin_b+v_Margin_s where FirmID=v_LastFirmID;
          v_Balance := FN_F_UpdateFundsFull(v_LastFirmID,'15013',v_Margin_b+v_Margin_s,null,v_CommodityID,null,null);

            --下一不同交易商则重置清0
                v_Margin_b := 0;
                v_Margin_s := 0;
                v_Payout := 0;
            v_Fee := 0;
            v_CloseFL := 0;
            v_CloseAddedTax := 0;
            end if;
            --如果按开仓价计算交收价则就是开仓价
            if(v_SettlePriceType = 2) then
              v_SettlePrice := v_Price;
            end if;
      --计算交收保证金
          v_Margin_one := FN_T_ComputeSettleMargin(v_FirmID,v_CommodityID,v_BS_Flag,v_HoldQty+v_GageQty,v_SettlePrice);
            if(v_Margin_one < 0) then
                Raise_application_error(-20042, 'ComputeSettleMargin error');
            end if;
          if(v_BS_Flag = 1) then
            v_Margin_b_one := v_Margin_one;
            --计算买家交收货款
            v_Payout_one := FN_T_ComputePayout(v_FirmID,v_CommodityID,v_BS_Flag,v_HoldQty+v_GageQty,v_SettlePrice);
            if(v_Payout_one < 0) then
                  Raise_application_error(-20043, 'computePayout error');
              end if;
          else
            v_Margin_s_one := v_Margin_one;
            end if;
          --计算交收手续费
      v_Fee_one := FN_T_ComputeSettleFee(v_FirmID,v_CommodityID,v_bs_flag,v_HoldQty+v_GageQty,v_SettlePrice);
            if(v_Fee_one < 0) then
              Raise_application_error(-20031, 'computeFee error');
            end if;
       --计算税前交收盈亏
            if(v_BS_Flag = 1) then
                v_closeFL_one := (v_HoldQty+v_GageQty)*(v_SettlePrice-v_price)*v_contractFactor; --税前盈亏
            else
                v_closeFL_one := (v_HoldQty+v_GageQty)*(v_price-v_SettlePrice)*v_contractFactor; --税前盈亏
            end if;
            --计算交收增值税,v_AddedTaxFactor增值税系数=AddedTax/(1+AddedTax) xief 20150811
          --  v_CloseAddedTax_one := round(v_closeFL_one*v_AddedTaxFactor,2);
             v_CloseAddedTax_one := 0;
             --计算税后的交收盈亏 xief 20150730  xief 20150811
           /*   if(v_TaxInclusive=1) then
                     --不含税 扣除增值税
                     v_closeFL_one := v_closeFL_one - v_CloseAddedTax_one; --税后盈亏
              end if;
              */
               /*
            --计算税后交收盈亏
            v_closeFL_one := v_closeFL_one - v_CloseAddedTax_one; --税后盈亏   xief 20150730*/

          --将当前持仓记录和交收费用插入交收持仓明细表
          update T_SettleHoldPosition
          set SettleMargin=v_Margin_one,Payout=v_Payout_one,SettleFee=v_Fee_one,Settle_PL=v_closeFL_one,SettleAddedTax=v_CloseAddedTax_one,SettlePrice=v_SettlePrice
          where SettleProcessDate=v_TradeDate and A_HoldNo=v_A_HoldNo and SettleType in(0,1); -- 2010-07-30 增加SettleType in(0,1)


      --累计金额
          v_Margin_b := v_Margin_b + v_Margin_b_one;
          v_Margin_s := v_Margin_s + v_Margin_s_one;
          v_Payout := v_Payout + v_Payout_one;
          v_Fee := v_Fee + v_Fee_one;
          v_CloseFL := v_CloseFL + v_closeFL_one;  --税后盈亏合计
      v_CloseAddedTax:=v_CloseAddedTax + v_CloseAddedTax_one;  --交收增值税合计
      --必须清0
          v_Margin_b_one := 0;
          v_Margin_s_one := 0;
      v_Payout_one := 0;
      --将此交易商ID赋给上个交易商ID，用于判断此交易商是否计算完毕
            v_LastFirmID := v_FirmID;
            v_Last_A_HoldNo := v_A_HoldNo; --用于更新最低手续费的差额
      end loop;
      close v_T_SettleHoldPosition;
      --扣除最后一个交易商的交收货款，交收手续费，付交收盈利或收交收亏损 ，并写流水
    if(v_LastFirmID is not null) then
    v_Balance := FN_F_UpdateFundsFull(v_LastFirmID,'15008',v_Payout,null,v_CommodityID,null,null);
    --如果手续费低于最低交收手续费，则按最低交收手续费收取，并且将此交易商最后一笔明细的手续费更新成加上差额的手续费
      if(v_Fee >= v_LowestSettleFee) then
          v_Balance := FN_F_UpdateFundsFull(v_LastFirmID,'15010',v_Fee,null,v_CommodityID,null,null);
    else
        v_Balance := FN_F_UpdateFundsFull(v_LastFirmID,'15010',v_LowestSettleFee,null,v_CommodityID,null,null);
          update T_SettleHoldPosition
          set SettleFee=SettleFee+(v_LowestSettleFee-v_Fee)
          where SettleProcessDate=v_TradeDate and A_HoldNo=v_Last_A_HoldNo and SettleType in(0,1); -- 2010-07-30 增加SettleType in(0,1)
      end if;
      --商品含不含税，均不扣除交收盈利和交收亏损
    /*if(v_CloseFL >= 0) then
      v_Balance := FN_F_UpdateFundsFull(v_LastFirmID,'15011',v_CloseFL,null,v_CommodityID,v_CloseAddedTax,null);
    else
      v_Balance := FN_F_UpdateFundsFull(v_LastFirmID,'15012',-v_CloseFL,null,v_CommodityID,-v_CloseAddedTax,null);
    end if;*/
    ---xief  20150811
    if(v_CloseFL >= 0) then
      v_Balance := FN_F_UpdateFundsFull(v_LastFirmID,'15011',v_CloseFL,null,v_CommodityID,null,null);
    else
      v_Balance := FN_F_UpdateFundsFull(v_LastFirmID,'15012',-v_CloseFL,null,v_CommodityID,null,null);
    end if;


        --扣除最后一个交易商交收保证金，并写流水
    update T_Firm set RuntimeSettleMargin=RuntimeSettleMargin+v_Margin_b+v_Margin_s where FirmID=v_LastFirmID;
    v_Balance := FN_F_UpdateFundsFull(v_LastFirmID,'15013',v_Margin_b+v_Margin_s,null,v_CommodityID,null,null);
    end if;
        --如果是按开仓价则更新商品上的交收结算价为-1，同时更新交收持仓明细表中的交收价为此商品，交易商，买卖的持仓均价，因为交收返还金额时要用
      if(v_SettlePriceType = 2) then
            v_SettlePrice := -1;

          open cur_EvenPrice(v_TradeDate,v_CommodityID);
          loop
            fetch cur_EvenPrice into v_FirmID,v_BS_Flag,v_EvenPrice;
            exit when cur_EvenPrice%notfound;
          --  update T_SettleHoldPosition--去掉更新交收持仓明细的交收价格
           -- set SettlePrice=v_EvenPrice
          --  where SettleProcessDate=v_TradeDate and CommodityID=v_CommodityID and SettleType in(0,1)
             --     and FirmID=v_FirmID and BS_Flag=v_BS_Flag;
        end loop;
          close cur_EvenPrice;
        end if;
    --更新交收价到商品表中的交收结算价中，并导入交收商品表
    update T_Commodity set SpecSettlePrice=v_SettlePrice where CommodityID=v_CommodityID;
    -- 删除交收商品时去掉交收处理日期条件，解决延期商品到期下市时插入同样商品到交收商品中，因为之前交收申报成交时插入过  by 2013-11-18 zdaodc
    -- delete from T_SettleCommodity where SettleProcessDate=v_TradeDate and CommodityID=v_CommodityID;
    delete from T_SettleCommodity where  CommodityID=v_CommodityID;
        insert into T_SettleCommodity select v_TradeDate,a.* from T_Commodity a where a.CommodityID=v_CommodityID;

      --释放浮亏的冻结资金，这里只释放没有持仓而且临时浮亏不为0的，其它情况通过JAVA调用浮亏计算存储来释放，必须放在删除持仓代码的后面做
        for fz in (select FirmID,RuntimeFL from T_Firm where FirmID not in(select distinct FirmID from T_FirmHoldSum) and RuntimeFL <> 0)
        loop
            update T_Firm set RuntimeFL = 0 where FirmID = fz.FirmID;
            --更新冻结资金，释放或扣除变化的浮亏0
        v_F_FrozenFunds := FN_F_UpdateFrozenFunds(fz.FirmID,-fz.RuntimeFL,'15');
        end loop;

      -- 解冻仓单
      v_billNum := FN_T_UnfrozenBill(v_CommodityID);

      --删除仓单冻结表中、仓单抵顶表和生效仓单抵顶表中的数据
      delete from t_billfrozen where operation in (select to_char(id) from t_e_gagebill where commodityid = v_CommodityID);
      insert into t_e_hisgagebill
       select v_TradeDate,t.* from t_e_gagebill t where commodityid = v_CommodityID;
      delete from t_e_gagebill where commodityid = v_CommodityID;
      delete from t_validgagebill  where commodityid = v_CommodityID;

    return 1;

end;
/

prompt
prompt Creating function FN_T_TRADEFLOW
prompt ================================
prompt
create or replace function FN_T_TradeFlow(
    p_TradeFlowType number   --0：写汇总流水；1：写明细流水；
)
return number
/****
 * 写成交资金流水，交易日期变更结束函数要调用
 * 注意不要提交commit
 * 返回值
 * 1 成功
****/
as
  v_version varchar2(10):='1.0.0.1';
  v_A_TradeNo      number(15);
    v_CommodityID varchar2(16);
    v_FirmID varchar2(32);
    v_TradeFee         number(15,2);
    v_Close_PL         number(15,2);
    v_CloseAddedTax         number(15,2);
  v_Balance    number(15,2);
    --成交明细游标，写成交明细流水
    cursor cur_T_Trade is
        select A_TradeNo,FirmID,CommodityID,TradeFee,nvl(Close_PL,0),nvl(CloseAddedTax,0)
        from T_Trade order by A_TradeNo;
    --成交汇总手续费游标，每个交易商写一笔流水
    cursor cur_fee_sum is
        select FirmID,sum(TradeFee) from T_Trade group by FirmID;
    --成交汇总平仓盈亏游标，每个交易商每种商品写一笔流水
    cursor cur_Close_PL_sum is
        select FirmID,CommodityID,sum(nvl(Close_PL,0)),sum(nvl(CloseAddedTax,0))
        from T_Trade group by FirmID,CommodityID;
begin
  if(p_TradeFlowType = 0) then
        --成交汇总手续费游标
        open cur_fee_sum;
        loop
          fetch cur_fee_sum into v_FirmID,v_TradeFee;
          exit when cur_fee_sum%notfound;
      --更新资金余额，并写手续费流水
      if(v_TradeFee <> 0) then
          v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15001',v_TradeFee,null,null,null,null);
        end if;
      end loop;
        close cur_fee_sum;
        --成交汇总平仓盈亏游标
        open cur_Close_PL_sum;
        loop
          fetch cur_Close_PL_sum into v_FirmID,v_CommodityID,v_Close_PL,v_CloseAddedTax;
          exit when cur_Close_PL_sum%notfound;
      --更新资金余额，并写付交易盈利,收交易亏损 流水

      if(v_Close_PL > 0) then
        v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15006',v_Close_PL,null,v_CommodityID,v_CloseAddedTax,null);
      elsif(v_Close_PL < 0) then
        v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15007',-v_Close_PL,null,v_CommodityID,-v_CloseAddedTax,null);
      end if;


      end loop;
        close cur_Close_PL_sum;
  else
        --成交明细游标
        open cur_T_Trade;
        loop
          fetch cur_T_Trade into v_A_TradeNo,v_FirmID,v_CommodityID,v_TradeFee,v_Close_PL,v_CloseAddedTax;
          exit when cur_T_Trade%notfound;
      --更新资金余额，并写手续费流水
      if(v_TradeFee <> 0) then
          v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15001',v_TradeFee,v_A_TradeNo,v_CommodityID,null,null);
        end if;
      --更新资金余额，并写付交易盈利,收交易亏损 流水
      if(v_Close_PL > 0) then
        v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15006',v_Close_PL,v_A_TradeNo,v_CommodityID,v_CloseAddedTax,null);
      elsif(v_Close_PL < 0) then
        v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15007',-v_Close_PL,v_A_TradeNo,v_CommodityID,-v_CloseAddedTax,null);
      end if;
      end loop;
        close cur_T_Trade;
  end if;
    return 1;
end;
/

prompt
prompt Creating procedure SP_F_UNFROZENALLFUNDS
prompt ========================================
prompt
create or replace procedure SP_F_UnFrozenAllFunds
(
  p_moduleID char   --交易模块ID 2：远期 3：现货 4：竞价
)
/***
 * 更新冻结资金
 * version 1.0.0.1 此方法公用
 *
 * 返回值：冻结资金余额
 ****/
is
begin
  update f_firmfunds f set frozenfunds=frozenfunds -
    nvl((select frozenfunds from f_frozenfunds where moduleid=p_moduleID and firmid=f.firmid and frozenfunds<>0),0)
  ;

  update f_frozenfunds set frozenfunds=0 where moduleid=p_moduleID and frozenfunds<>0;

  insert into f_log
    (occurtime, type, userid, description)
  values
    (sysdate, 'sysinfo', 'system', 'UnFrozen specifid module funds:'||p_moduleID);

end;
/

prompt
prompt Creating procedure SP_T_CLEARACTION_DONE
prompt ========================================
prompt
create or replace procedure SP_T_ClearAction_Done
(
    p_ActionID   T_ClearStatus.ActionID%type
)
is
    PRAGMA AUTONOMOUS_TRANSACTION;
begin
    update T_ClearStatus
       set status = 'Y',
           FinishTime = sysdate
     where ActionID = p_ActionID;
    commit;
end;
/

prompt
prompt Creating function FN_T_CLOSEMARKETPROCESS
prompt =========================================
prompt
create or replace function FN_T_CloseMarketProcess
return number
/****
 * 闭市结算处理，可多次结算
 * 返回值
 * 1 成功
 * -2 交收处理出错
 * -100 其它错误
****/
as
  v_version varchar2(10):='1.0.0.1';
  v_b_date f_systemstatus.b_date%type;
  v_status f_systemstatus.status%type;
  v_CommodityID varchar2(16);
  v_TradeDate date;
  v_ret           number(5);
  v_SettleMode           number(2);
  v_errorcode number;
  v_errormsg  varchar2(200);
  --商品交收游标
  cursor cur_settle(c_TradeDate date) is select CommodityID from T_Commodity where SettleDate<=c_TradeDate;


  v_sql            varchar2(500);
  v_Balance        number(15,2);
  v_num            number(10);
  v_FirmID         varchar2(32);
  v_customerid     varchar2(40);
  v_Margin         number(15,2):=0;
  v_Assure         number(15,2):=0;
  v_FloatingLossComputeType number(2);
  v_TradeFlowType number(2);
  v_LastFloatingLossComputeType number(2);
  v_FloatLoss         number(15,2):=0;        --计算持仓明细的浮动盈亏合计，正值为浮盈，负为浮亏
  v_bs_flag number(5);
  v_frozenqty number(10);

  --按商品写流水游标
  type cur_CmdtyDaily is ref cursor;
  v_CmdtyDaily cur_CmdtyDaily;

  type cue_qtyAboutCustonerhold is ref cursor;
  v_qtyAboutCustonerhold cue_qtyAboutCustonerhold;

  type cur_HoldFrozen is ref cursor;
  v_HoldFrozen cur_HoldFrozen;

  v_c_customerid varchar2(40);
  v_c_commodityid varchar2(16);
  v_c_bs_flag number(5);
  v_c_frozenqty number(10);
  v_c_gagefrozenqty number(10);


begin
     --对订单系统状态表加锁，防止交易结算并发
   select t.tradedate,t.status into v_b_date,v_status from t_systemstatus t for update;
   update t_systemstatus t
           set t.status = 2,
               t.note = '结算中';
  commit; --此处提交是为了结算中状态外围能看到。



      -- 一、获取交易日期、获取交收模式、浮亏计算方式，结算开始
    select TradeDate into v_TradeDate from T_SystemStatus;
    select SettleMode into v_SettleMode from T_A_Market;
    SP_T_ClearAction_Done(p_actionid => 0);



    -- 二、交收处理
      --如果自动交收的话，则进行交收处理
    if(v_SettleMode = 0) then
        open cur_settle(v_TradeDate);
        loop
          fetch cur_settle into v_CommodityID;
          exit when cur_settle%notfound;
          v_ret := FN_T_SettleProcess(v_CommodityID,0);
          if(v_ret < 0) then
              rollback;
            return -2;
          end if;
       end loop;
        close cur_settle;
      end if;
      SP_T_ClearAction_Done(p_actionid => 1);



      -- 三、重算交易资金
      v_ret := FN_T_ReComputeFunds(0);
      if(v_ret < 0) then
          rollback;
          return -100;
      end if;
      SP_T_ClearAction_Done(p_actionid => 2);



      -- 四、重算浮亏
      v_ret := FN_T_ReComputeFloatLoss();
      if(v_ret < 0) then
          rollback;
          return -100;
      end if;
      SP_T_ClearAction_Done(p_actionid => 3);



      -- 五、延期交易结算
      v_ret := FN_T_D_CloseProcess();
      select FloatingLossComputeType,TradeFlowType into v_FloatingLossComputeType,v_TradeFlowType from T_A_Market;
      v_ret := FN_T_TradeFlow(v_TradeFlowType);
      SP_T_ClearAction_Done(p_actionid => 4);



      --六、退上日结算保证金
      v_sql := 'select FirmID,CommodityID,sum(HoldMargin)-sum(HoldAssure),sum(HoldAssure) from T_H_FirmHoldSum where ClearDate =(select max(ClearDate) from T_H_Market) group by FirmID,CommodityID';
        open v_CmdtyDaily for v_sql;
        loop
            fetch v_CmdtyDaily into v_FirmID,v_CommodityID,v_Margin,v_Assure;
            exit when v_CmdtyDaily%NOTFOUND;
            --更新资金余额，并写退上日结算保证金流水
            if(v_Margin <> 0) then
                v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15003',v_Margin,null,v_CommodityID,v_Assure,null);
            end if;
        end loop;
        close v_CmdtyDaily;
      SP_T_ClearAction_Done(p_actionid => 5);



      -- 七、扣当日结算保证金
      v_sql := 'select FirmID,CommodityID,sum(HoldMargin)-sum(HoldAssure),sum(HoldAssure) from T_FirmHoldSum group by FirmID,CommodityID';
        open v_CmdtyDaily for v_sql;
        loop
            fetch v_CmdtyDaily into v_FirmID,v_CommodityID,v_Margin,v_Assure;
            exit when v_CmdtyDaily%NOTFOUND;
            --更新资金余额，并写退上日结算保证金流水
            if(v_Margin <> 0) then
                v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15002',v_Margin,null,v_CommodityID,v_Assure,null);
            end if;
        end loop;
        close v_CmdtyDaily;
      SP_T_ClearAction_Done(p_actionid => 6);




      -- 八、如果存在上日交易的数据则退上日浮亏
      select count(*) into v_num from T_H_Market where ClearDate =(select max(ClearDate) from T_H_Market);
      if(v_num >0) then
        --获取上一交易日的浮亏计算方式
        select FloatingLossComputeType into v_LastFloatingLossComputeType from T_H_Market where ClearDate =(select max(ClearDate) from T_H_Market);
        if(v_LastFloatingLossComputeType = 0) then     --商品分买卖
            v_sql := 'select FirmID,CommodityID,sum(case when FloatingLoss>0 then 0 else -FloatingLoss end) from T_H_FirmHoldSum where ClearDate =(select max(ClearDate) from T_H_Market) group by FirmID,CommodityID';
            open v_CmdtyDaily for v_sql;
            loop
                fetch v_CmdtyDaily into v_FirmID,v_CommodityID,v_FloatLoss;
                exit when v_CmdtyDaily%NOTFOUND;
                --更新资金余额，并写退上日浮亏流水
                if(v_FloatLoss <> 0) then
                  v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15005',v_FloatLoss,null,v_CommodityID,null,null);
                end if;
            end loop;
            close v_CmdtyDaily;
        elsif(v_LastFloatingLossComputeType = 1) then  --商品不分买卖
            v_sql := 'select FirmID,CommodityID,sum(FloatingLoss) from T_H_FirmHoldSum where ClearDate =(select max(ClearDate) from T_H_Market) group by FirmID,CommodityID';
            open v_CmdtyDaily for v_sql;
            loop
                fetch v_CmdtyDaily into v_FirmID,v_CommodityID,v_FloatLoss;
                exit when v_CmdtyDaily%NOTFOUND;
                if(v_FloatLoss <= 0) then
                  v_FloatLoss := -v_FloatLoss;
                  --更新资金余额，并写退上日浮亏流水
                  if(v_FloatLoss <> 0) then
                    v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15005',v_FloatLoss,null,v_CommodityID,null,null);
                  end if;
                end if;
            end loop;
            close v_CmdtyDaily;
        elsif(v_LastFloatingLossComputeType = 2) then  --不分商品
            v_sql := 'select FirmID,case when sum(FloatingLoss) >0 then 0 else  -sum(FloatingLoss) end from T_H_FirmHoldSum where ClearDate =(select max(ClearDate) from T_H_Market) group by FirmID ';
            open v_CmdtyDaily for v_sql;
            loop
                fetch v_CmdtyDaily into v_FirmID,v_FloatLoss;
                exit when v_CmdtyDaily%NOTFOUND;
                --更新资金余额，并写退上日浮亏流水
                if(v_FloatLoss <> 0) then
                    v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15016',v_FloatLoss,null,null,null,null);
                end if;
            end loop;
            close v_CmdtyDaily;
        elsif(v_LastFloatingLossComputeType = 3 or v_LastFloatingLossComputeType = 4) then  --盘中算盈亏或不算盈亏
            v_sql := 'select FirmID,-sum(FloatingLoss) from T_H_FirmHoldSum where ClearDate =(select max(ClearDate) from T_H_Market) group by FirmID ';
            open v_CmdtyDaily for v_sql;
            loop
                fetch v_CmdtyDaily into v_FirmID,v_FloatLoss;
                exit when v_CmdtyDaily%NOTFOUND;
                --更新资金余额，并写退上日浮亏流水
                if(v_FloatLoss <> 0) then
                    v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15016',v_FloatLoss,null,null,null,null);
                end if;
            end loop;
            close v_CmdtyDaily;
        end if;
      end if;
      SP_T_ClearAction_Done(p_actionid => 7);




      -- 九、扣除当天结算浮亏
      if(v_FloatingLossComputeType = 0) then     --商品分买卖
          v_sql := 'select FirmID,CommodityID,sum(case when FloatingLoss>0 then 0 else -FloatingLoss end) from T_FirmHoldSum group by FirmID,CommodityID';
          open v_CmdtyDaily for v_sql;
          loop
              fetch v_CmdtyDaily into v_FirmID,v_CommodityID,v_FloatLoss;
              exit when v_CmdtyDaily%NOTFOUND;
              --更新资金余额，并写扣除当日浮亏流水
              if(v_FloatLoss <> 0) then
                 v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15004',v_FloatLoss,null,v_CommodityID,null,null);
              end if;
          end loop;
          close v_CmdtyDaily;
      elsif(v_FloatingLossComputeType = 1) then  --商品不分买卖
          v_sql := 'select FirmID,CommodityID,sum(FloatingLoss) from T_FirmHoldSum group by FirmID,CommodityID';
          open v_CmdtyDaily for v_sql;
          loop
              fetch v_CmdtyDaily into v_FirmID,v_CommodityID,v_FloatLoss;
              exit when v_CmdtyDaily%NOTFOUND;
              if(v_FloatLoss <= 0) then
                v_FloatLoss := -v_FloatLoss;
                --更新资金余额，并写扣除当日浮亏流水
                if(v_FloatLoss <> 0) then
                    v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15004',v_FloatLoss,null,v_CommodityID,null,null);
                end if;
              end if;
          end loop;
          close v_CmdtyDaily;
      elsif(v_FloatingLossComputeType = 2) then  --不分商品
          v_sql := 'select FirmID,case when sum(FloatingLoss) >0 then 0 else -sum(FloatingLoss) end from T_FirmHoldSum group by FirmID ';
          open v_CmdtyDaily for v_sql;
          loop
              fetch v_CmdtyDaily into v_FirmID,v_FloatLoss;
              exit when v_CmdtyDaily%NOTFOUND;
              --更新资金余额，并写扣除当日浮亏流水
              if(v_FloatLoss <> 0) then
                  v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15015',v_FloatLoss,null,null,null,null);
              end if;
          end loop;
          close v_CmdtyDaily;
      elsif(v_FloatingLossComputeType = 3 or v_FloatingLossComputeType = 4) then  --盘中算盈亏或不算盈亏
          v_sql := 'select FirmID,-sum(FloatingLoss) from T_FirmHoldSum group by FirmID ';
          open v_CmdtyDaily for v_sql;
          loop
              fetch v_CmdtyDaily into v_FirmID,v_FloatLoss;
              exit when v_CmdtyDaily%NOTFOUND;
              --更新资金余额，并写扣除当日浮亏流水
              if(v_FloatLoss <> 0) then
                  v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15015',v_FloatLoss,null,null,null,null);
              end if;
          end loop;
          close v_CmdtyDaily;
      end if;
      SP_T_ClearAction_Done(p_actionid => 8);



      -- 十、更新交易商资金
        --1、更新虚拟资金为0,上日结算资金更新为当日结算资金，上日的交收保证金更新为当日的
        update T_Firm set VirtualFunds=0,ClearMargin=RuntimeMargin,ClearAssure=RuntimeAssure,ClearFL=RuntimeFL,ClearSettleMargin=RuntimeSettleMargin;
        --2、删除历史当日数据并导入历史交易商信息表
        delete from T_H_Firm where ClearDate=v_TradeDate;
        insert into T_H_Firm select v_TradeDate,a.* from T_Firm a;
        --3、更新当日历史交易商表中的上日的资金为上一交易日的当日资金
        --故意用sum求和(一个交易商只有一条记录)，解决更新时没有记录报错
        update T_H_Firm a
          set (ClearFL,ClearMargin,ClearAssure,ClearSettleMargin) =
          (
            select nvl(sum(RuntimeFL),0),nvl(sum(RuntimeMargin),0),nvl(sum(RuntimeAssure),0),nvl(sum(RuntimeSettleMargin),0)
            from T_H_Firm
            where ClearDate =(select max(ClearDate) from T_H_Firm where ClearDate<v_TradeDate) and FirmID=a.FirmID
          )
        where a.ClearDate=v_TradeDate;
      SP_T_ClearAction_Done(p_actionid => 9);



      -- 十一、导入历史数据

        --导入历史数据并删除当日数据
        --1、导入历史委托表并删除当日数据
        insert into T_H_Orders select v_TradeDate,a.* from T_Orders a;
        delete from T_Orders;
        --2、导入历史成交表并删除当日数据
        insert into T_H_Trade select v_TradeDate,a.* from T_Trade a;
        delete from T_Trade;
        --3、导入历史广播消息并删除当日数据
        --insert into T_H_Broadcast select v_TradeDate,a.* from T_Broadcast a;
        --delete from T_Broadcast;

        --删除历史当日数据并导入当日历史数据
        --1、删除历史当日数据并导入历史市场参数表
        delete from T_H_Market where ClearDate=v_TradeDate;
        insert into T_H_Market select v_TradeDate,a.* from T_A_Market a;
        --2、删除历史当日数据并导入历史行情
        delete from T_H_Quotation where ClearDate=v_TradeDate;
        insert into T_H_Quotation select v_TradeDate,a.* from T_Quotation a;
        --3、删除历史当日数据并导入历史商品表
        delete from T_H_Commodity where ClearDate=v_TradeDate;
        insert into T_H_Commodity select v_TradeDate,a.* from T_Commodity a;
        --4、删除历史当日数据并导入历史持仓明细表
        delete from T_H_HoldPosition where ClearDate=v_TradeDate;
        insert into T_H_HoldPosition select v_TradeDate,a.* from T_HoldPosition a;
        --5、删除历史当日数据并导入历史交易客户持仓合计表
        delete from T_H_CustomerHoldSum where ClearDate=v_TradeDate;
        insert into T_H_CustomerHoldSum select v_TradeDate,a.* from T_CustomerHoldSum a;
        --6、删除历史当日数据并导入历史交易商持仓合计表
        delete from T_H_FirmHoldSum where ClearDate=v_TradeDate;
        insert into T_H_FirmHoldSum select v_TradeDate,a.* from T_FirmHoldSum a;
        --7、删除历史当日数据并导入历史交易商特殊保证金表
        delete from T_H_FirmMargin where ClearDate=v_TradeDate;
        insert into T_H_FirmMargin select v_TradeDate,a.* from T_A_FirmMargin a;
        --8、删除历史当日数据并导入历史交易商特殊手续费表
        delete from T_H_FirmFee where ClearDate=v_TradeDate;
        insert into T_H_FirmFee select v_TradeDate,a.* from T_A_FirmFee a;
        SP_T_ClearAction_Done(p_actionid => 10);




      -- 十二、释放冻结数据
      --1、交易客户持仓合计表冻结数量清0
      -- mod by yukx 201040028 为支持提前交收冻结持仓注释下边sql
      --update T_CustomerHoldSum set FrozenQty=0;
      -- mod by yukx 201040028 交易客户持仓合计表的冻结数量和抵顶冻结数量存在不为0的记录时，向系统日志表添加记录
      open v_qtyAboutCustonerhold for select customerid,commodityid,bs_flag,frozenqty,gagefrozenqty from t_customerholdsum order by customerid,commodityid,bs_flag;
      loop
        fetch v_qtyAboutCustonerhold into  v_c_customerid,v_c_commodityid,v_c_bs_flag,v_c_frozenqty,v_c_gagefrozenqty;
        exit when v_qtyAboutCustonerhold%NOTFOUND;
        /*if(v_c_frozenqty+v_c_gagefrozenqty>0) then
             insert into T_SysLog(ID,UserID,Action,CreateTime,Note)
             values(SEQ_T_SYSLOG.Nextval,'SYSTEM','03',sysdate,'v_c_customerid='||v_c_customerid||',v_c_commodityid='||v_c_commodityid||',v_c_bs_flag='||v_c_bs_flag||',v_c_frozenqty='||v_c_frozenqty||',v_c_gagefrozenqty='||v_c_gagefrozenqty);
        end if;*/
      end loop;
      ---- add by tangzy 2010-06-21 交易客户持仓合计冻结数量修改，先清0，再根据提前交收申请的记录来更新冻结数量
      update T_CustomerHoldSum t
        set FrozenQty = 0,
            gagefrozenqty = 0;
      -- 计算买方冻结数量
      /*update T_CustomerHoldSum t
         set FrozenQty = nvl((select sum(quantity)
                               from t_e_applyaheadsettle
                              where customerid_b = t.customerid
                                and commodityid = t.commodityid
                                and status = 1),0)
       where bs_flag = 1;*/
      -- 计算卖方冻结数量
      /*update T_CustomerHoldSum t
         set FrozenQty = nvl((select sum(quantity) - sum(gageqty)
                               from t_e_applyaheadsettle
                              where customerid_s = t.customerid
                                and commodityid = t.commodityid
                                and status = 1),0),
            gagefrozenqty = nvl((select sum(gageqty)
                               from t_e_applyaheadsettle
                              where customerid_s = t.customerid
                                and commodityid = t.commodityid
                                and status = 1),0)
       where bs_flag = 2;*/

       --2、清空当日指定平仓冻结表
       delete from T_SpecFrozenHold;
       --3、释放所有冻结资金
       SP_F_UnFrozenAllFunds('15');

       SP_T_ClearAction_Done(p_actionid => 11);


      -- 十三、返佣操作(调用返佣存储)

      v_ret := FN_BR_BrokerReward();

      SP_T_ClearAction_Done(p_actionid => 12);



      --十四、更新交易客户持仓合计表冻结数量
      open v_HoldFrozen for select customerid,commodityId,bs_flag,FrozenQTY from
        --提前交收
        (select th.customerid,th.commodityId commodityId,th.bs_flag bs_flag,sum(th.FrozenQTY)FrozenQTY from t_holdfrozen th,T_E_ApplyAheadSettle ta where ta.applyid = th.operation and th.frozentype = 0 and  ta.status=1
        group by th.customerid,th.commodityId,th.bs_flag)
        union all
        --协议交收
        (select th.customerid,th.commodityId commodityId,th.bs_flag bs_flag,sum(th.FrozenQTY)FrozenQTY from t_holdfrozen th,T_E_ApplyTreatySettle ta where ta.applyid = th.operation and th.frozentype = 1 and  ta.status=1
        group by th.customerid,th.commodityId,th.bs_flag)
        union all
        --非交易过户
        (select th.customerid,th.commodityId commodityId,th.bs_flag bs_flag,sum(th.FrozenQTY)FrozenQTY from t_holdfrozen th,T_UnTradeTransfer ta where ta.transferID = th.operation and th.frozentype = 2 and  ta.status=0
        group by th.customerid,th.commodityId,th.bs_flag)
        union all
        --抵顶
        (select th.customerid,th.commodityId commodityId,th.bs_flag bs_flag,sum(th.FrozenQTY)FrozenQTY from t_holdfrozen th,T_E_ApplyGage ta where ta.ApplyID = th.operation and th.frozentype = 3 and  ta.status=1 and ta.applytype=1
        group by th.customerid,th.commodityId,th.bs_flag);
      loop
          fetch v_HoldFrozen into v_customerid,v_CommodityID,v_bs_flag,v_frozenqty;
          exit when v_HoldFrozen%NOTFOUND;
               update t_customerholdsum  t set FrozenQty = FrozenQty + v_frozenqty where t.customerid = v_customerid and t.commodityid = v_CommodityID and t.bs_flag = v_bs_flag;
       end loop;
       close v_HoldFrozen;

      -- 十五、修改交易系统状态为交易结算完成
      update T_SystemStatus set TradeDate=v_TradeDate,Status=10,SectionID=null,Note=null,RecoverTime=null;
      SP_T_ClearAction_Done(p_actionid => 13);
    commit;
    return 1;
exception
    when others then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_CloseMarketProcess',v_errorcode,v_errormsg);
    -- 恢复状态为未结算
        update t_systemstatus t
           set t.status = 7,
               t.note = '交易结束';
        commit;
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_T_COMPUTEORDERNO
prompt =====================================
prompt
create or replace function FN_T_ComputeOrderNo(
    p_OrderSeq number --委托seq
) return number
/****
 * 计算委托单号
 * 返回值 成功返回委托单号(yyMMdd+序号构成，如101122000001)
****/
as
	v_version varchar2(10):='1.0.4.3';
    v_TradeDate number(10) ;
    v_A_OrderNo number(15) ;
    v_No number(15) ;
begin
	select TradeDate,A_OrderNo into v_TradeDate,v_A_OrderNo from T_CurMinNo;
	v_No := p_OrderSeq-v_A_OrderNo;
    --return v_TradeDate * power(10,length(v_No)) + v_No;
	if (length(v_No) < 7) then
		return v_TradeDate * power(10,6) + v_No;
	else
		return v_TradeDate * power(10,length(v_No)) + v_No;
	end if;

end;
/

prompt
prompt Creating function FN_T_CLOSEORDER
prompt =================================
prompt
create or replace function FN_T_CloseOrder(
    p_FirmID     varchar2,   --交易商ID
    p_TraderID       varchar2,  --交易员ID
    p_CommodityID varchar2 default null,
    p_bs_flag        number default null,
    p_price          number default null,
    p_quantity       number default null,
    p_closeMode      number default null,
    p_specPrice      number default null,
    p_timeFlag       number default null,
    p_closeFlag      number default null,   --平仓标志
    p_CloseAlgr        number,    --平仓算法(0先开先平；1后开先平；2持仓均价平仓)，指定平仓时会传递此值否则为null
    p_CustomerID     varchar2,  --交易客户ID
    p_ConsignerID       varchar2,  --委托员ID
    p_specialOrderFlag       number  --是否特殊委托(0：正常委托 1：特殊委托) 特殊委托只能和特殊委托成交
) return number
/****
 * 平仓委托
 * 返回值
 * >0  成功提交，并返回委托单号
 * -21  持仓不足
 * -22  指定仓不足
 * -99  不存在相关数据
 * -100 其它错误
****/
as
    v_version varchar2(10):='1.0.2.2';
    v_HoldSum        number(10);   --持仓合计
    v_SpecHoldSum    number(10);   --指定持仓合计
    v_SpecHoldFrozen    number(10);   --当日持仓冻结
    v_A_OrderNo      number(15);   --委托号
    v_OrderType      number(2);    --委托类型
    v_errorcode number;
    v_errormsg  varchar2(200);
    v_sql  varchar2(1000);
    v_str1  varchar2(100);
    v_str2  varchar2(500);
    v_orderby  varchar2(50);
    v_A_HoldNo       number(15);
    v_unCloseQty     number(10):=p_quantity; --未平数量，用于中间计算
    type c_HoldPosition is ref cursor;
    v_HoldPosition c_HoldPosition;
    v_TradeDate date;
begin
    --1、判断总数量，并锁住持仓合计记录
    begin
        select nvl(holdQty - frozenQty, 0) into v_HoldSum
        from T_CustomerHoldSum
        where CustomerID = p_CustomerID
          and CommodityID = p_CommodityID
          and bs_flag != p_bs_flag for update;
    exception
        when NO_DATA_FOUND then
            rollback;
            return -21;  --持仓不足
    end;
    if(v_HoldSum < p_quantity) then
        rollback;
        return -21;  --持仓不足
    end if;
    --取结算日期
    select TradeDate into v_TradeDate from T_SystemStatus;
    --2、判断指定平仓数量
    if(p_closeMode != 1) then
        if(p_closeMode = 2) then  --指定时间平仓
            if(p_timeFlag = 1) then  --平今仓
                --从持仓信息表获得该客户当日该商品持仓合计
                v_str1 := ' and to_char(AtClearDate,''yyyy-MM-dd'')=''' || to_char(v_TradeDate,'yyyy-MM-dd') || ''' ';
            elsif(p_timeFlag = 2) then  --平历史仓
                    --从持仓信息表获得该客户非当日该商品持仓合计
                    v_str1 := ' and to_char(AtClearDate,''yyyy-MM-dd'')<>''' || to_char(v_TradeDate,'yyyy-MM-dd') || ''' ';
            else
                    rollback;
                    Raise_application_error(-20010, 'p_timeFlag ' || p_timeFlag || ' not exist!');
            end if;
        elsif(p_closeMode = 3) then  --指定价格平仓
                    --从持仓信息表获得该客户该价位该商品持仓合计
                    v_str1 := ' and Price =' || p_specPrice;
        else   --未知平仓
                    rollback;
                    Raise_application_error(-20011, 'p_closeMode ' || p_closeMode || ' not exist!');
        end if;
        v_str2 := ' and CustomerID=''' || p_CustomerID || ''' and CommodityID =''' || p_CommodityID || ''' and bs_flag != ' || p_bs_flag || ' ' || v_str1;
        v_sql := 'select nvl(sum(HoldQty),0)  from T_HoldPosition where 1=1 ' || v_str2;
        execute immediate v_sql into v_SpecHoldSum;

        v_sql := 'select nvl(sum(FrozenQty),0) from T_SpecFrozenHold where A_HoldNo in(select A_HoldNo  from T_HoldPosition where 1=1 ' || v_str2 || ')';
        execute immediate v_sql into v_SpecHoldFrozen;
        if(v_SpecHoldSum - v_SpecHoldFrozen < p_quantity) then
            rollback;
            return -22;  --指定仓不足
        end if;
    end if;
    --3、更新交易客户持仓合计的冻结数量
    update T_CustomerHoldSum set frozenQty = frozenQty + p_quantity
    where CustomerID = p_CustomerID
    and CommodityID = p_CommodityID
    and bs_flag != p_bs_flag;
    --4、产生委托单号并插入委托表
	--调用计算函数修改委托单号 2011-2-15 by feijl
    select FN_T_ComputeOrderNo(SEQ_T_Orders.nextval) into v_A_OrderNo from dual;
    insert into T_Orders
      ( a_orderno,  a_orderno_w,   CommodityID,   Firmid,    traderid,   bs_flag,   ordertype, status, quantity, price, closemode, specprice,       timeflag,tradeqty, frozenfunds, unfrozenfunds, ordertime, withdrawtime, ordererip, signature,closeFlag,   CustomerID,ConsignerID,specialOrderFlag)
    values
      (v_A_OrderNo,   null,        p_CommodityID, p_Firmid,  p_traderid, p_bs_flag,     2,        1,  p_quantity, p_price, p_closemode, p_specprice, p_timeflag, 0,        0,              0,         sysdate,      null,       null,     null,  p_closeFlag,p_CustomerID,p_ConsignerID,p_specialOrderFlag);
    --5、指定平仓时冻结持仓单号，委托单号，数量
    if(p_closeMode != 1) then
        v_sql := 'select a.A_HoldNo,(a.HoldQty-nvl(b.FrozenQty,0)) from T_HoldPosition a,(select A_HoldNo,nvl(sum(FrozenQty),0) FrozenQty from T_SpecFrozenHold group by A_HoldNo) b where (a.HoldQty+a.GageQty) > 0 and a.A_HoldNo=b.A_HoldNo(+) and nvl(b.FrozenQty,0)<a.HoldQty ' || v_str2 || ' ' ;
        --根据平仓算法(0先开先平；1后开先平；2持仓均价平仓(不排序)选择排序条件
        if(p_CloseAlgr = 0) then
            v_orderby := ' order by a.A_HoldNo ';
        elsif(p_CloseAlgr = 1) then
            v_orderby := ' order by a.A_HoldNo desc ';
        end if;
        v_sql := v_sql || v_orderby;
        open v_HoldPosition for v_sql;
        loop
            fetch v_HoldPosition into v_A_HoldNo, v_SpecHoldSum;
            exit when v_HoldPosition%NOTFOUND;
            if(v_SpecHoldSum <= v_unCloseQty) then
                v_SpecHoldFrozen := v_SpecHoldSum;
            else
                v_SpecHoldFrozen := v_unCloseQty;
            end if;
            insert into T_SpecFrozenHold(ID,    A_HoldNo,   A_OrderNo,  FrozenQty)
            values(SEQ_T_SpecFrozenHold.nextval,v_A_HoldNo,v_A_OrderNo,v_SpecHoldFrozen);
            v_unCloseQty := v_unCloseQty - v_SpecHoldFrozen;
            exit when v_unCloseQty=0;
        end loop;
        close v_HoldPosition;
    end if;
    commit;
    return v_A_OrderNo;
exception
    when NO_DATA_FOUND then
        rollback;
        return -99;  --不存在相关数据
    when others then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_CloseOrder',v_errorcode,v_errormsg);
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_T_COMPUTEFEEBYARGS
prompt =======================================
prompt
create or replace function FN_T_ComputeFeeByArgs(
    p_bs_flag        number,
    p_quantity       number,
    p_price          number,
    p_contractFactor        number,
    p_feeAlgr number,
    p_feeRate_b number,
    p_feeRate_s number
) return number
/****
 * 根据参数计算手续费
 * 返回值 成功返回手续费;-1 计算交易费用所需数据不全;-100 其它错误
****/
as
	v_version varchar2(10):='1.0.0.1';
    v_fee             number(15,2) default 0;
begin
    if(p_feeAlgr=1) then  --应收手续费=数量*合约因子*价格*手续费
    	if(p_bs_flag = 1) then  --买
        	v_fee:=p_quantity*p_contractFactor*p_price*p_feeRate_b;
        elsif(p_bs_flag = 2) then  --卖
        	v_fee:=p_quantity*p_contractFactor*p_price*p_feeRate_s;
        end if;
    elsif(p_feeAlgr=2) then  --应收手续费=数量*手续费
    	if(p_bs_flag = 1) then  --买
        	v_fee:=p_quantity*p_feeRate_b;
        elsif(p_bs_flag = 2) then  --卖
        	v_fee:=p_quantity*p_feeRate_s;
        end if;
    end if;
    if(v_fee is null) then
    	rollback;
        return -1;
    end if;
    return v_fee;
exception
    when no_data_found then
    	rollback;
        return -1;
    when others then
    	rollback;
   		return -100;
end;
/

prompt
prompt Creating function FN_T_COMPUTETRADENO
prompt =====================================
prompt
create or replace function FN_T_ComputeTradeNo(
    p_TradeSeq number --成交seq
) return number
/****
 * 计算成交单号
 * 返回值 成功返回成交单号(yyMMdd+序号构成，如101122000001)
****/
as
	v_version varchar2(10):='1.0.4.3';
    v_TradeDate number(10) ;
    v_A_TradeNo number(15) ;
    v_No number(15) ;
begin
	select TradeDate,A_TradeNo into v_TradeDate,v_A_TradeNo from T_CurMinNo;
	v_No := p_TradeSeq-v_A_TradeNo;
    --return v_TradeDate * power(10,length(v_No)) + v_No;
	if (length(v_No) < 7) then
		return v_TradeDate * power(10,6) + v_No;
	else
		return v_TradeDate * power(10,length(v_No)) + v_No;
	end if;

end;
/

prompt
prompt Creating function FN_T_CLOSETRADE
prompt =================================
prompt
create or replace function FN_T_CloseTrade(
    p_A_OrderNo     number,  --委托单号
    p_M_TradeNo     number,  --撮合成交号
    p_Price         number,  --成交价
    p_Quantity      number,   --成交数量
    p_M_TradeNo_Opp     number,  --对方撮合成交号
    p_CommodityID varchar2,
    p_FirmID     varchar2,
    p_TraderID       varchar2,
    p_bs_flag        number,
    p_status         number,
    p_orderQty       number,--委托数量
    p_orderTradeQty       number,--委托已成交数量
    p_CustomerID        varchar2,
    p_OrderType      number,
    p_closeMode      number,
    p_specPrice      number,
    p_timeFlag       number,
    p_CloseFlag      number,
    p_contractFactor number,
    p_MarginPriceType         number,     --计算成交保证金结算价类型 0:实时和闭市时都按开仓价；1:实时按昨结算价，闭市按当日结算价;2:盘中按订立价，闭市结算时按当日结算价;
    p_marginAlgr         number,
    p_marginRate_b         number,
    p_marginRate_s         number,
    p_marginAssure_b         number,
    p_marginAssure_s         number,
    p_feeAlgr       number,
    p_feeRate_b         number,
    p_feeRate_s         number,
    p_TodayCloseFeeRate_B         number,
    p_TodayCloseFeeRate_S         number,
    p_HistoryCloseFeeRate_B         number,
    p_HistoryCloseFeeRate_S         number,
    p_ForceCloseFeeAlgr       number,
    p_ForceCloseFeeRate_B         number,
    p_ForceCloseFeeRate_S         number,
    p_YesterBalancePrice    number,
    p_AddedTaxFactor          number,  --增值税率系数=AddedTax/(1+AddedTax)
    p_GageMode    number,
    p_CloseAlgr    number,
    p_TradeDate date,
    p_FirmID_opp     varchar2   --对手交易商ID
) return number
/****
 * 平仓成交回报
 * 1、注意不要提交commit，因为别的函数要调用它；
 * 返回值
 * 1 成功
 * -1 成交数量大于未成交数量
 * -2 成交数量大于冻结数量
 * -3 平仓成交数量大于持仓数量
 * -100 其它错误
****/
as
    v_version varchar2(10):='1.0.2.2';
    v_price          number(15,2);
    v_frozenQty      number(10);
    v_holdQty        number(10);
    v_a_tradeno_closed number(15);
    v_Margin         number(15,2):=0;   --应收保证金
    v_Assure         number(15,2):=0;   --应收担保金
    v_Fee            number(15,2):=0;   --应收费用
    v_Fee_one            number(15,2);   --应收费用
    v_A_TradeNo      number(15);
    v_A_HoldNo       number(15);
    v_id             number(15);
    v_tmp_bs_flag    number(2);
    v_TradeType      number(1);
    v_AtClearDate          date;
    v_HoldTime          date;
    v_MarginPrice    number(15,2);  --计算成交保证金的价格
    v_HoldFunds    number(15,2):=0;  --平仓时应退持仓金额
    v_unCloseQty     number(10):=p_quantity; --未平数量，用于中间计算
    v_closeFL    number(15,2):=0;
    v_closeFL_one    number(15,2);   --单笔平仓盈亏，用于中间计算
    v_CloseAddedTax_one    number(15,2);   --单笔平仓增值税
    v_margin_one     number(15,2);   --用于中间计算
    v_Assure_one     number(15,2);   --用于中间计算
    v_tradedAmount   number(10):=0;  --成交数量
    v_GageQty       number(10);
    v_GageQty_fsum       number(10);
    v_F_FrozenFunds   number(15,2);
    type c_T_HoldPosition is ref cursor;
    v_T_HoldPosition c_T_HoldPosition;
    v_sql varchar2(500);
    v_str  varchar2(200);
    v_orderby  varchar2(100);
    v_closeTodayHis        number(2);    --平今仓还是历史仓(0平今仓；1平历史仓)
    v_num            number(10);
    v_holddaysLimit number(1):=0;
begin
      if(p_TraderID is not null) then
          v_TradeType := 1;  --有交易员为正常交易（开，平仓）
      else
        if(p_CloseFlag = 2) then
          v_TradeType := 3;  --交易员为空且平仓标志为2表示市场强平
        else
          v_TradeType := 4;  --否则有交易员的表示委托交易（开，平仓）
        end if;
      end if;

        if(p_bs_flag=1) then  --委托平仓的买卖标志
            v_tmp_bs_flag:=2; --相当于被平仓的买卖标志
        else
            v_tmp_bs_flag:=1;
        end if;
        select frozenqty
        into v_frozenQty
        from T_CustomerHoldSum
        where CustomerID = p_CustomerID
          and CommodityID = p_CommodityID
          and bs_flag = v_tmp_bs_flag for update;
        if(v_frozenqty <p_quantity) then
            rollback;
            return -2;
        end if;

    --指定平仓查询条件
        if(p_closeMode = 2) then  --指定时间平仓
            if(p_timeFlag = 1) then  --平今仓
                --从持仓明细表获得该交易客户当日该商品持仓合计
                v_str := ' and to_char(AtClearDate,''yyyy-MM-dd'')=''' || to_char(p_TradeDate,'yyyy-MM-dd') || ''' ';
          elsif(p_timeFlag = 2) then  --平历史仓
                  --从持仓明细表获得该交易客户非当日该商品持仓合计
                  v_str := ' and to_char(AtClearDate,''yyyy-MM-dd'')<>''' || to_char(p_TradeDate,'yyyy-MM-dd') || ''' ';
          end if;
        elsif(p_closeMode = 3) then  --指定价格平仓
            v_str := ' and Price =' || p_specPrice || ' ';
        end if;
        --根据平仓算法(0先开先平；1后开先平；2持仓均价平仓(不排序)选择排序条件
    --2009-08-04增加强平时按后开先平顺序
    if(p_TraderID is null and p_CloseFlag = 2) then
      --v_orderby := ' order by a.A_HoldNo desc ';
             select holddayslimit into v_holddaysLimit from t_commodity where commodityid=p_CommodityID;
             if(v_holddaysLimit=0) then   --无持仓天数限制
               v_orderby := ' order by a.A_HoldNo desc ';
             else
               v_orderby := ' order by a.A_HoldNo asc ';
             end if;
        else
          if(p_CloseAlgr = 0) then
            v_orderby := ' order by a.A_HoldNo ';
        elsif(p_CloseAlgr = 1) then
            v_orderby := ' order by a.A_HoldNo desc ';
        end if;
      end if;
      v_str := v_str || v_orderby;

          if(p_Quantity = p_orderQty - p_orderTradeQty) then
            --更新委托
            update T_Orders
            set tradeqty=tradeqty + p_Quantity,
                Status=3,UpdateTime=systimestamp(3)
            where A_orderNo = p_A_OrderNo;
          elsif(p_Quantity < p_orderQty - p_orderTradeQty) then
            --更新委托
      if(p_status = 6) then  --状态为部分成交后撤单，如果部分成交回报在撤单回报之后，不用再更新状态了
              update T_Orders
              set tradeqty=tradeqty + p_Quantity,UpdateTime=systimestamp(3)
              where A_orderNo = p_A_OrderNo;
      else
              update T_Orders
              set tradeqty=tradeqty + p_Quantity,Status=2,UpdateTime=systimestamp(3)
              where A_orderNo = p_A_OrderNo;
      end if;
          else
            rollback;
            return -1;
          end if;

            --不指定平仓平持仓记录时以持仓明细表为主，而指定平仓时以当日指定平仓冻结表为主
            if(p_closeMode = 1) then --不指定平仓
              --遍历持仓明细的数量并过滤掉指定平仓冻结的数量,此平仓没用到b.ID，因为b中没有它，所以用0替换
              v_sql := 'select a.a_holdno,a_tradeno,price,(a.HoldQty-nvl(b.FrozenQty,0)),GageQty,HoldTime,AtClearDate,nvl(b.FrozenQty,0),0 from T_holdposition a,(select A_HoldNo,nvl(sum(FrozenQty),0) FrozenQty from T_SpecFrozenHold group by A_HoldNo) b ' ||
                       ' where (a.HoldQty+a.GageQty) > 0 and a.A_HoldNo=b.A_HoldNo(+) and nvl(b.FrozenQty,0)<a.HoldQty and CustomerID=''' || p_CustomerID ||
                       ''' and CommodityID =''' || p_CommodityID || ''' and bs_flag = ' || v_tmp_bs_flag || v_str;
      else  --指定平仓
              v_sql := 'select a.a_holdno,a_tradeno,price,HoldQty,GageQty,HoldTime,AtClearDate,nvl(b.FrozenQty,0),b.ID from T_holdposition a,T_SpecFrozenHold b ' ||
                       ' where (a.HoldQty+a.GageQty) > 0 and b.A_HoldNo=a.A_HoldNo(+) and b.A_OrderNo= ' || p_A_OrderNo || v_str;
      end if;
            open v_T_HoldPosition for v_sql;
            loop
                fetch v_T_HoldPosition into v_a_holdno, v_a_tradeno_closed, v_price, v_holdqty,v_GageQty,v_HoldTime,v_AtClearDate,v_frozenQty,v_id;
                exit when v_T_HoldPosition%NOTFOUND;
                if(p_closeMode = 1) then --不指定平仓
                  if(v_holdqty<=v_unCloseQty) then
                      v_tradedAmount:=v_holdqty;
                  else
                      v_tradedAmount:=v_unCloseQty;
                  end if;
                else  --指定平仓
                  if(v_frozenQty<=v_unCloseQty) then
                      v_tradedAmount:=v_frozenQty;
                      delete from T_SpecFrozenHold where id=v_id;
                  else
                      v_tradedAmount:=v_unCloseQty;
                      update T_SpecFrozenHold set FrozenQty=FrozenQty-v_tradedAmount where id=v_id;
                  end if;
        end if;
        --判断是平今仓还是平历史仓
          if(trunc(p_TradeDate) = trunc(v_AtClearDate)) then
              v_closeTodayHis := 0;
          else
            v_closeTodayHis := 1;
          end if;
            --计算成交后应扣除的手续费
        if(v_TradeType = 3) then  --强平
          v_Fee_one := FN_T_ComputeFeeByArgs(p_bs_flag,v_tradedAmount,p_Price,p_contractFactor,p_ForceCloseFeeAlgr,p_ForceCloseFeeRate_B,p_ForceCloseFeeRate_S);
        else  --其它，如果平的是今天开的仓则按今开今平手续费计算
          if(v_closeTodayHis = 0) then  --平今仓
            v_Fee_one := FN_T_ComputeFeeByArgs(p_bs_flag,v_tradedAmount,p_Price,p_contractFactor,p_feeAlgr,p_TodayCloseFeeRate_B,p_TodayCloseFeeRate_S);
          else  --平历史仓
                v_Fee_one := FN_T_ComputeFeeByArgs(p_bs_flag,v_tradedAmount,p_Price,p_contractFactor,p_feeAlgr,p_HistoryCloseFeeRate_B,p_HistoryCloseFeeRate_S);
            end if;
          end if;
                if(v_Fee_one < 0) then
                  Raise_application_error(-20030, 'computeFee error');
                end if;
                --计算应退保证金，根据设置选择开仓价还是昨结算价来算
        if(p_MarginPriceType = 1) then
              v_MarginPrice := p_YesterBalancePrice;
          elsif(p_MarginPriceType = 2) then
          if(v_closeTodayHis = 0) then  --平今仓
            v_MarginPrice := v_price;
          else  --平历史仓
                v_MarginPrice := p_YesterBalancePrice;
            end if;
        else  -- default type is 0
          v_MarginPrice := v_price;
        end if;
                v_Margin_one := FN_T_ComputeMarginByArgs(v_tmp_bs_flag,v_tradedAmount,v_MarginPrice,p_contractFactor,p_marginAlgr,p_marginRate_b,p_marginRate_s);
                if(v_Margin_one < 0) then
                    Raise_application_error(-20040, 'computeMargin error');
                end if;
            --计算担保金
            v_Assure_one := FN_T_ComputeAssureByArgs(v_tmp_bs_flag,v_tradedAmount,v_MarginPrice,p_contractFactor,p_marginAlgr,p_marginAssure_b,p_marginAssure_s);
            if(v_Assure_one < 0) then
                Raise_application_error(-20040, 'computeAssure error');
            end if;
            --保证金应加上担保金
            v_Margin_one := v_Margin_one + v_Assure_one;

              --计算应退持仓金额
              v_HoldFunds := v_HoldFunds + v_tradedAmount*v_price*p_contractFactor;
                --计算平仓盈亏
                if(v_tmp_bs_flag=1) then  --v_tmp_bs_flag是持仓的买卖标志
                    v_closeFL_one := v_tradedAmount*(p_price-v_price)*p_contractFactor; --税前盈亏
                else
                    v_closeFL_one := v_tradedAmount*(v_price-p_price)*p_contractFactor; --税前盈亏
                end if;
              --计算平仓增值税,v_AddedTaxFactor增值税系数=AddedTax/(1+AddedTax) xief 20150811
            --  v_CloseAddedTax_one := round(v_closeFL_one*p_AddedTaxFactor,2);
                v_CloseAddedTax_one := 0;
                v_closeFL_one := v_closeFL_one - v_CloseAddedTax_one; --税后盈亏
        --调用计算函数修改成交单号 2011-2-15 by feijl
                select FN_T_ComputeTradeNo(SEQ_T_Trade.nextval) into v_A_TradeNo from dual;
                 insert into T_Trade
                  (a_tradeno, m_tradeno, a_orderno, a_tradeno_closed,tradetime, Firmid, CommodityID, bs_flag, ordertype, price, quantity, close_pl, tradefee,TradeType,HoldPrice,HoldTime,CustomerID,CloseAddedTax,M_TradeNo_Opp,AtClearDate,TradeAtClearDate,oppFirmid)
                values
                  (v_A_TradeNo, p_M_TradeNo, p_A_OrderNo, v_a_tradeno_closed, sysdate, p_Firmid, p_CommodityID,p_bs_flag, p_ordertype, p_price, v_tradedAmount, v_closeFL_one, v_Fee_one,v_TradeType,v_price,v_HoldTime,p_CustomerID,v_CloseAddedTax_one,p_M_TradeNo_Opp,v_AtClearDate,p_TradeDate,p_FirmID_opp);

                --更新持仓记录
                update T_holdposition
                set holdqty = holdqty - v_tradedAmount,HoldMargin=HoldMargin-v_Margin_one,HoldAssure=HoldAssure-v_Assure_one
                where a_holdno = v_a_holdno;
                v_unCloseQty:=v_unCloseQty - v_tradedAmount;

                v_Margin:=v_Margin + v_Margin_one;
                v_Assure:=v_Assure + v_Assure_one;
                v_Fee:=v_Fee + v_Fee_one;
                v_closeFL:=v_closeFL + v_closeFL_one;

                exit when v_unCloseQty=0;
            end loop;
            close v_T_HoldPosition;
            if(v_unCloseQty>0) then --成交数量大于持仓数量，出错
                rollback;
                return -3;
            end if;

        --减少交易客户，交易商的持仓合计信息2009-10-15
        v_num := FN_T_SubHoldSum(p_quantity,0,v_Margin,v_Assure,p_CommodityID,p_contractFactor,v_tmp_bs_flag,p_FirmID,v_HoldFunds,p_CustomerID,v_HoldFunds,p_GageMode,p_quantity);

        --更新临时保证金和临时担保金
        update T_Firm
        set runtimemargin = runtimemargin - v_Margin,
        RuntimeAssure = RuntimeAssure - v_Assure
        where Firmid = p_FirmID;
        --更新冻结资金，释放个人部分的保证金
    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(p_FirmID,-(v_Margin-v_Assure)+v_Fee-v_closeFL,'15');
    return 1;

end;
/

prompt
prompt Creating function FN_T_COMPUTEFLOATINGLOSS
prompt ==========================================
prompt
create or replace function FN_T_ComputeFloatingLoss(
    p_EvenPrice         number, --持仓均价
    p_Price         number, --行情价
    p_HoldQty number, --持仓数量
    p_ContractFactor    number, --合约因子
    p_BS_Flag number --买卖标志
) return number
/****
 * 计算浮动亏损
 * 返回值 成功返回浮动亏损
****/
as
	v_version varchar2(10):='1.0.0.1';
    v_FL_new number(15,2) default 0;
begin
    --计算浮亏
    v_FL_new := (p_EvenPrice-p_Price)*p_HoldQty*p_ContractFactor;
    --浮亏分买卖来判断，如果浮赢时则置为0
    if(p_BS_Flag = 1) then
        if(v_FL_new < 0) then
          v_FL_new := 0;
        end if;
    else
        if(v_FL_new > 0) then
          v_FL_new := 0;
        end if;
    end if;
    if(v_FL_new < 0) then
      v_FL_new := -v_FL_new;
    end if;
    return v_FL_new;
end;
/

prompt
prompt Creating function FN_T_COMPUTEFLOATINGPROFIT
prompt ============================================
prompt
create or replace function FN_T_ComputeFloatingProfit(
    p_EvenPrice         number, --持仓均价
    p_Price         number, --行情价
    p_HoldQty number, --持仓数量
    p_ContractFactor    number, --合约因子
    p_BS_Flag number --买卖标志
) return number
/****
 * 计算浮动盈亏
 * 返回值 成功返回浮动盈亏
****/
as
	v_version varchar2(10):='1.0.0.1';
    v_FL_new number(15,2) default 0;
begin
    --计算浮动盈亏
    if(p_BS_Flag = 1) then
      v_FL_new := (p_Price-p_EvenPrice)*p_HoldQty*p_ContractFactor;
    else
      v_FL_new := (p_EvenPrice-p_Price)*p_HoldQty*p_ContractFactor;
    end if;
    return v_FL_new;
end;
/

prompt
prompt Creating function FN_T_COMPUTEFORCECLOSEFEE
prompt ===========================================
prompt
create or replace function FN_T_ComputeForceCloseFee(
    p_FirmID     varchar2,
    p_CommodityID varchar2,
    p_bs_flag        number,
    p_quantity       number,
    p_price          number
) return number
/****
 * 计算代为转让(即强平)手续费
 * 返回值 成功返回手续费;-1 计算交易费用所需数据不全;-100 其它错误
****/
as
	v_version varchar2(10):='1.0.0.1';
    v_feeRate_b         number(15,9);
    v_feeRate_s         number(15,9);
    v_feeAlgr       number(2);
    v_contractFactor  number(12,2);
    v_fee             number(15,2) default 0;
begin
    --获取商品信息：合约因子，手续费系数，手续费算法。
    select ForceCloseFeeRate_B,ForceCloseFeeRate_S,ForceCloseFeeAlgr,contractfactor
    into v_feeRate_b,v_feeRate_s,v_feeAlgr,v_contractFactor
    from T_Commodity where CommodityID=p_CommodityID;

    begin
        --获取交易商对应套餐手续费系数，手续费算法
        select ForceCloseFeeRate_B,ForceCloseFeeRate_S,ForceCloseFeeAlgr
   		into v_feeRate_b,v_feeRate_s,v_feeAlgr
        from T_A_Tariff
        where TariffID=(select TariffID from t_firm where FirmID=p_FirmID) and CommodityID=p_CommodityID;
    exception
        when NO_DATA_FOUND then
            null;
    end;

    begin
        --获取特户的手续费系数，手续费算法
        select ForceCloseFeeRate_B,ForceCloseFeeRate_S,ForceCloseFeeAlgr
   		into v_feeRate_b,v_feeRate_s,v_feeAlgr
        from T_A_FirmFee
        where FirmID=p_FirmID and CommodityID=p_CommodityID;
    exception
        when NO_DATA_FOUND then
            null;
    end;
    if(v_feeAlgr=1) then  --应收手续费=数量*合约因子*价格*手续费
    	if(p_bs_flag = 1) then  --买
        	v_fee:=p_quantity*v_contractFactor*p_price*v_feeRate_b;
        elsif(p_bs_flag = 2) then  --卖
        	v_fee:=p_quantity*v_contractFactor*p_price*v_feeRate_s;
        end if;
    elsif(v_feeAlgr=2) then  --应收手续费=数量*手续费
    	if(p_bs_flag = 1) then  --买
        	v_fee:=p_quantity*v_feeRate_b;
        elsif(p_bs_flag = 2) then  --卖
        	v_fee:=p_quantity*v_feeRate_s;
        end if;
    end if;
    if(v_fee is null) then
    	rollback;
        return -1;
    end if;
    return v_fee;
exception
    when no_data_found then
    	rollback;
        return -1;
    when others then
    	rollback;
   		return -100;
end;
/

prompt
prompt Creating function FN_T_COMPUTEFORCECLOSEQTY
prompt ===========================================
prompt
create or replace function FN_T_ComputeForceCloseQty(
       p_firmid varchar2,
       p_commodityid varchar2,
       p_bs_flag number,--持仓买卖方向
       p_quantity number,
       p_price number,
       p_forceCloseprice number
) return number
is
	v_version varchar2(10):='1.0.0.6';
  v_lastprice number(15,2) default 0;--结算价
  v_contractfactor number(15,2) default 0;
  v_forceCloseprice number(15,2) default 0;--参考数量对应一手金额
  v_forceClosePL number(15,2) default 0;--平仓盈亏
  v_computemargin number(15,2) default 0;
  v_computefee number(15,2) default 0;
  v_computefloatingprofit number(15,2) default 0;
  v_addedtaxfactor number(15,6);

begin
    begin
       select price into v_lastprice from t_quotation where commodityID = p_commodityid;
    exception
        when NO_DATA_FOUND then
             return 0;
    end;
    begin
       select ContractFactor,addedtaxfactor into v_contractfactor,v_addedtaxfactor from t_commodity where commodityID = p_commodityid;
    exception
        when NO_DATA_FOUND then
             return 0;
    end;


  --平仓盈亏  xief  20150811
  if (p_bs_flag = 1) then
       v_forceClosePL := (p_forceCloseprice - p_price)*v_contractfactor;
   --  v_forceClosePL := (p_forceCloseprice - p_price)*v_contractfactor*(1 - v_addedtaxfactor);
     --保证金
     v_computemargin := FN_T_COMPUTEMARGIN(p_firmid,p_commodityid,1,p_quantity,v_lastprice);
     --手续费
     v_computefee := fn_t_computefee(p_firmid,p_commodityid,2,p_quantity,p_forceCloseprice);
     --浮动盈亏
     v_computefloatingprofit := fn_t_computefloatingprofit(p_price,v_lastprice,p_quantity,v_contractfactor,1);
     if (v_computefloatingprofit > 0) then
        v_computefloatingprofit := 0;
     end if;
  else
    -- v_forceClosePL := (p_price - p_forceCloseprice)*v_contractfactor*(1 - v_addedtaxfactor);
     v_forceClosePL := (p_price - p_forceCloseprice)*v_contractfactor;
     --保证金
     v_computemargin := FN_T_COMPUTEMARGIN(p_firmid,p_commodityid,2,p_quantity,v_lastprice);
     --手续费
     v_computefee := fn_t_computefee(p_firmid,p_commodityid,1,p_quantity,p_forceCloseprice);
     --浮动盈亏
     v_computefloatingprofit := fn_t_computefloatingprofit(p_price,v_lastprice,p_quantity,v_contractfactor,2);
     if (v_computefloatingprofit > 0) then
        v_computefloatingprofit := 0;
     end if;
  end if;
  v_forceCloseprice := v_computemargin - v_computefee - v_computefloatingprofit + v_forceClosePL;
  return v_forceCloseprice;
end;
/

prompt
prompt Creating function FN_T_COMPUTEHISTORYCLOSEFEE
prompt =============================================
prompt
create or replace function FN_T_ComputeHistoryCloseFee(
    p_FirmID     varchar2,
    p_CommodityID varchar2,
    p_bs_flag        number,
    p_quantity       number,
    p_price          number
) return number
/****
 * 计算平历史仓手续费
 * 返回值 成功返回手续费;-1 计算交易费用所需数据不全;-100 其它错误
****/
as
	v_version varchar2(10):='1.0.0.1';
    v_feeRate_b         number(15,9);
    v_feeRate_s         number(15,9);
    v_feeAlgr       number(2);
    v_contractFactor  number(12,2);
    v_fee             number(15,2) default 0;
begin
    --获取商品信息：合约因子，手续费系数，手续费算法。
    select HistoryCloseFeeRate_B,HistoryCloseFeeRate_S,feealgr,contractfactor
    into v_feeRate_b,v_feeRate_s,v_feeAlgr,v_contractFactor
    from T_Commodity where CommodityID=p_CommodityID;

    begin
        --获取交易商对应套餐手续费系数，手续费算法
        select HistoryCloseFeeRate_B,HistoryCloseFeeRate_S,feealgr
   		into v_feeRate_b,v_feeRate_s,v_feeAlgr
        from T_A_Tariff
        where TariffID=(select TariffID from t_firm where FirmID=p_FirmID) and CommodityID=p_CommodityID;
    exception
        when NO_DATA_FOUND then
            null;
    end;

    begin
        --获取特户的手续费系数，手续费算法
        select HistoryCloseFeeRate_B,HistoryCloseFeeRate_S,feealgr
   		into v_feeRate_b,v_feeRate_s,v_feeAlgr
        from T_A_FirmFee
        where FirmID=p_FirmID and CommodityID=p_CommodityID;
    exception
        when NO_DATA_FOUND then
            null;
    end;
    if(v_feeAlgr=1) then  --应收手续费=数量*合约因子*价格*手续费
    	if(p_bs_flag = 1) then  --买
        	v_fee:=p_quantity*v_contractFactor*p_price*v_feeRate_b;
        elsif(p_bs_flag = 2) then  --卖
        	v_fee:=p_quantity*v_contractFactor*p_price*v_feeRate_s;
        end if;
    elsif(v_feeAlgr=2) then  --应收手续费=数量*手续费
    	if(p_bs_flag = 1) then  --买
        	v_fee:=p_quantity*v_feeRate_b;
        elsif(p_bs_flag = 2) then  --卖
        	v_fee:=p_quantity*v_feeRate_s;
        end if;
    end if;
    if(v_fee is null) then
    	rollback;
        return -1;
    end if;
    return v_fee;
exception
    when no_data_found then
    	rollback;
        return -1;
    when others then
    	rollback;
   		return -100;
end;
/

prompt
prompt Creating function FN_T_COMPUTEHOLDNO
prompt ====================================
prompt
create or replace function FN_T_ComputeHoldNo(
    p_HoldSeq number --持仓seq
) return number
/****
 * 计算持仓单号
 * 返回值 成功返回持仓单号(yyMMdd+序号构成，如101122000001)
****/
as
	v_version varchar2(10):='1.0.4.3';
    v_TradeDate number(10) ;
    v_A_HoldNo number(15) ;
    v_No number(15) ;
begin
	select TradeDate,A_HoldNo into v_TradeDate,v_A_HoldNo from T_CurMinNo;
	v_No := p_HoldSeq-v_A_HoldNo;
    --return v_TradeDate * power(10,length(v_No)) + v_No;
    if (length(v_No) < 7) then
		return v_TradeDate * power(10,6) + v_No;
	else
		return v_TradeDate * power(10,length(v_No)) + v_No;
	end if;
end;
/

prompt
prompt Creating function FN_T_COMPUTETODAYCLOSEFEE
prompt ===========================================
prompt
create or replace function FN_T_ComputeTodayCloseFee(
    p_FirmID     varchar2,
    p_CommodityID varchar2,
    p_bs_flag        number,
    p_quantity       number,
    p_price          number
) return number
/****
 * 计算平今仓手续费
 * 返回值 成功返回手续费;-1 计算交易费用所需数据不全;-100 其它错误
****/
as
	v_version varchar2(10):='1.0.0.1';
    v_feeRate_b         number(15,9);
    v_feeRate_s         number(15,9);
    v_feeAlgr       number(2);
    v_contractFactor  number(12,2);
    v_fee             number(15,2) default 0;
begin
    --获取商品信息：合约因子，手续费系数，手续费算法。
    select TodayCloseFeeRate_B,TodayCloseFeeRate_S,feealgr,contractfactor
    into v_feeRate_b,v_feeRate_s,v_feeAlgr,v_contractFactor
    from T_Commodity where CommodityID=p_CommodityID;

    begin
        --获取交易商对应套餐手续费系数，手续费算法
        select TodayCloseFeeRate_B,TodayCloseFeeRate_S,feealgr
   		into v_feeRate_b,v_feeRate_s,v_feeAlgr
        from T_A_Tariff
        where TariffID=(select TariffID from t_firm where FirmID=p_FirmID) and CommodityID=p_CommodityID;
    exception
        when NO_DATA_FOUND then
            null;
    end;

    begin
        --获取特户的手续费系数，手续费算法
        select TodayCloseFeeRate_B,TodayCloseFeeRate_S,feealgr
   		into v_feeRate_b,v_feeRate_s,v_feeAlgr
        from T_A_FirmFee
        where FirmID=p_FirmID and CommodityID=p_CommodityID;
    exception
        when NO_DATA_FOUND then
            null;
    end;
    if(v_feeAlgr=1) then  --应收手续费=数量*合约因子*价格*手续费
    	if(p_bs_flag = 1) then  --买
        	v_fee:=p_quantity*v_contractFactor*p_price*v_feeRate_b;
        elsif(p_bs_flag = 2) then  --卖
        	v_fee:=p_quantity*v_contractFactor*p_price*v_feeRate_s;
        end if;
    elsif(v_feeAlgr=2) then  --应收手续费=数量*手续费
    	if(p_bs_flag = 1) then  --买
        	v_fee:=p_quantity*v_feeRate_b;
        elsif(p_bs_flag = 2) then  --卖
        	v_fee:=p_quantity*v_feeRate_s;
        end if;
    end if;
    if(v_fee is null) then
    	rollback;
        return -1;
    end if;
    return v_fee;
exception
    when no_data_found then
    	rollback;
        return -1;
    when others then
    	rollback;
   		return -100;
end;
/

prompt
prompt Creating function FN_T_CONFERCLOSEONE
prompt =====================================
prompt
create or replace function FN_T_ConferCloseOne(
    p_CommodityID    varchar2,   --商品代码
    p_Price          number,     --平仓价
    p_BS_Flag        number,     --买卖标志
    p_CustomerID     varchar2,   --交易客户ID
    p_OppCustomerID  varchar2,   --对方交易客户ID
    p_HoldQty        number,     --平仓持仓数量，即非抵顶数量
    p_GageQty        number default 0,   --平仓抵顶数量，业务上不支持，如果要协议平仓抵顶的要先做抵顶转提前交收
    p_M_TradeNo      number,     --撮合成交号
    p_M_TradeNo_Opp  number      --对方撮合成交号
) return number
/****
 * 买卖单方向协议平仓
 * 1、注意不要提交commit，因为别的函数要调用它；
 * 返回值
 * 1 成功
 * -1  可平仓持仓数量不足
 * -2  可平仓抵顶数量不足
 * -3  平仓持仓数量大于可平仓持仓数量
 * -4  平仓抵顶数量大于可抵顶数量
 * -100 其它错误
****/
as
    v_version        varchar2(10):='1.0.2.1';
    v_CommodityID    varchar2(16);
    v_CustomerID     varchar2(40);
    v_FirmID         varchar2(32);
    v_OppFirmid      varchar2(32);     --对手交易商代码
    v_HoldQty        number;
    v_HoldSumQty     number(10);
    v_frozenQty      number(10);
    v_Margin         number(15,2):=0;
    v_Margin_one     number(15,2):=0;
    v_closeFL        number(15,2):=0;
    v_closeFL_one    number(15,2):=0;    --一条记录的交收盈亏
    v_Fee            number(15,2):=0;   --应收费用
    v_Fee_one        number(15,2):=0;    --一条记录的交收手续费
    v_Assure         number(15,2):=0;
    v_Assure_one     number(15,2):=0;
    v_BS_Flag        number(2);
    v_Price          number(15,2);
    v_ContractFactor  number(12,2);
    v_MarginPriceType number(1);
    v_MarginPrice     number(15,2);  --计算成交保证金的价格
    v_HoldFunds       number(15,2):=0;  --平仓时应退持仓金额，不包括抵顶的
    v_CustomerHoldFunds    number(15,2):=0;  --平仓时应退持仓金额，包括抵顶的
    v_TradeDate            date;
    v_A_HoldNo       number(15);
    v_A_TradeNo      number(15);
    v_a_tradeno_closed     number(15);
    v_AddedTaxFactor T_Commodity.AddedTaxFactor%type;--增值税率系数=AddedTax/(1+AddedTax)
    v_GageQty        number(10);
          v_GageFrozenQty number(10);--add by zhaodc 20140804 抵顶冻结数量
    v_CloseAddedTax_one    number(15,2); --交收盈亏增值税
    v_unCloseQty     number(10):=p_HoldQty; --未平数量，用于中间计算
    v_unCloseQtyGage       number(10):=p_GageQty; --未平数量，用于中间计算
    v_tradedAmount   number(10):=0;  --成交数量
    v_tradedAmountGage     number(10):=0;  --成交数量
    v_CloseAlgr      number(2);
    v_Balance        number(15,2);
    v_F_FrozenFunds  number(15,2);
    v_AtClearDate    date;
    v_HoldTime       date;
    v_tmp_bs_flag    number(2);
    type c_HoldPosition is ref cursor;
      v_HoldPosition c_HoldPosition;
    v_sql varchar2(500);
    v_orderby  varchar2(100);
    v_closeTodayHis         number(2);    --平今仓还是历史仓(0平今仓；1平历史仓)
    v_YesterBalancePrice    number(15,2);
    v_GageMode       number(2);--抵顶模式，分0全抵顶和1半抵顶，半抵顶时要计算浮亏，2009-10-14
    v_num            number(10);
    v_TaxInclusive     number(1);   --商品是否含税 0含税  1不含税   xiefei 20150730
begin
      v_CustomerID := p_CustomerID;
      v_CommodityID := p_CommodityID;
      v_BS_Flag := p_BS_Flag;

      --获取对手交易商ID
      select firmid into v_OppFirmid from t_customer where customerid = p_OppCustomerID;

      if(v_BS_Flag=1) then  --持仓的买卖标志
          v_tmp_bs_flag:=2; --相当于委托平仓的买卖标志
      else
          v_tmp_bs_flag:=1;
      end if;
      --锁住交易客户持仓合计，以防止并发更新
      begin
        select HoldQty,FrozenQty,GageQty,GageFrozenQty
        into v_HoldSumQty, v_frozenQty,v_GageQty,v_GageFrozenQty
        from T_CustomerHoldSum
        where CustomerID = v_CustomerID
          and CommodityID = v_CommodityID
          and bs_flag = v_BS_Flag for update;
      exception
          when NO_DATA_FOUND then
          return -15;--没有找到对应的持仓记录
      end;

      /*--可平仓持仓数量不足
      if(p_HoldQty > v_HoldSumQty-v_frozenQty) then
          rollback;
          return -1;
      end if;

      --可平仓抵顶数量不足
      if(p_GageQty > v_GageQty) then
          rollback;
          return -2;
      end if;*/

      --可平仓持仓数量不足
      if(p_HoldQty > v_frozenQty) then
          rollback;
          return -1;
      end if;

      --可平仓抵顶数量不足
      if(p_GageQty > v_GageFrozenQty) then
          rollback;
          return -2;
      end if;

      --获取平仓算法,抵顶模式
      select CloseAlgr,GageMode into v_CloseAlgr,v_GageMode from T_A_Market;

/*
   select Contractfactor,MarginPriceType,AddedTaxFactor,LastPrice
        into v_ContractFactor,v_MarginPriceType,v_AddedTaxFactor,v_YesterBalancePrice   xief 20150730*/

        ----增加是否含税
   select Contractfactor,MarginPriceType,AddedTaxFactor,LastPrice,TaxInclusive
        into v_ContractFactor,v_MarginPriceType,v_AddedTaxFactor,v_YesterBalancePrice,v_TaxInclusive

        from T_Commodity where CommodityID=v_CommodityID;
      select TradeDate into v_TradeDate from T_SystemStatus;

      --根据平仓算法(0先开先平；1后开先平；2持仓均价平仓(不排序)选择排序条件
      if(v_CloseAlgr = 0) then
          v_orderby := ' order by a.A_HoldNo ';
      elsif(v_CloseAlgr = 1) then
          v_orderby := ' order by a.A_HoldNo desc ';
      end if;

      v_sql := 'select a.a_holdno,FirmID,price,(a.HoldQty-nvl(b.FrozenQty,0)),GageQty,HoldTime,AtClearDate,a_tradeno,nvl(b.FrozenQty,0) from T_holdposition a,(select A_HoldNo,nvl(sum(FrozenQty),0) FrozenQty from T_SpecFrozenHold group by A_HoldNo) b ' ||
                 ' where (a.HoldQty+a.GageQty) > 0 and a.A_HoldNo=b.A_HoldNo(+) and CustomerID=''' || v_CustomerID ||
                 ''' and CommodityID =''' || v_CommodityID || ''' and bs_flag = ' || v_BS_Flag || v_orderby;
      --遍历持仓明细的数量并过滤掉指定平仓冻结的数量
      open v_HoldPosition for v_sql;
          loop
              fetch v_HoldPosition into v_a_holdno, v_FirmID, v_price, v_holdqty,v_GageQty,v_HoldTime,v_AtClearDate,v_a_tradeno_closed,v_frozenQty;
                exit when v_HoldPosition%NOTFOUND;
                --如果此笔持仓全部被指定平仓冻结且没有抵顶则指向下一条记录
                if(v_holdqty <> 0 or v_GageQty <> 0) then
                    v_tradedAmount:=0;
                    v_tradedAmountGage:=0;
                    v_Margin_one:=0;
                    v_Assure_one:=0;
                    --判断是平今仓还是平历史仓
                    if(trunc(v_TradeDate) = trunc(v_AtClearDate)) then
                        v_closeTodayHis := 0;
                    else
                        v_closeTodayHis := 1;
                    end if;

                    --1、计算应退款项
                    if(v_holdqty > 0) then
                        if(v_holdqty<=v_unCloseQty) then
                            v_tradedAmount:=v_holdqty;
                        else
                            v_tradedAmount:=v_unCloseQty;
                        end if;
                        --计算应退保证金，根据设置选择开仓价还是昨结算价来算
                        if(v_MarginPriceType = 1) then
                            v_MarginPrice := v_YesterBalancePrice;
                        elsif(v_MarginPriceType = 2) then
                            --判断是平今仓还是平历史仓
                            if(v_closeTodayHis = 0) then  --平今仓
                                v_MarginPrice := v_price;
                            else  --平历史仓
                                v_MarginPrice := v_YesterBalancePrice;
                            end if;
                        else  -- default type is 0
                            v_MarginPrice := v_price;
                        end if;

                        v_Margin_one := FN_T_ComputeMargin(v_FirmID,v_CommodityID,v_BS_Flag,v_tradedAmount,v_MarginPrice);
                        if(v_Margin_one < 0) then
                            Raise_application_error(-20040, 'computeMargin error');
                        end if;
                        --计算担保金
                        v_Assure_one := FN_T_ComputeAssure(v_FirmID,v_CommodityID,v_BS_Flag,v_tradedAmount,v_MarginPrice);
                        if(v_Assure_one < 0) then
                            Raise_application_error(-20041, 'computeAssure error');
                        end if;
                        --保证金应加上担保金
                        v_Margin_one := v_Margin_one + v_Assure_one;
                        v_Margin:=v_Margin + v_Margin_one;
                        v_Assure:=v_Assure + v_Assure_one;
                        --计算应退持仓金额，不包括抵顶的
                        v_HoldFunds := v_HoldFunds + v_tradedAmount*v_price*v_ContractFactor;
                    end if;

                    --2、计算持仓明细中平仓的抵顶数量
                    if(v_GageQty > 0) then
                        if(v_GageQty<=v_unCloseQtyGage) then
                            v_tradedAmountGage:=v_GageQty;
                        else
                            v_tradedAmountGage:=v_unCloseQtyGage;
                        end if;
                    end if;
                    --如果是半抵顶模式则交易商持仓金额要退抵顶的
                    if(v_GageMode=1) then
                        v_HoldFunds := v_HoldFunds + v_tradedAmountGage*v_price*v_ContractFactor;
                    end if;
                    --二级客户合计金额，包括抵顶的
                    v_CustomerHoldFunds := v_CustomerHoldFunds + (v_tradedAmount+v_tradedAmountGage)*v_price*v_ContractFactor;

                    --3、计算平仓款项
                    --计算平仓手续费
                    if(v_closeTodayHis = 0) then  --平今仓
                        v_Fee_one := FN_T_ComputeTodayCloseFee(v_FirmID,v_CommodityID,v_tmp_bs_flag,v_tradedAmount+v_tradedAmountGage,p_Price);
                    else  --平历史仓
                        v_Fee_one := FN_T_ComputeHistoryCloseFee(v_FirmID,v_CommodityID,v_tmp_bs_flag,v_tradedAmount+v_tradedAmountGage,p_Price);
                    end if;
                    if(v_Fee_one < 0) then
                        Raise_application_error(-20030, 'computeFee error');
                    end if;
                    --计算税前平仓盈亏
                    if(v_BS_Flag = 1) then
                        v_closeFL_one := (v_tradedAmount+v_tradedAmountGage)*(p_Price-v_price)*v_contractFactor; --税前盈亏
                    else
                        v_closeFL_one := (v_tradedAmount+v_tradedAmountGage)*(v_price-p_Price)*v_contractFactor; --税前盈亏
                    end if;

                   --计算平仓增值税,v_AddedTaxFactor增值税系数=AddedTax/(1+AddedTax)  xief 20158011
                   -- v_CloseAddedTax_one := round(v_closeFL_one*v_AddedTaxFactor,2);
                      v_CloseAddedTax_one := 0;


                   --计算税后的平仓盈亏 xief 20150730   xief 20150811
                 /*   if(v_TaxInclusive=1) then
                           --不含税 扣除增值税
                           v_closeFL_one := v_closeFL_one - v_CloseAddedTax_one; --税后盈亏
                    end if;
                   */
                   /* --计算税后平仓盈亏
                    v_closeFL_one := v_closeFL_one - v_CloseAddedTax_one; --税后盈亏  xief   20150730*/

                    --调用计算函数修改成交单号 2011-2-15 by feijl
                    select FN_T_ComputeTradeNo(SEQ_T_Trade.nextval) into v_A_TradeNo from dual;
                    insert into T_Trade
                      (a_tradeno, m_tradeno, a_orderno, a_tradeno_closed,tradetime, Firmid, CommodityID,         bs_flag,       ordertype, price, quantity,                             close_pl,     tradefee,TradeType,HoldPrice,HoldTime,CustomerID,CloseAddedTax,M_TradeNo_Opp,AtClearDate,TradeAtClearDate,OppFirmID)
                    values
                      (v_A_TradeNo,p_M_TradeNo, null, v_a_tradeno_closed, sysdate, v_Firmid, v_CommodityID,v_tmp_bs_flag, 2,    p_Price, v_tradedAmount+v_tradedAmountGage, v_closeFL_one,v_Fee_one,    6,     v_price,v_HoldTime,v_CustomerID,v_CloseAddedTax_one,p_M_TradeNo_Opp,v_AtClearDate,v_TradeDate,v_OppFirmid);

                    --更新持仓记录
                    update T_holdposition
                    set holdqty = holdqty - v_tradedAmount,HoldMargin=HoldMargin-v_Margin_one,HoldAssure=HoldAssure-v_Assure_one,GageQty = GageQty - v_tradedAmountGage
                    where a_holdno = v_a_holdno;

                    v_unCloseQty:=v_unCloseQty - v_tradedAmount;
                    v_unCloseQtyGage:=v_unCloseQtyGage - v_tradedAmountGage;

                    v_Fee:=v_Fee + v_Fee_one;
                     v_closeFL:=v_closeFL + v_closeFL_one;

                  exit when v_unCloseQty=0 and v_unCloseQtyGage=0;
                end if;
            end loop;
            close v_HoldPosition;
            if(v_unCloseQty>0) then --平仓持仓数量大于可平仓持仓数量
                rollback;
                return -3;
            end if;
            if(v_unCloseQtyGage>0) then --平仓抵顶数量大于可抵顶数量
                rollback;
                return -4;
            end if;

            --减少交易客户，交易商的持仓合计信息2009-10-15
            v_num := FN_T_SubHoldSum(p_HoldQty,p_GageQty,v_Margin,v_Assure,v_CommodityID,v_ContractFactor,v_BS_Flag,v_FirmID,v_HoldFunds,v_CustomerID,v_CustomerHoldFunds,v_GageMode,p_HoldQty);

            --更新临时保证金和临时担保金
            update T_Firm
               set runtimemargin = runtimemargin - v_Margin,
                   RuntimeAssure = RuntimeAssure - v_Assure
             where Firmid = v_FirmID;
            --更新冻结资金，释放个人部分的保证金
            v_F_FrozenFunds := FN_F_UpdateFrozenFunds(v_FirmID,-(v_Margin-v_Assure)+v_Fee-v_closeFL,'15');
    return 1;

end;
/

prompt
prompt Creating function FN_T_CONFERCLOSE
prompt ==================================
prompt
create or replace function FN_T_ConferClose(
    p_CommodityID varchar2,   --商品代码
 	  p_Price         number,  --平仓价
    p_bCustomerID    varchar2,     --买交易客户ID
    p_bHoldQty      number,   --买平仓持仓数量，即非抵顶数量
 	  p_bGageQty      number,   --买平仓抵顶数量
    p_sCustomerID    varchar2,     --卖交易客户ID
    p_sHoldQty      number,   --卖平仓持仓数量，即非抵顶数量
 	  p_sGageQty      number   --卖平仓抵顶数量
) return number
/****
 * 协议平仓
 * 返回值
 * 1 成功
 * -1  可平仓买持仓数量不足
 * -2  可平仓买抵顶数量不足
 * -3  平仓买持仓数量大于可平仓买持仓数量
 * -4  平仓买抵顶数量大于可买抵顶数量
 * -11  可平仓卖持仓数量不足
 * -12  可平仓卖抵顶数量不足
 * -13  平仓卖持仓数量大于可平仓卖持仓数量
 * -14  平仓卖抵顶数量大于可卖抵顶数量
 * -100 其它错误
****/
as
 	  v_version varchar2(10):='1.0.0.1';
    bRet            number(5);
    sRet            number(5);
    v_FL_ret            timestamp;
    v_sFirmID varchar2(32);      --卖方交易商ID
	  v_bFirmID varchar2(32);      --买方交易商ID
    bM_TradeNo            number(15);
    sM_TradeNo            number(15);
    v_errorcode      number;
    v_errormsg       varchar2(200);
begin
	  select nvl(max(M_TradeNo),0)+1 into bM_TradeNo from T_Trade;
	  sM_TradeNo := bM_TradeNo + 1;
    bRet := FN_T_ConferCloseOne(p_CommodityID,p_Price,1,p_bCustomerID,p_sCustomerID,p_bHoldQty,p_bGageQty,bM_TradeNo,sM_TradeNo);--买
    if(bRet = 1) then
    	  sRet := FN_T_ConferCloseOne(p_CommodityID,p_Price,2,p_sCustomerID,p_bCustomerID,p_sHoldQty,p_sGageQty,sM_TradeNo,bM_TradeNo); --卖
  		  if(sRet = 1) then
   			    commit;
   			    --提交后计算买卖双方浮亏
   			    v_FL_ret := FN_T_UpdateFloatingLoss(null,null,null);
      		  return 1;
     	  elsif(sRet = -1) then
      		  rollback;
   			    return -11;
  		  elsif(sRet = -2) then
      		  rollback;
   			    return -12;
  		  elsif(sRet = -3) then
      		  rollback;
   			    return -13;
  		  elsif(sRet = -4) then
      		  rollback;
   			    return -14;
  		  else
      		  rollback;
   			    return -100;
  		  end if;
 	  else
 	      rollback;
  		  return bRet;
 	  end if;
exception
    when OTHERS then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_ConferClose',v_errorcode,v_errormsg);
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_T_CONFERCLOSEAUDIT
prompt =======================================
prompt
create or replace function FN_T_ConferCloseAudit(
    p_ID            varchar2,       --协议交收ID
    p_CommodityID   varchar2,       --商品代码
    p_bCustomerID   varchar2,       --买方交易客户ID
    p_sCustomerID   varchar2,       --卖方交易客户ID
    p_price         number,         --价格
    p_quantity      number          --数量
) return number
/****
 * 协议交收审核
 * 返回值
 * 1 成功
 * -1  可平仓买持仓数量不足
 * -3  平仓买持仓数量大于可平仓买持仓数量
 * -11  可平仓卖持仓数量不足
 * -13  平仓卖持仓数量大于可平仓卖持仓数量
 * -21  解冻持仓失败
 * -100 其它错误
****/
as
     v_ret          number(5):=0;
begin
     --解冻持仓合计表持仓
     --1.客户持仓合计表(买方)
     --update t_customerholdsum set frozenQty=frozenQty-p_quantity where commodityid = p_CommodityID and customerid = p_bCustomerID and bs_flag = 1;
     --2.客户持仓合计表(卖方)
     --update t_customerholdsum set frozenQty=frozenQty-p_quantity where commodityid = p_CommodityID and customerid = p_sCustomerID and bs_flag = 2;
     --解冻持仓冻结表
     delete T_Holdfrozen where Operation = p_ID and frozentype = 1;
     --修改审核状态
     update T_E_ApplyTreatySettle set Status = 2,modifytime = sysdate where ApplyID = p_ID;

     v_ret := FN_T_ConferClose(p_CommodityID,p_price,p_bCustomerID,p_quantity,0,p_sCustomerID,p_quantity,0);
     return v_ret;
exception
    when OTHERS then
    rollback;
    return -21;
end;
/

prompt
prompt Creating function FN_T_CREATEAPPLY
prompt ==================================
prompt
create or replace function FN_T_CREATEAPPLY(p_clob varchar2, p_applytype number, p_status number, p_proposer varchar2) return number
as
   v_xml_id NUMBER(12);
   v_apply_id NUMBER(10);
begin
   /* 生成xml文本id*/
   select nvl(max(id),0)+1 into v_xml_id from c_xmltemplate;
   /* 用上面生成的id作插入操作*/
   insert into c_xmltemplate values(v_xml_id, to_clob(p_clob));
   /* 生成申请记录的id*/
   select nvl(max(id),0)+1 into v_apply_id from t_apply;
   /* 用上面生成的id作插入操作*/
   insert into t_apply (id,applyType,status,proposer,applytime,content) values (v_apply_id,p_applytype,p_status,p_proposer,sysdate,sys.xmlType.createXML((select clob from c_xmltemplate where id=v_xml_id)));
   /* 删除xml数据*/
   delete from c_xmltemplate where id=v_xml_id;
   return v_apply_id;
end;
/

prompt
prompt Creating function FN_T_DEDUCTDATA
prompt =================================
prompt
create or replace function FN_T_DeductData
 (
    p_deductID number  --强减ID
 )
return number     --返回 1 成功 -1:只能闭市操作状态强减； -2：没有符合条件的盈利方
/**
 * 生成强减数据
 *
 **/
as
    v_systemstatus number(2);
    v_deductDate date;  --强减日期
    v_cmdtyCode varchar2(16);  --强减的商品代码
    v_factor number;
    v_b_price number(15,2); --结算价
    v_deductPrice number;
    v_loserBSflag number(1);
    v_loserSign number(1);

    v_loserMode number;
    v_lossRate number;
    v_selfCounteract char(1);
    v_profitLvl1 number;
    v_profitLvl2 number;
    v_profitLvl3 number;
    v_profitLvl4 number;
    v_profitLvl5 number;
    v_profitQty1 number;
    v_profitQty2 number;
    v_profitQty3 number;
    v_profitQty4 number;
    v_profitQty5 number;
    v_lossqty number(10);
    v_loserPct number;
    v_winerPct number;

    v_diff number(10);

    v_customerId varchar2(40);

    --需舍入的客户
    cursor c_deductRound is
    select customerid from T_E_DeductDetail
    where deductID=p_deductID and estimateQty-deductQty>0
    order by (estimateQty-deductQty) desc ,PL_ratio desc;

    v_errorcode      number;
    v_errormsg       varchar2(200);
begin
    select status into v_systemstatus from t_systemstatus;
    if(v_systemstatus<>1) then --只能闭市操作状态强减
        return -1;
    end if;

    --清已有数据
    delete from T_E_DeductDetail where deductID=p_deductID;

    --获得强减参数
    select deductDate,commodityid,deductprice,loserBSflag,decode(loserBSflag,2,-1,1),losermode, -lossrate, selfcounteract, profitlvl1, profitlvl2, profitlvl3, profitlvl4, profitlvl5
    into v_deductDate,v_cmdtyCode,v_deductPrice,v_loserBSflag,v_loserSign,v_losermode, v_lossrate, v_selfcounteract, v_profitlvl1, v_profitlvl2, v_profitlvl3, v_profitlvl4, v_profitlvl5
    from T_E_DeductPosition where deductID=p_deductID;

    select contractfactor into v_factor from t_commodity t where t.commodityid=v_cmdtyCode;
    --得到结算价，按结算价算盈亏率
    select decode(qt.price,0,qt.yesterbalanceprice,qt.price) into v_b_price from t_quotation qt where qt.commodityid=v_cmdtyCode;

    --算出交易客户盈亏
    insert into T_E_DeductDetail(deductID,Customerid,Buyqty,Sellqty,Pureholdqty,Pl,Pl_Ratio,WL,buykeepqty,Sellkeepqty,counteractqty,Orderqty,deductableqty,Estimateqty,deductqty,Deductedqty,Counteractedqty)
    select p_deductID,customerid,buyqty,sellqty,pureholdqty,pl,decode(pureholdqty,0,0,pl/(abs(pureholdqty)*v_factor)/v_b_price) pl_ratio,
        decode(sign(pureholdqty),v_loserSign,'L','W'),0,0,0,0,0,0,0,0,0 from
       (
         select a.customerid,sum(decode(a.bs_flag,2,-1,1)*a.holdqty) pureholdqty,sum(decode(a.bs_flag,1,a.holdqty,0)) buyqty,
           sum(decode(a.bs_flag,2,a.holdqty,0)) sellqty,sum(decode(a.bs_flag,1,(a.holdqty*v_b_price*v_factor-(a.holdfunds-a.GageQty*a.EvenPrice*v_factor)),((a.holdfunds-a.GageQty*a.EvenPrice*v_factor)-a.holdqty*v_b_price*v_factor))) pl
         from T_CustomerHoldSum a
         where commodityid=v_cmdtyCode group by a.customerid
       );

    --保留数量
    update T_E_DeductDetail t set t.buykeepqty=
        nvl((
          select sum(df.keepqty) from T_E_DeductKeep df
          where deductID=p_deductID and df.bs_flag=1 and df.customerid=t.customerid
        ),0),
        t.sellkeepqty=
        nvl((
          select sum(df.keepqty) from T_E_DeductKeep df
          where deductID=p_deductID and df.bs_flag=2 and df.customerid=t.customerid
        ),0)
    where deductID=p_deductID ;
    ----------按全部亏损客户强减
    if(v_losermode=1) then
        --算出各交易客户可强减数量
        if(v_loserBSflag=1) then
          --买量-买保留量，净持仓量   取最小的最为可以强减量
          update T_E_DeductDetail t set t.deductableqty=least(buyqty-buykeepqty,PureHoldQty)
          where deductID=p_deductID and wl='L' and pl_ratio<=v_lossrate;
          --卖量-卖保留量，净持仓量   取最小的最为可以强减量
          update T_E_DeductDetail t set t.deductableqty=least(sellqty-sellkeepqty,-PureHoldQty)
          where deductID=p_deductID and wl='W' and pl_ratio>=v_profitlvl5;
        else
          --卖量-卖保留量，净持仓量   取最小的最为可以强减量
          update T_E_DeductDetail t set t.deductableqty=least(sellqty-sellkeepqty,-PureHoldQty)
          where deductID=p_deductID and wl='L' and pl_ratio<=v_lossrate;
          --买量-买保留量，净持仓量   取最小的最为可以强减量
          update T_E_DeductDetail t set t.deductableqty=least(buyqty-buykeepqty,PureHoldQty)
          where deductID=p_deductID and wl='W' and pl_ratio>=v_profitlvl5;
        end if;
    end if;
    ---------按平仓委托强减
    if(v_losermode=2) then
        --得出客户的平仓委托数量
        update T_E_DeductDetail t set t.orderqty=
          nvl((select sum(quantity-tradeqty) from T_orders o
           where trunc(o.ordertime)=v_deductDate
           and o.commodityid=v_cmdtyCode and o.customerid=t.customerid and WithdrawType=4
           and o.bs_flag=decode(v_loserBSflag,1,2,1) and o.ordertype=2 and price=v_deductPrice),0)
         /* add by yukx 20100514 */
           -nvl((
              select sum(d.orderqty) from T_E_DeductDetail d,T_E_DeductPosition p
              where d.deductid=p.deductid and p.deductid<> p_deductID and d.customerid=t.customerid and p.deductstatus='Y'
               and p.commodityid=v_cmdtyCode and p.deductprice=v_deductPrice and p.loserbsflag=v_loserBSflag
               and p.deductdate=(select TradeDate from T_SystemStatus)),0)
        where deductID=p_deductID ;

        --算出各交易客户可强减数量
        if(v_loserBSflag=1) then
            --买量-买保留量，委托量，净持仓量   取最小的最为可以强减量
            update T_E_DeductDetail t set t.deductableqty=least(buyqty-buykeepqty,orderqty,PureHoldQty)
            where deductID=p_deductID and wl='L' and pl_ratio<=v_lossrate;
            --卖量-卖保留量，净持仓量   取最小的最为可以强减量
            update T_E_DeductDetail t set t.deductableqty=least(sellqty-sellkeepqty,-PureHoldQty)
            where deductID=p_deductID and wl='W' and pl_ratio>=v_profitlvl5;
        else
            --卖量-卖保留量，委托量，净持仓量   取最小的最为可以强减量
            update T_E_DeductDetail t set t.deductableqty=least(sellqty-sellkeepqty,orderqty,-PureHoldQty)
            where deductID=p_deductID and wl='L' and pl_ratio<=v_lossrate;
            --买量-买保留量，净持仓量   取最小的最为可以强减量
            update T_E_DeductDetail t set t.deductableqty=least(buyqty-buykeepqty,PureHoldQty)
            where deductID=p_deductID and wl='W' and pl_ratio>=v_profitlvl5;
        end if;
    end if;
    --亏损方可强减总数量
    select sum(deductableqty) into v_lossqty from T_E_DeductDetail d
    where deductID=p_deductID and wl='L' and pl_ratio<=v_lossrate;
    --盈利方各级总数量
    select sum(deductableqty) into v_profitqty1 from T_E_DeductDetail
    where pl_ratio>=v_profitlvl1 and deductID=p_deductID and wl='W';
    select sum(deductableqty) into v_profitqty2 from T_E_DeductDetail
    where pl_ratio>=v_profitlvl2 and pl_ratio<v_profitlvl1 and deductID=p_deductID and wl='W';
    select sum(deductableqty) into v_profitqty3 from T_E_DeductDetail
    where pl_ratio>=v_profitlvl3 and pl_ratio<v_profitlvl2 and deductID=p_deductID and wl='W';
    select sum(deductableqty) into v_profitqty4 from T_E_DeductDetail
    where pl_ratio>=v_profitlvl4 and pl_ratio<v_profitlvl3 and deductID=p_deductID and wl='W';
    select sum(deductableqty) into v_profitqty5 from T_E_DeductDetail
    where pl_ratio>=v_profitlvl5 and pl_ratio<v_profitlvl4 and deductID=p_deductID and wl='W';
    v_profitqty1:=nvl(v_profitqty1,0);
    v_profitqty2:=nvl(v_profitqty2,0);
    v_profitqty3:=nvl(v_profitqty3,0);
    v_profitqty4:=nvl(v_profitqty4,0);
    v_profitqty5:=nvl(v_profitqty5,0);
    if(v_profitqty1+v_profitqty2+v_profitqty3+v_profitqty4+v_profitqty5 = 0)then
        return -2; --没有符合条件的盈利方
    end if;

    --算出估计强减数量
    if(v_lossqty>v_profitqty1+v_profitqty2+v_profitqty3+v_profitqty4+v_profitqty5) then
        v_loserPct := (v_profitqty1+v_profitqty2+v_profitqty3+v_profitqty4+v_profitqty5)/v_lossqty;
        v_winerPct := 1;
        update T_E_DeductDetail set EstimateQty=deductableqty
        where pl_ratio>=v_profitlvl5 and deductID=p_deductID and wl='W';
    elsif(v_lossqty>v_profitqty1+v_profitqty2+v_profitqty3+v_profitqty4) then
        v_loserPct := 1;
        v_winerPct := (v_lossqty-(v_profitqty1+v_profitqty2+v_profitqty3+v_profitqty4))/v_profitqty5;
        update T_E_DeductDetail set EstimateQty=deductableqty
        where pl_ratio>=v_profitlvl4 and deductID=p_deductID and wl='W';
        update T_E_DeductDetail set EstimateQty=deductableqty*v_winerPct
        where pl_ratio>=v_profitlvl5 and pl_ratio<v_profitlvl4 and deductID=p_deductID and wl='W';
    elsif(v_lossqty>v_profitqty1+v_profitqty2+v_profitqty3) then
        v_loserPct := 1;
        v_winerPct := (v_lossqty-(v_profitqty1+v_profitqty2+v_profitqty3))/v_profitqty4;
        update T_E_DeductDetail set EstimateQty=deductableqty
        where pl_ratio>=v_profitlvl3 and deductID=p_deductID and wl='W';
        update T_E_DeductDetail set EstimateQty=deductableqty*v_winerPct
        where pl_ratio>=v_profitlvl4 and pl_ratio<v_profitlvl3 and deductID=p_deductID and wl='W';
    elsif(v_lossqty>v_profitqty1+v_profitqty2) then
        v_loserPct := 1;
        v_winerPct := (v_lossqty-(v_profitqty1+v_profitqty2))/v_profitqty3;
        update T_E_DeductDetail set EstimateQty=deductableqty
        where pl_ratio>=v_profitlvl2 and deductID=p_deductID and wl='W';
        update T_E_DeductDetail set EstimateQty=deductableqty*v_winerPct
        where pl_ratio>=v_profitlvl3 and pl_ratio<v_profitlvl2 and deductID=p_deductID and wl='W';
    elsif(v_lossqty>v_profitqty1) then
        v_loserPct := 1;
        v_winerPct := (v_lossqty-v_profitqty1)/v_profitqty2;
        update T_E_DeductDetail set EstimateQty=deductableqty
        where pl_ratio>=v_profitlvl1 and deductID=p_deductID and wl='W';
        update T_E_DeductDetail set EstimateQty=deductableqty*v_winerPct
        where pl_ratio>=v_profitlvl2 and pl_ratio<v_profitlvl1 and deductID=p_deductID and wl='W';
    else --(v_lossqty<=v_profitqty1)
        v_loserPct := 1;
        v_winerPct := v_lossqty/v_profitqty1;
        update T_E_DeductDetail set EstimateQty=deductableqty*v_winerPct
        where pl_ratio>=v_profitlvl1 and deductID=p_deductID and wl='W';
    end if;

    update T_E_DeductDetail set EstimateQty=deductableqty*v_loserPct where deductID=p_deductID and wl='L';

    --先将整数部分计入强减数量
    update T_E_DeductDetail set deductqty=trunc(EstimateQty) where deductID=p_deductID;
    --得出差额，根据亏损方和盈利方净持仓相反的符号，来计算亏损方与盈利方的差额，也即是小数部分没有分配的强减量
    select abs(sum(sign(pureHoldQty)*deductqty)) into v_diff from T_E_DeductDetail where deductID=p_deductID;
    --对非整数的客户进入取整
    if(v_diff > 0) then
        open c_deductRound;
        loop
          fetch c_deductRound into v_customerid;
          exit when v_diff=0;
          update T_E_DeductDetail set deductqty=deductqty+1 where deductID=p_deductID and customerid=v_customerid;
          v_diff:=v_diff - 1;
        end loop;
        close c_deductRound;
    end if;

    --算出对冲数量
    if(v_losermode=1) then
        if(v_selfcounteract=0) then   --不对冲
            update T_E_DeductDetail set CounteractQty=0
            where deductID=p_deductID;
        else --全部双向持仓对冲
            if(v_loserBSflag=1) then
                update T_E_DeductDetail set CounteractQty=least(buyqty-buykeepqty-deductqty,sellqty-sellkeepqty)
                where deductID=p_deductID and wl='L';
                update T_E_DeductDetail set CounteractQty=least(buyqty-buykeepqty,sellqty-sellkeepqty-deductqty)
                where deductID=p_deductID and wl='W';
            else
                update T_E_DeductDetail set CounteractQty=least(buyqty-buykeepqty,sellqty-sellkeepqty-deductqty)
                where deductID=p_deductID and wl='L';
                update T_E_DeductDetail set CounteractQty=least(buyqty-buykeepqty-deductqty,sellqty-sellkeepqty)
                where deductID=p_deductID and wl='W';
            end if;
        end if;
    elsif(v_losermode=2) then
        if(v_selfcounteract=0) then    --不对冲
            update T_E_DeductDetail set CounteractQty=0
            where deductID=p_deductID;
        elsif(v_selfcounteract=1) then --全部双向持仓对冲
            if(v_loserBSflag=1) then
                update T_E_DeductDetail set CounteractQty=least(buyqty-buykeepqty-deductqty,sellqty-sellkeepqty)
                where deductID=p_deductID and wl='L';
                update T_E_DeductDetail set CounteractQty=least(buyqty-buykeepqty,sellqty-sellkeepqty-deductqty)
                where deductID=p_deductID and wl='W';
            else
                update T_E_DeductDetail set CounteractQty=least(buyqty-buykeepqty,sellqty-sellkeepqty-deductqty)
                where deductID=p_deductID and wl='L';
                update T_E_DeductDetail set CounteractQty=least(buyqty-buykeepqty-deductqty,sellqty-sellkeepqty)
                where deductID=p_deductID and wl='W';
            end if;
        else --亏损且有平仓委托的，委托数量-净持仓数量后对冲
            if(v_loserBSflag=1) then
                update T_E_DeductDetail set CounteractQty=greatest(least(buyqty-deductqty-buykeepqty,sellqty-sellkeepqty,orderqty-pureholdqty),0)
                where deductID=p_deductID and wl='L';
            else
                update T_E_DeductDetail set CounteractQty=greatest(least(buyqty-buykeepqty,sellqty-sellkeepqty-deductqty,orderqty-(-pureholdqty)),0)
                where deductID=p_deductID and wl='L';
            end if;
        end if;
    end if;

    update T_E_deductposition set deductstatus='P' where deductID=p_deductID;

    commit;
    return 1;
end;
/

prompt
prompt Creating function FN_T_DEDUCTGO
prompt ===============================
prompt
create or replace function FN_T_DeductGo
 (
   p_deductID number  --强减ID
 )
return number  --返回 1 成功  -1:只能闭市操作状态强减；-2：强减日期不是当天
/***
 * 根据强减数据（强减明细表）执行强制减仓
 *
 ***/
as
  v_systemstatus number(2);
  v_deductDate date;
  v_cmdtyCode varchar2(16);  --强减的商品代码
  v_deductPrice number;
  v_loserBSflag number(1);
  v_selfCounteract char(1);
  v_customerid varchar2(40);

  v_customerid_l varchar2(40);
  v_deductqty number(10);
  v_CounteractQty number(10);

  v_customerid_w varchar2(40);

  v_num number(10);
  v_dnum number(10);

  v_ret number;
  v_TradeDate date;

  cursor c_counteract is --对冲
    select customerid,CounteractQty-CounteractedQty from T_E_DeductDetail
    where deductID=p_deductID and CounteractQty-CounteractedQty>0;

  cursor c_deduct is
    select customerid,deductqty-deductedqty from T_E_DeductDetail
    where deductID=p_deductID and wl='L' and deductqty-deductedqty>0
    order by deductqty desc;


begin
  select status,TradeDate into v_systemstatus,v_TradeDate from t_systemstatus;
  if(v_systemstatus<>1) then --只能闭市操作状态强减
    return -1;
  end if;

  --获得强减参数
  select deductdate,commodityid,deductprice,loserBSflag,selfcounteract
  into v_deductDate,v_cmdtyCode,v_deductPrice,v_loserBSflag,v_selfcounteract
  from T_E_DeductPosition where deductID=p_deductID;
  --判断日期是否当天
  if(v_deductDate!=trunc(v_TradeDate))then
    return -2;
  end if;
  --进行对冲
  if(v_selfcounteract>0) then
    open c_counteract;
    loop
      fetch c_counteract into v_customerid,v_counteractQty;
      exit when c_counteract%NOTFOUND;
      v_ret:=FN_T_ConferClose(v_cmdtyCode,v_deductPrice,v_customerid,v_CounteractQty,0,v_customerid,v_CounteractQty,0);
      if(v_ret = 1) then
        update T_E_DeductDetail set CounteractedQty=v_CounteractQty
        where deductID=p_deductID
          and customerid=v_customerid;
      else
        begin
          update T_E_DeductPosition set alert=alert||'Counteract customer:'||v_customerid_l||' err:'||v_ret where deductID=p_deductID;
        exception
          when OTHERS then
            null;
        end;
      end if;
    end loop;
  end if;
  --调用协议平仓进行强减
  open c_deduct;
  loop
    fetch c_deduct into v_customerid_l,v_deductqty;
    exit when c_deduct%NOTFOUND;

    loop
      exit when v_deductqty<=0;
      select customerid,deductqty-deductedqty into v_customerid_w,v_num from T_E_DeductDetail
      where deductID=p_deductID and wl='W'
        and (deductqty-deductedqty)>0 and rownum<2;
      if(v_deductqty>v_num) then
        v_dnum := v_num;
      else
        v_dnum := v_deductqty;
      end if;
      if(v_loserBSflag=1) then
        v_ret:=FN_T_ConferClose(v_cmdtyCode,v_deductPrice,v_customerid_l,v_dnum,0,v_customerid_w,v_dnum,0);
      else
        v_ret:=FN_T_ConferClose(v_cmdtyCode,v_deductPrice,v_customerid_w,v_dnum,0,v_customerid_l,v_dnum,0);
      end if;
      if(v_ret=1) then
        v_deductqty:=v_deductqty-v_dnum;
        update T_E_DeductDetail set deductedqty=deductedqty+v_dnum
        where deductID=p_deductID
          and customerid in (v_customerid_l,v_customerid_w);
      end if;
    end loop;

  end loop;
  update T_E_DeductPosition set deductstatus='Y',exectime=sysdate where deductID=p_deductID;
  return 1;
end;
/

prompt
prompt Creating function FN_T_D_BUYNEUTRALORDER
prompt ========================================
prompt
create or replace function FN_T_D_BuyNeutralOrder(
  p_FirmID     varchar2,   --交易商ID
  p_TraderID       varchar2,  --交易员ID
  p_CommodityID varchar2 ,--商品ID
  p_Quantity       number ,--数量
  p_Price       number ,--委托价格，行情结算价
  p_CustomerID     varchar2,  --交易客户ID
  p_ConsignerID    varchar2,  --代为委托员ID
  p_DelayQuoShowType number --延期行情显示类型，0：交收申报结束和中立仓申报结束显示； 1：实时显示；
) return number
/****
 * 中立仓申报委托
 * 返回值
 * >0  成功提交，并返回委托单号
 * -2  交易商可用资金不足
****/
as
  v_version varchar2(10):='1.0.0.0';
  v_Payout_B    number(15,2);   --买方交收货款
  v_SettleMargin    number(15,2);   --交收保证金
  v_HoldFunds     number(15,2);   --反向持仓冻结资金
  v_F_Funds      number(15,2):=0;   --应冻结资金
  v_F_FrozenFunds  number(15,2); --财务冻结资金
  v_A_Funds      number(15,2);   --可用资金
  v_A_OrderNo       number(15); --委托单号
  v_b_s_unsettleqty number(15);--交收申报买卖量之间的差值
  v_NeutralSide number(2); --中立仓方向
  v_ret  number(4);
  v_errorcode number;
  v_errormsg  varchar2(200);
begin
  --1. 检查并冻结资金：
  --买方冻结资金：买方货款＋买方交收保证金＋反向持仓保证金
  --计算买方货款
  v_Payout_B := FN_T_ComputePayout(p_FirmID,p_CommodityID,1,p_Quantity,p_Price);
  --计算交收保证金
  v_SettleMargin := FN_T_ComputeSettleMargin(p_FirmID,p_CommodityID,1,p_Quantity,p_Price);
  --计算反向持仓保证金
  v_HoldFunds := FN_T_ComputeMargin(p_FirmID,p_CommodityID,2,p_Quantity,p_Price);
  --应冻结资金
  v_F_Funds := v_Payout_B + v_SettleMargin + v_HoldFunds;

  --计算可用资金，并锁住财务资金
  v_A_Funds := FN_F_GetRealFunds(p_FirmID,1);
  if (v_F_Funds>v_A_Funds) then
    rollback;
    return -2; --可用资金不足
  end if;
  --2. 更新冻结资金
  v_F_FrozenFunds := FN_F_UpdateFrozenFunds(p_FirmID,v_F_Funds,'15');
  --3. 插入延期委托表，并返回委托单号
  select SEQ_T_DelayOrders.nextval into v_A_OrderNo from dual;
  insert into T_DelayOrders
    ( a_orderno,    CommodityID,   CustomerID,    traderid,   bs_flag, DelayOrderType, status, quantity, price, tradeqty, frozenfunds, unfrozenfunds, ordertime, withdrawtime, ordererip, signature,  FirmID ,ConsignerID)
  values
    (v_A_OrderNo,  p_CommodityID, p_CustomerID,  p_TraderID,        1,           2,         1,p_Quantity, p_Price,  0,     v_F_Funds,       0,         sysdate,      null,       null,     null,     p_FirmID ,p_ConsignerID);

  --4. 行情实时显示则要更新行情
  if(p_DelayQuoShowType = 1) then
    update T_DelayQuotation set BuyNeutralQty=nvl(BuyNeutralQty,0) + p_Quantity,CreateTime=sysdate where CommodityID = p_CommodityID;
  end if;

  commit;
  return v_A_OrderNo;
exception
  when NO_DATA_FOUND then
    rollback;
    return -99;  --不存在相关数据
  when others then
  v_errorcode:=sqlcode;
  v_errormsg :=sqlerrm;
  rollback;
  insert into T_DBLog(err_date,name_proc,err_code,err_msg)
  values(sysdate,'FN_T_D_BuyNeutralOrder',v_errorcode,v_errormsg);
  commit;
  return -100;
end;
/

prompt
prompt Creating function FN_T_D_BUYNEUTRALORDER_WD
prompt ===========================================
prompt
create or replace function FN_T_D_BuyNeutralOrder_WD(
  p_FirmID     varchar2,   --交易商ID
  p_CustomerID     varchar2,  --交易客户ID
  p_CommodityID varchar2 ,--商品ID
  p_Quantity       number ,--委托数量
  p_TradeQty       number ,--已成交数量
  p_Price       number ,--委托价格，行情结算价
  p_A_OrderNo_W     number,  --被撤委托单号
  p_quantity_wd       number,  --撤单数量
  p_frozenfunds     number,  --冻结资金
  p_unfrozenfunds       number  --解冻资金
) return number
/****
 * 中立仓买委托撤单，该函数不可以执行提交和回滚操作
 * 返回值
 * 1  成功
****/
as
  v_version varchar2(10):='1.0.0.0';
  v_Payout_B    number(15,2);   --买方交收货款
  v_SettleMargin    number(15,2);   --买方交收保证金
  v_to_unfrozenF   number(15,2);
  v_F_FrozenFunds   number(15,2);   --交易商冻结资金
  v_HoldFunds   number(15,2);   --交易商反向持仓保证金
begin
  --1. 释放剩余的冻结资金，根据未成交数量
  if(p_Quantity - p_TradeQty = p_quantity_wd) then
    v_to_unfrozenF := p_frozenfunds - p_unfrozenfunds;
  else
    --冻结资金：
    --买方冻结资金：买方货款＋买方交收保证金＋反向持仓保证金
    v_Payout_B := FN_T_ComputePayout(p_FirmID,p_CommodityID,1,p_quantity_wd,p_Price);
    --计算交收保证金
    v_SettleMargin := FN_T_ComputeSettleMargin(p_FirmID,p_CommodityID,1,p_quantity_wd,p_Price);
    --计算反向持仓保证金
    v_HoldFunds := FN_T_ComputeMargin(p_FirmID,p_CommodityID,2,p_quantity_wd,p_Price);
    --应冻结资金
    v_to_unfrozenF := v_Payout_B + v_SettleMargin + v_HoldFunds;
  end if;
  update T_DelayOrders set unfrozenfunds = unfrozenfunds + v_to_unfrozenF
  where A_orderNo = p_a_orderno_w;
  --2. 更新交易商财务冻结资金
  v_F_FrozenFunds := FN_F_UpdateFrozenFunds(p_FirmID,-v_to_unfrozenF,'15');

  return 1;
end;
/

prompt
prompt Creating function FN_T_D_BUYSETTLEORDER
prompt =======================================
prompt
create or replace function FN_T_D_BuySettleOrder(
    p_FirmID     varchar2,   --交易商ID
    p_TraderID       varchar2,  --交易员ID
    p_CommodityID varchar2 ,--商品ID
    p_Quantity       number ,--数量
    p_Price       number ,--委托价格，行情结算价
  p_CustomerID     varchar2,  --交易客户ID
  p_ConsignerID       varchar2,  --代为委托员ID
  p_TradeMargin_B       number,  --应退买方交易保证金
  p_DelayQuoShowType       number  --延期行情显示类型，0：交收申报结束和中立仓申报结束显示； 1：实时显示；
) return number
/****
 * 买交收申报委托
 * 根据配置修改申报数量判断，用净订货量还是单边总持仓判断 by chenxc 2011-09-20
 * 返回值
 * >0  成功提交，并返回委托单号
 * -1  持仓不足
 * -2  资金余额不足
 * -99  不存在相关数据
 * -100 其它错误
****/
as
  v_version varchar2(10):='1.0.2.2';
    v_HoldSum        number(10);   --持仓合计数量
    v_Payout_B    number(15,2);   --买方交收货款
     v_Payout_BSum number(15,2):=0;  --买方向交收货款汇总
    v_SettleMargin_B    number(15,2):=0;   --买方交收保证金
    v_SettleMargin_BSum    number(15,2):=0;   --买方交收保证金汇总
    v_TradeMargin_B    number(15,2);   --买方交易保证金
    v_TradeMargin_BSum    number(15,2):=0;   --买方交易保证金汇总
    v_F_Funds      number(15,2):=0;   --应冻结资金
    v_A_Funds      number(15,2);   --可用资金
    v_F_FrozenFunds  number(15,2); --财务冻结资金
    v_A_OrderNo       number(15); --委托单号
    v_HoldOrderNo  number(15):=0;--持仓委托单号  ---add by zhangjian 2012年3月2日
    v_errorcode number;
    v_errormsg  varchar2(200);
    v_DelayOrderIsPure        number(1);   --交收申报是否按净订货量申报
    v_HoldSum_S        number(10):=0;   --卖方持仓合计数量
    v_HoldSum_B        number(10):=0;   --买方持仓合计数量
    v_DelaySettlePriceType         number(10);   --交收申报交收类型 0：按结算价交收申报 ， 1：按订立价交收  -- add  by zhangjian
    v_sql varchar2(500);
    v_qtySum number(15):=0;  -- 已委托的交收申报冻结数量
    v_price number(15,6);-- 交收申报价格
    v_theOrderPriceSum number(15,6):=0;-- 本次交收申报订立价格汇总
    v_holdQty number(15):=0;--每笔持仓明细中的持仓数量
    v_tempQty number(15):=0;--中间变量
    v_aheadSettleQty number(15):=0;--提前交收申请数量
    v_alreadyQty number(15):=0;--本次委托已冻结数量
    type cur_T_HoldPosition is ref cursor;
    v_HoldPosition cur_T_HoldPosition;
  v_orderLogNo number(15):=0;--委托下单日志 ID。
  v_orderSumLogNo number(15):=0;--委托下单日志合计数据 ID

begin

  --1、检查持仓，并锁住持仓合计记录
  begin
      select nvl(holdQty - frozenQty, 0) into v_HoldSum
      from T_CustomerHoldSum
      where CustomerID = p_CustomerID
        and CommodityID = p_CommodityID
        and bs_flag = 1 for update;
  exception
        when NO_DATA_FOUND then
            rollback;
           return -1;  --持仓不足
    end;
    --根据配置修改申报数量判断，用净订货量还是单边总持仓判断 by chenxc 2011-09-20
    --交收申报是否按净订货量申报
  select DelayOrderIsPure into v_DelayOrderIsPure from T_A_Market;
  if(v_DelayOrderIsPure = 1) then --按净订货量申报
      begin
        select holdQty+GageQty into v_HoldSum_S
        from T_CustomerHoldSum
        where CustomerID = p_CustomerID
          and CommodityID = p_CommodityID
          and bs_flag = 2 ;
    exception
          when NO_DATA_FOUND then
              v_HoldSum_S := 0;
      end;
      if(v_HoldSum-v_HoldSum_S < p_Quantity) then
          rollback;
          return -1;  --净订货量不足
      end if;
  else
      if(v_HoldSum < p_Quantity) then
          rollback;
          return -1;  --持仓不足
      end if;
    end if;
    --2、检查并冻结资金：冻结买方交收货款+买方交收保证金-买方占用的交易保证金
      --根据交收申报价格类型 判断如何冻结资金。0：按结算价交收 ；1：按订立价交收  mod by zhangjian
    select   DelaySettlePriceType into v_DelaySettlePriceType from t_commodity where commodityid=p_CommodityID;

    if(v_DelaySettlePriceType=1) then -- 如果是按订立价交收
    select nvl(sum(Quantity-TradeQty),0) into v_qtySum from T_DelayOrders where  commodityid=p_CommodityID and customerid=p_CustomerID and   status in (1,2) and bs_flag=1;
     -- select sum(quantity) into   v_aheadSettleQty from T_E_ApplyAheadSettle where modifier is null;
      v_qtySum:=v_qtySum+v_aheadSettleQty;--已经冻结的数量

    v_sql:='select price,HoldQty,a.A_HoldNo   from T_holdposition a,(select A_HoldNo from T_SpecFrozenHold group by A_HoldNo) b
                 where (a.HoldQty+a.GageQty) > 0 and a.A_HoldNo=b.A_HoldNo(+) and CustomerID='''||p_CustomerID||'''
                   and CommodityID ='''|| p_CommodityID||''' and bs_flag =  1   '||'  order by a.A_HoldNo';
     open v_HoldPosition for v_sql;
        loop
            fetch v_HoldPosition into v_price,v_holdQty,v_HoldOrderNo;
            exit when v_HoldPosition%NOTFOUND;
           v_HoldSum_S:=v_HoldSum_S+v_holdQty;
            v_tempQty:=0; --每次清空遍历数量
            if(v_HoldSum_S>v_qtySum)then --计算交收货款以及交收保证金累积，必须是大于当前延期委托表中已经存在的。
            if(p_Quantity>=(v_HoldSum_S-v_qtySum))then
            v_tempQty:=v_HoldSum_S-v_qtySum-v_alreadyQty;--当前冻结的数量
            v_alreadyQty:=v_tempQty+v_alreadyQty;
            else  --如果不满足当前条件则退出遍历
            v_tempQty:=p_Quantity-v_alreadyQty;
            v_HoldSum_S:=0;
             end if;
            end if;
            --计算交收货款
            v_Payout_B  := FN_T_ComputePayout(p_FirmID,p_CommodityID,1,v_tempQty,v_price);
            --计算交收保证金
            v_SettleMargin_B := FN_T_ComputeSettleMargin(p_FirmID,p_CommodityID,1,v_tempQty,v_price);
            --计算交易保证金
            v_TradeMargin_B := FN_T_ComputeMargin(p_FirmID,p_CommodityID,1,v_tempQty,v_price);


            v_Payout_BSum :=v_Payout_BSum+v_Payout_B;--累积交收货款
            v_SettleMargin_BSum :=v_SettleMargin_BSum+v_SettleMargin_B;  --累积交收保证金
            v_TradeMargin_BSum := v_TradeMargin_BSum+v_TradeMargin_B;  --累加交易保证金
            v_theOrderPriceSum :=v_theOrderPriceSum+v_price*v_tempQty;--累加订立价格

            --循环每笔持仓明细都要插入委托日志  add by zhangjian 2012年3月2日
            select SEQ_T_D_OrderLog.nextval into v_orderLogNo  from dual  ;
            insert into T_D_DelayOrderLog  values (v_orderLogNo,p_firmid,1,p_CommodityID,v_HoldOrderNo,v_price,v_tempQty,v_SettleMargin_B,v_TradeMargin_B,v_Payout_B,Sysdate,null );

            if(v_HoldSum_S=0)then
                   v_price:=v_theOrderPriceSum/p_Quantity;--如果退出循环则计算平均订立价格
                   exit;
               end if;
        end loop;

   elsif(v_DelaySettlePriceType=0)then --如果是按结算价交收
   v_price:=p_Price;
  --计算交收货款
  v_Payout_B := FN_T_ComputePayout(p_FirmID,p_CommodityID,1,p_Quantity,v_price);
  --计算交收保证金
  v_SettleMargin_B := FN_T_ComputeSettleMargin(p_FirmID,p_CommodityID,1,p_Quantity,v_price);
              v_Payout_BSum :=v_Payout_B;
              v_SettleMargin_BSum :=v_SettleMargin_B;
   --交易保证金
   v_TradeMargin_BSum:=p_TradeMargin_B;
  end if;
    --应冻结资金
    v_F_Funds := v_Payout_BSum + v_SettleMargin_BSum - v_TradeMargin_BSum;
    --计算可用资金，并锁住财务资金
    v_A_Funds := FN_F_GetRealFunds(p_FirmID,1);

    --插入延期委托合计表日志   --add by zhangjian  2012年3月2日
    select SEQ_T_D_OrderSumLog.nextval  into v_orderSumLogNo from dual;
    insert into  T_D_DelayOrderSumLog values (v_orderSumLogNo,p_firmid,1,p_CommodityID,v_price,p_Quantity,v_SettleMargin_BSum,p_TradeMargin_B,v_Payout_BSum,v_A_Funds,v_F_Funds,Sysdate,null);


    if(v_A_Funds < v_F_Funds) then
        rollback;
        return -2;  --资金余额不足
    end if;
  --3、更新交易客户持仓合计的冻结数量
    update T_CustomerHoldSum set frozenQty = frozenQty + p_Quantity
    where CustomerID = p_CustomerID
    and CommodityID = p_CommodityID
    and bs_flag = 1;
    --4、更新冻结资金
  v_F_FrozenFunds := FN_F_UpdateFrozenFunds(p_FirmID,v_F_Funds,'15');
    --5、插入延期委托表，并返回委托单号
    select SEQ_T_DelayOrders.nextval into v_A_OrderNo from dual;
    insert into T_DelayOrders
      ( a_orderno,    CommodityID,   CustomerID,    traderid,   bs_flag, DelayOrderType, status, quantity, price, tradeqty, frozenfunds, unfrozenfunds, ordertime, withdrawtime, ordererip, signature,  FirmID ,ConsignerID)
    values
      (v_A_OrderNo,  p_CommodityID, p_CustomerID,  p_TraderID,     1,           1,          1,  p_Quantity, v_price,  0,     v_F_Funds,       0,         sysdate,      null,       null,     null,     p_FirmID ,p_ConsignerID);


    --行情实时显示则要更新行情
    if(p_DelayQuoShowType = 1) then
      update T_DelayQuotation set BuySettleQty=BuySettleQty + p_Quantity,CreateTime=sysdate where CommodityID = p_CommodityID;
    end if;

    commit;
    return v_A_OrderNo;
exception
    when NO_DATA_FOUND then
        rollback;
        return -99;  --不存在相关数据
    when others then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_D_BuySettleOrder',v_errorcode,v_errormsg);
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_T_D_BUYSETTLEORDER_WD
prompt ==========================================
prompt
create or replace function FN_T_D_BuySettleOrder_WD(
    p_FirmID     varchar2,   --交易商ID
    p_CustomerID     varchar2,  --交易客户ID
    p_CommodityID varchar2 ,--商品ID
    p_Quantity       number ,--委托数量
    p_TradeQty       number ,--已成交数量
    p_Price       number ,--委托价格，行情结算价
	p_A_OrderNo_W     number,  --被撤委托单号
	p_quantity_wd       number,  --撤单数量
	p_frozenfunds     number,  --冻结资金
	p_unfrozenfunds       number  --解冻资金
) return number
/****
 * 买交收申报委托撤单
 * 返回值
 * 1 成功
****/
as
	v_version varchar2(10):='1.0.2.2';
    v_Margin         number(15,2);   --应收保证金
    v_Payout_B    number(15,2);   --买方交收货款
    v_SettleMargin_B    number(15,2);   --买方交收保证金
    v_to_unfrozenF   number(15,2);
    v_F_FrozenFunds   number(15,2);   --交易商冻结资金
    v_MarginPriceType         number(1);     --计算成交保证金结算价类型 0:实时和闭市时都按开仓价；1:实时按昨结算价，闭市按当日结算价
    v_LastPrice    number(15,2);   --昨结算价
begin
	--1、释放剩余的冻结持仓
    update T_CustomerHoldSum set frozenQty = frozenQty - p_quantity_wd
    where CustomerID = p_CustomerID
      and CommodityID = p_CommodityID
      and bs_flag = 1;
	--2、释放剩余的冻结资金，根据未成交数量
    if(p_Quantity - p_TradeQty = p_quantity_wd) then
        v_to_unfrozenF := p_frozenfunds - p_unfrozenfunds;
    else
	    --冻结资金：冻结买方交收货款+买方交收保证金-买方占用的交易保证金
		--计算交收货款
		v_Payout_B := FN_T_ComputePayout(p_FirmID,p_CommodityID,1,p_quantity_wd,p_Price);
		--计算交收保证金
		v_SettleMargin_B := FN_T_ComputeSettleMargin(p_FirmID,p_CommodityID,1,p_quantity_wd,p_Price);
	    --计算交易保证金
	    select MarginPriceType,LastPrice
	    into v_MarginPriceType,v_LastPrice
	    from T_Commodity where CommodityID=p_CommodityID;
    	if(v_MarginPriceType = 1) then
	    	v_Margin := FN_T_ComputeMargin(p_FirmID,p_CommodityID,1,p_quantity_wd,v_LastPrice);
	    else
	    	v_Margin := FN_T_ComputeMargin(p_FirmID,p_CommodityID,1,p_quantity_wd,p_Price);
	    end if;
	    if(v_Margin < 0) then
	        Raise_application_error(-20040, 'computeMargin error');
	    end if;
	    v_to_unfrozenF := v_Payout_B + v_SettleMargin_B - v_Margin;
    end if;
    update T_DelayOrders set unfrozenfunds = unfrozenfunds + v_to_unfrozenF
    where A_orderNo = p_a_orderno_w;
    --更新冻结资金
	v_F_FrozenFunds := FN_F_UpdateFrozenFunds(p_FirmID,-v_to_unfrozenF,'15');

    return 1;
end;
/

prompt
prompt Creating function FN_T_D_CHECKANDFROZENBILL
prompt ===========================================
prompt
create or replace function FN_T_D_CheckAndFrozenBill(
    p_FirmID     varchar2,   --交易商ID
    p_CommodityID varchar2 ,--商品ID
    p_FrozenDelayQty       number --冻结延期数量
) return number
/****
 * 检查并冻结仓单
 * 返回值
 * 1  成功
 * -1  持仓不足
****/
as
	v_version varchar2(10):='1.0.2.2';
    v_HoldSum        number(10);   --持仓合计数量
    v_WillFrozenQty    number(10);
    v_TempFrozenQty    number(10);
begin
/*
	--1、从生效仓单表获取可用数量记录
    select nvl(sum(Quantity-SettleDelayQty-FrozenDelayQty), 0) into v_HoldSum
    from T_ValidBill
    where FirmID_S = p_FirmID
      and CommodityID = p_CommodityID
      and BillType = 5
      and Status = 1;
    if(v_HoldSum < p_FrozenDelayQty) then
        rollback;
        return -1;  --持仓不足
    end if;
    --2、冻结仓单
    v_WillFrozenQty := p_FrozenDelayQty;
    for cur_ValidBill in (select rowid,(Quantity-SettleDelayQty-FrozenDelayQty) UsefulQty
                      from T_ValidBill
					  where FirmID_S = p_FirmID
					      and CommodityID = p_CommodityID
					      and BillType = 5
					      and Status = 1 order by CreateTime
					  )
    loop
        if(cur_ValidBill.UsefulQty <= v_WillFrozenQty) then
            v_TempFrozenQty := cur_ValidBill.UsefulQty ;
        else
        	v_TempFrozenQty := v_WillFrozenQty ;
        end if;
        update T_ValidBill
        set FrozenDelayQty=FrozenDelayQty+v_TempFrozenQty
        where rowid=cur_ValidBill.rowid;
        v_WillFrozenQty := v_WillFrozenQty - v_TempFrozenQty;
        exit when v_WillFrozenQty=0;
    end loop;
*/
    return 1;

end;
/

prompt
prompt Creating function FN_T_D_CHGCUSTHOLDBYQTY
prompt =========================================
prompt
CREATE OR REPLACE FUNCTION FN_T_D_ChgCustHoldByQty
(
  p_CustomerID varchar2,   --交易客户代码
  p_CommodityID varchar2, --商品代码
  p_BS_Flag        number, --买卖标志
  p_TradeQty number     --数量
)  return number
/***
 * 更新交易客户持仓合计信息，根据数量平均分配金额
 *
 * 返回值：1成功
 ****/
is
  v_version varchar2(10):='1.0.2.2';
  v_ContractFactor    number(12,2);
begin
    --更改交易客户持仓合计表中的持仓记录
    update T_CustomerHoldSum
    set holdqty = holdqty - p_TradeQty,
        FrozenQty = FrozenQty - decode(sign(p_TradeQty),-1,0,p_TradeQty), --当p_TradeQty<0时，不需要冻结数量，mod by lizs
        holdfunds = holdfunds - (holdfunds*p_TradeQty/holdqty),
        HoldMargin = HoldMargin - (HoldMargin*p_TradeQty/holdqty),
        HoldAssure = HoldAssure - (HoldAssure*p_TradeQty/holdqty)
    where CustomerID = p_CustomerID
      and CommodityID = p_CommodityID
      and bs_flag = p_BS_Flag;
    select ContractFactor into v_ContractFactor from T_Commodity where CommodityID = p_CommodityID;
    update T_CustomerHoldSum
    set EvenPrice = decode(HoldQty+GageQty,0,0,HoldFunds/((HoldQty+GageQty)*v_ContractFactor))
    where CustomerID = p_CustomerID
      and CommodityID = p_CommodityID
      and bs_flag = p_BS_Flag;

   return 1;
end;
/

prompt
prompt Creating function FN_T_D_CHGFIRMHOLDBYQTY
prompt =========================================
prompt
CREATE OR REPLACE FUNCTION FN_T_D_ChgFirmHoldByQty
(
  p_FirmID varchar2,   --交易客户代码
  p_CommodityID varchar2, --商品代码
  p_BS_Flag        number, --买卖标志
  p_TradeQty       number,     --数量
  p_GageMode       number     --数量
)  return number
/***
 * 更新交易商持仓合计信息，根据数量平均分配金额
 *
 * 返回值：1成功
 ****/
is
  v_version varchar2(10):='1.0.2.2';
  v_ContractFactor    number(12,2);
begin
    --更改交易商持仓合计表中的持仓记录
    update T_FirmHoldSum
    set holdqty = holdqty - p_TradeQty,
        holdfunds = holdfunds - (holdfunds*p_TradeQty/holdqty),
        HoldMargin = HoldMargin - (HoldMargin*p_TradeQty/holdqty),
        HoldAssure = HoldAssure - (HoldAssure*p_TradeQty/holdqty)
    where FirmID = p_FirmID
      and CommodityID = p_CommodityID
      and bs_flag = p_BS_Flag;
    select ContractFactor into v_ContractFactor from T_Commodity where CommodityID = p_CommodityID;
    update T_FirmHoldSum
    set EvenPrice = decode(p_GageMode,1,decode(HoldQty+GageQty,0,0,HoldFunds/((HoldQty+GageQty)*v_ContractFactor)),
        decode(HoldQty,0,0,HoldFunds/((HoldQty)*v_ContractFactor)))
    where FirmID = p_FirmID
      and CommodityID = p_CommodityID
      and bs_flag = p_BS_Flag;

   return 1;
end;
/

prompt
prompt Creating function FN_T_D_CHGFIRMMARGINBYQTY
prompt ===========================================
prompt
CREATE OR REPLACE FUNCTION FN_T_D_ChgFirmMarginByQty
(
  p_FirmID varchar2,   --交易客户代码
  p_CommodityID varchar2, --商品代码
  p_BS_Flag        number, --买卖标志
  p_TradeQty       number     --数量
)  return number
/***
 * 更新临时保证金和临时担保金，根据数量平均分配金额
 *
 * 返回值：1成功
 ****/
is
  v_version varchar2(10):='1.0.2.2';
  v_HoldMargin    number(15,2);
  v_HoldAssure    number(15,2);
begin
    --更改交易商持仓合计表中的持仓记录
    select HoldMargin*p_TradeQty/holdqty,HoldAssure*p_TradeQty/holdqty into v_HoldMargin,v_HoldAssure from T_FirmHoldSum
    where FirmID = p_FirmID
      and CommodityID = p_CommodityID
      and bs_flag = p_BS_Flag;
    --更新临时保证金和临时担保金
    update T_Firm
    set runtimemargin = runtimemargin - v_HoldMargin,
	    RuntimeAssure = RuntimeAssure - v_HoldAssure
    where Firmid = p_FirmID;
    return v_HoldMargin-v_HoldAssure;
end;
/

prompt
prompt Creating function FN_T_D_SETTLEONE
prompt ==================================
prompt
create or replace function FN_T_D_SettleOne(
    p_CommodityID varchar2,   --商品代码
  p_Price         number,  --交收价
  p_BS_Flag     number,  --买卖标志
    p_CustomerID    varchar2,     --交易客户ID
    p_HoldQty      number,   --交收持仓数量，即非抵顶数量
  p_GageQty      number   --交收抵顶数量，目前不支持抵顶交收
) return number
/****
 * 买卖单方向延期交收
 * 返回值
 * 1 成功
 * -3  交收持仓数量大于可交收持仓数量
 * -4  交收抵顶数量大于可抵顶数量
****/
as
  v_version varchar2(10):='1.0.2.2';
    v_CommodityID varchar2(16);
    v_CustomerID        varchar2(40);
    v_FirmID varchar2(32);
    v_HoldQty  number;
    v_frozenQty      number(10);
    v_Margin_one         number(15,2):=0;
    v_closeFL_one         number(15,2):=0;    --一条记录的交收盈亏
    v_Fee_one         number(15,2):=0;    --一条记录的交收手续费
  v_Assure_one         number(15,2):=0;
    v_Payout_one         number(15,2):=0;
    v_BS_Flag           number(2);
    v_Price         number(15,2);
    v_ContractFactor    number(12,2);
    v_TradeDate date;
  v_A_HoldNo number(15);
  v_ID number(15);
  v_AddedTaxFactor T_Commodity.AddedTaxFactor%type;--增值税率系数=AddedTax/(1+AddedTax)
  v_GageQty     number(10);
  v_CloseAddedTax_one   number(15,2); --交收盈亏增值税
  v_CloseAddedTax         number(15,2):=0;        --交收盈亏增值税累加
  v_unCloseQty     number(10):=p_HoldQty; --未平数量，用于中间计算
  v_unCloseQtyGage     number(10):=p_GageQty; --未平数量，用于中间计算
  v_tradedAmount   number(10):=0;  --成交数量
  v_tradedAmountGage   number(10):=0;  --成交数量
  v_CloseAlgr           number(2);
  v_HoldType           number(2);
  v_HoldMargin         number(15,2);
    v_HoldAssure         number(15,2);
    v_NeutralFeeWay           number(2);
    v_SettleMargin_one     number(15,2);
  type cur_T_HoldPosition is ref cursor;
  v_HoldPosition cur_T_HoldPosition;
  v_sql varchar2(500);
  v_orderby  varchar2(100);
  v_AtClearDate          date;
  v_num            number(10);
  v_GageMode     number(2);
  v_SettleMargin     number(15,2):=0;
  v_Fee         number(15,2):=0;
  v_Payout         number(15,2):=0;
  v_Balance    number(15,2);
  v_F_FrozenFunds   number(15,2);
  v_CloseFL         number(15,2):=0;
  v_ret     number(4);
  v_RuntimeMargin       number(15,2);
  v_SettlePrice number(15,2);
  v_settlePriceType  number(2);
  v_TaxInclusive     number(1);   --商品是否含税 0含税  1不含税   xiefei 20150730
begin
    v_CustomerID := p_CustomerID;
      v_CommodityID := p_CommodityID;
        v_BS_Flag := p_BS_Flag;

        --获取平仓算法,抵顶模式，保证金计算类型，增值税，合约因子
        select CloseAlgr,NeutralFeeWay,GageMode into v_CloseAlgr,v_NeutralFeeWay,v_GageMode from T_A_Market;
      /*
        select Contractfactor,AddedTaxFactor
        into v_ContractFactor,v_AddedTaxFactor  xief 20150730*/

       ---增加一个字段 xief 20150730
        select Contractfactor,AddedTaxFactor,TaxInclusive
        into v_ContractFactor,v_AddedTaxFactor,v_TaxInclusive
        from T_Commodity where CommodityID=v_CommodityID;
      select TradeDate into v_TradeDate from T_SystemStatus;

          --根据交收申报类型来决定交收价格 add by  zhangjian 2011年12月13日11:04:51 start
          select DelaySettlePriceType  into v_settlePriceType from t_commodity where commodityid=p_CommodityID;
          --end by zhangjian

        --根据平仓算法(0先开先平；1后开先平；2持仓均价平仓(不排序)选择排序条件 --去掉排序算法，所有交收信息查询均按默认排序 mod by zhangjian 2011年12月12日13:47:21 start
         v_orderby := ' order by a.A_HoldNo ';
        --if(v_CloseAlgr = 0) then
        --  v_orderby := ' order by a.A_HoldNo ';
     -- elsif(v_CloseAlgr = 1) then
         -- v_orderby := ' order by a.A_HoldNo desc ';
     -- end if;
     --end by zhangjian 2011年12月12日13:47:36

      v_sql := 'select a.a_holdno,FirmID,price,(a.HoldQty-nvl(b.FrozenQty,0)),GageQty,nvl(b.FrozenQty,0),a.AtClearDate,a.HoldType,a.HoldMargin,a.HoldAssure from T_holdposition a,(select A_HoldNo,nvl(sum(FrozenQty),0) FrozenQty from T_SpecFrozenHold group by A_HoldNo) b ' ||
                 ' where (a.HoldQty+a.GageQty) > 0 and a.A_HoldNo=b.A_HoldNo(+) and CustomerID=''' || v_CustomerID ||
                 ''' and CommodityID =''' || v_CommodityID || ''' and bs_flag = ' || v_BS_Flag || v_orderby;

      --遍历持仓明细的数量并过滤掉指定平仓冻结的数量
        open v_HoldPosition for v_sql;
        loop
            fetch v_HoldPosition into v_a_holdno, v_FirmID, v_price, v_holdqty,v_GageQty,v_frozenQty,v_AtClearDate,v_HoldType,v_HoldMargin,v_HoldAssure;
            exit when v_HoldPosition%NOTFOUND;

            if(v_settlePriceType=0)then--如果按昨结算交收
                  v_SettlePrice:=p_Price;

            else --如果按订立价交收
                 v_SettlePrice:=v_Price;
            end if;
            --如果此笔持仓全部被指定平仓冻结且没有抵顶则指向下一条记录
            if(v_holdqty <> 0 or v_GageQty <> 0) then
              --清0
                v_tradedAmount:=0;
                v_tradedAmountGage:=0;
                v_Payout_one := 0;
                v_Margin_one := 0;
              v_Assure_one := 0;
              v_SettleMargin_one := 0;
                --1、计算应退款项
                if(v_holdqty > 0) then
                  if(v_holdqty<=v_unCloseQty) then
                      v_tradedAmount:=v_holdqty;
                      v_Margin_one := v_HoldMargin;
                      v_Assure_one := v_HoldAssure;
                  else
                      v_tradedAmount:=v_unCloseQty;
                      v_Margin_one := v_HoldMargin*v_tradedAmount/v_holdqty;
                      v_Assure_one := v_HoldAssure*v_tradedAmount/v_holdqty;
                  end if;
                end if;
                --2、计算持仓明细中交收的抵顶数量
        if(v_GageQty > 0) then
                  if(v_GageQty<=v_unCloseQtyGage) then
                      v_tradedAmountGage:=v_GageQty;
                  else
                      v_tradedAmountGage:=v_unCloseQtyGage;
                  end if;
                end if;
          --计算交收保证金
            v_SettleMargin_one := FN_T_ComputeSettleMargin(v_FirmID,v_CommodityID,v_BS_Flag,v_tradedAmount+v_tradedAmountGage,v_SettlePrice);
              if(v_SettleMargin_one < 0) then
                  Raise_application_error(-20042, 'ComputeSettleMargin error');
              end if;
              --3、计算交收款项
        --计算买方交收货款
        if(v_BS_Flag = 1) then
              v_Payout_one := FN_T_ComputePayout(v_FirmID,v_CommodityID,v_BS_Flag,v_tradedAmount+v_tradedAmountGage,v_SettlePrice);
                if(v_Payout_one < 0) then
                    Raise_application_error(-20043, 'computePayout error');
                end if;
              end if;
            --计算交收手续费
            if(v_HoldType = 2 and v_NeutralFeeWay = 0) then
              v_Fee_one := 0;
            else
          v_Fee_one := FN_T_ComputeSettleFee(v_FirmID,v_CommodityID,v_BS_Flag,v_tradedAmount+v_tradedAmountGage,v_SettlePrice);
        end if;
              if(v_Fee_one < 0) then
                Raise_application_error(-20031, 'computeFee error');
              end if;
              --计算税前交收盈亏
              if(v_BS_Flag = 1) then
                  v_closeFL_one := (v_tradedAmount+v_tradedAmountGage)*(v_SettlePrice-v_price)*v_contractFactor; --税前盈亏
              else
                  v_closeFL_one := (v_tradedAmount+v_tradedAmountGage)*(v_Price-v_SettlePrice)*v_contractFactor; --税前盈亏
              end if;
              --计算交收增值税,v_AddedTaxFactor增值税系数=AddedTax/(1+AddedTax)  xief  20150811
             -- v_CloseAddedTax_one := round(v_closeFL_one*v_AddedTaxFactor,2);
                v_CloseAddedTax_one := 0;

             --计算税后的交收盈亏 xief 20150730   xief  20150811
            /*    if(v_TaxInclusive=1) then
                     --不含税 扣除增值税
                     v_closeFL_one := v_closeFL_one - v_CloseAddedTax_one; --税后盈亏
              end if;
              */
              /*--计算税后交收盈亏
              v_closeFL_one := v_closeFL_one - v_CloseAddedTax_one; --税后盈亏  xief  20150730*/
        --累计金额
            v_Payout := v_Payout + v_Payout_one;
            v_Fee := v_Fee + v_Fee_one;
        v_CloseFL:=v_CloseFL + v_closeFL_one;  --税后盈亏合计
        v_CloseAddedTax:=v_CloseAddedTax + v_CloseAddedTax_one;  --交收增值税合计
        v_SettleMargin := v_SettleMargin + v_SettleMargin_one;
            --将当前持仓记录和交收费用插入交收持仓明细表，并更新持仓数量和抵顶数量为实际交收的数量
        select SEQ_T_SettleHoldPosition.nextval into v_ID from dual;
        --按字段名插入交收持仓明细表
          insert into t_settleholdposition
          (id, settleprocessdate, a_holdno, a_tradeno, customerid, commodityid, bs_flag, price, holdqty, openqty, holdtime, holdmargin, firmid, gageqty, holdassure, floatingloss, settlemargin, payout, settlefee, settle_pl, settleaddedtax, settleprice, settletype, holdtype, atcleardate)
            select v_ID,v_TradeDate,a_holdno, a_tradeno, customerid, commodityid, bs_flag, price, holdqty, openqty, holdtime, holdmargin, firmid, gageqty, holdassure, floatingloss,v_SettleMargin_one,v_Payout_one,v_Fee_one,v_closeFL_one,v_CloseAddedTax_one,v_SettlePrice,3, holdtype, atcleardate
            from t_holdposition
            where A_HoldNo=v_A_HoldNo;

            update T_SettleHoldPosition set HoldQty=v_tradedAmount,GageQty=v_tradedAmountGage where ID=v_ID;

                --更新持仓记录
                update T_holdposition
                set holdqty = holdqty - v_tradedAmount,HoldMargin=HoldMargin-v_Margin_one,HoldAssure=HoldAssure-v_Assure_one,GageQty = GageQty - v_tradedAmountGage
                where a_holdno = v_a_holdno;
                v_unCloseQty:=v_unCloseQty - v_tradedAmount;
                v_unCloseQtyGage:=v_unCloseQtyGage - v_tradedAmountGage;
                exit when v_unCloseQty=0 and v_unCloseQtyGage=0;
            end if;
        end loop;
        close v_HoldPosition;
        if(v_unCloseQty>0) then --交收持仓数量大于可交收持仓数量
            rollback;
            return -3;
        end if;
        if(v_unCloseQtyGage>0) then --交收抵顶数量大于可抵顶数量
            rollback;
            return -4;
        end if;
        --持仓合计数量的更新，不支持抵顶数量
    --更新交易客户持仓合计
        v_ret := FN_T_D_ChgCustHoldByQty(v_CustomerID,v_CommodityID,v_BS_Flag,p_HoldQty);
        --释放交易保证金
      v_RuntimeMargin := FN_T_D_ChgFirmMarginByQty(v_FirmID,v_CommodityID,v_BS_Flag,p_HoldQty);
      v_F_FrozenFunds := FN_F_UpdateFrozenFunds(v_FirmID,-v_RuntimeMargin,'15');
      --更新交易商持仓合计
    v_ret := FN_T_D_ChgFirmHoldByQty(v_FirmID,v_CommodityID,v_BS_Flag,p_HoldQty,v_GageMode);
        --扣除交收货款，交收手续费，付交收盈利或收交收亏损,交收保证金 ，并写流水
    v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15008',v_Payout,null,v_CommodityID,null,null);
    --注意这里不能按最低交收手续费收取，因为实时撮合，实时更新明细持仓，所以按实际手续费收取
      v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15010',v_Fee,null,v_CommodityID,null,null);

      --商品含不含税，均不扣除交收盈利或交收亏损
    /*if(v_CloseFL >= 0) then
      v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15011',v_CloseFL,null,v_CommodityID,v_CloseAddedTax,null);
    else
      v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15012',-v_CloseFL,null,v_CommodityID,-v_CloseAddedTax,null);
    end if;*/
    ---xief  20150811
   if(v_CloseFL >= 0) then
      v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15011',v_CloseFL,null,v_CommodityID,null,null);
    else
      v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15012',-v_CloseFL,null,v_CommodityID,null,null);
    end if;

    update T_Firm set RuntimeSettleMargin=RuntimeSettleMargin+v_SettleMargin where FirmID=v_FirmID;
    v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15013',v_SettleMargin,null,v_CommodityID,null,null);
    return 1;

end;
/

prompt
prompt Creating function FN_T_D_TRADEBILL
prompt ==================================
prompt
create or replace function FN_T_D_TradeBill(
    p_FirmID     varchar2,   --交易商ID
    p_CommodityID varchar2 ,--商品ID
    p_TradeQty       number --成交数量
) return number
/****
 * 成交仓单，冻结数量减少，已成交仓单数量增加，且改变仓单状态
 * 返回值
 * 1  成功
****/
as
	v_version varchar2(10):='1.0.2.2';
    v_WillFrozenQty    number(10);
    v_TempFrozenQty    number(10);
begin
/*
    --1、解冻仓单
    v_WillFrozenQty := p_TradeQty;
    for cur_ValidBill in (select rowid,FrozenDelayQty,(Quantity-SettleDelayQty) NotSettleQty
                      from T_ValidBill
					  where FirmID_S = p_FirmID
					      and CommodityID = p_CommodityID
					      and BillType = 5
					      and Status = 1 order by CreateTime
					  )
    loop
        if(cur_ValidBill.FrozenDelayQty <= v_WillFrozenQty) then
            v_TempFrozenQty := cur_ValidBill.FrozenDelayQty ;
        else
        	v_TempFrozenQty := v_WillFrozenQty ;
        end if;
        if(cur_ValidBill.NotSettleQty = v_TempFrozenQty) then
        	update T_ValidBill
	        set BillType=2
	        where rowid=cur_ValidBill.rowid;
        end if;
        update T_ValidBill
        set FrozenDelayQty=FrozenDelayQty-v_TempFrozenQty,SettleDelayQty=SettleDelayQty+v_TempFrozenQty
        where rowid=cur_ValidBill.rowid;
        v_WillFrozenQty := v_WillFrozenQty - v_TempFrozenQty;
        exit when v_WillFrozenQty=0;
    end loop;
	*/
    return 1;

end;
/

prompt
prompt Creating function FN_T_D_NEUTRALMATCHONE
prompt ========================================
prompt
create or replace function FN_T_D_NeutralMatchOne
(
  p_CommodityID varchar2 --商品代码
)  return number
/****
 * 某商品交收申报配对
 * 返回值
 * 1 成功
 * -3  交收持仓数量大于可交收持仓数量
 * -4  交收抵顶数量大于可抵顶数量
****/
as
    v_version varchar2(10):='1.0.2.2';
    b_qty     number(10);
    s_qty      number(10);
    Neutral_bs_flag     number(2); --中立仓方向
    Settle_bs_flag      number(2); --交收申报剩余方向
    Neutral_qty     number(10);
    Settle_qty      number(10):=0;
    v_ret     number(4);
    v_tradeQtySum      number(10):=0;
    v_settleQty     number(10);
    v_exitFlag      boolean:=false;
    v_GageMode     number(2);
    v_TradeDate     date;
    v_Balance    number(15,2):=0;
    v_F_FrozenFunds   number(15,2);
    v_num            number(10);
    v_DelayNeedBill number(2);    --延期交收是否需要仓单，0：不需要； 1：需要；
    v_NeutralFeeWay number(2);    --是否收中立仓交收手续费，0：不收；1：收取
    v_ContractFactor    number(12,2);
    v_UnfrozenFunds   number(15,2);
    v_Status          number(2);
    v_A_TradeNo      number(15);
    v_Price    number(15,2);   --交收价
    v_Margin   number(15,2);   --反向持仓交易保证金
    v_Assure   number(15,2):=0;   --应收担保金
    v_A_HoldNo       number(15);
    v_SettleMargin_one     number(15,2);
    v_Payout_one         number(15,2):=0;
    v_Fee_one         number(15,2):=0; --交收手续费
    v_ID number(15);
    v_NeutralMatchPriority   number(2); --中立仓反向持仓是否优先撮合,0:不优先；1：优先
    v_errorcode number;
    v_errormsg  varchar2(200);
begin
    --1、确定中立仓方向和申报数量
    select nvl(sum(Quantity-TradeQty),0) into b_qty from T_DelayOrders where DelayOrderType=2 and Status in(1,2) and BS_Flag=1 and CommodityID=p_CommodityID;
    select nvl(sum(Quantity-TradeQty),0) into s_qty from T_DelayOrders where DelayOrderType=2 and Status in(1,2) and BS_Flag=2 and CommodityID=p_CommodityID;
    if(b_qty >= s_qty) then
        Neutral_bs_flag := 1;
        Settle_bs_flag := 2;
        Neutral_qty := b_qty;
    else
        Neutral_bs_flag := 2;
        Settle_bs_flag := 1;
        Neutral_qty := s_qty;
    end if;
    --1.1、确定交收申报剩余未成交数量
    select nvl(sum(Quantity-TradeQty),0) into Settle_qty from T_DelayOrders where DelayOrderType=1 and Status in(1,2) and BS_Flag=Settle_bs_flag and CommodityID=p_CommodityID;
    --1.2、如果没有需要配对的数据，则直接返回成功
    if(Neutral_qty = 0 or Settle_qty = 0) then
        return 1;
    end if;

    --2、按时间顺序轮询中立仓委托撮合，生成反向持仓数据、交收明细
    --取交易日、抵顶模式、延期交收是否需要仓单、中立仓手续费方式、合约因子
    select TradeDate into v_TradeDate from T_SystemStatus;
    select GageMode,DelayNeedBill,NeutralFeeWay into v_GageMode,v_DelayNeedBill,v_NeutralFeeWay from T_A_Market;
    select Contractfactor into v_ContractFactor from T_Commodity where CommodityID=p_CommodityID;
    select NEUTRALMATCHPriority into v_NeutralMatchPriority from t_a_market;
    for NeutralOrder in(select A_OrderNo,CommodityID,CustomerID,BS_Flag,(Quantity-TradeQty) NotTradeQty,Price,FirmID from T_DelayOrders where DelayOrderType=2 and Status in(1,2) and BS_Flag=Neutral_bs_flag and CommodityID=p_CommodityID order by A_OrderNo for update)
    loop
        v_exitFlag := false;
        v_tradeQtySum := 0;
        --2.1、按时间顺序轮询撮合未成交的交收申报（中立仓反向持仓优先撮合时有反向持仓的会员委托优先排序，不优先时只按委托号排序）
        --for SettleOrder in(select A_OrderNo,CommodityID,CustomerID,BS_Flag,(Quantity-TradeQty) NotTradeQty,Price,FrozenFunds,UnfrozenFunds,Quantity,FirmID from T_DelayOrders where DelayOrderType=1 and Status in(1,2) and BS_Flag=Settle_bs_flag and CommodityID=p_CommodityID order by A_OrderNo for update)
        for SettleOrder in(select A_OrderNo,CommodityID,CustomerID,BS_Flag,(Quantity-TradeQty) NotTradeQty,Price,FrozenFunds,UnfrozenFunds,Quantity,FirmID from T_DelayOrders,(select distinct(t.FirmID) as FID,1 as OrderType from T_HoldPosition t where t.BS_Flag=Settle_bs_flag and t.HoldType=decode(v_NeutralMatchPriority,1,2,0) and t.CommodityID=p_CommodityID) hp where DelayOrderType=1 and Status in(1,2) and BS_Flag=Settle_bs_flag and CommodityID=p_CommodityID and firmid=hp.FID(+) order by nvl(hp.OrderType,0) desc,A_OrderNo for update of A_OrderNo)
        loop
            if(v_tradeQtySum + SettleOrder.NotTradeQty <= NeutralOrder.NotTradeQty) then --全部成交
                v_settleQty := SettleOrder.NotTradeQty;
                v_UnfrozenFunds := SettleOrder.FrozenFunds-SettleOrder.UnfrozenFunds;
                v_Status := 3;
                if(v_tradeQtySum + SettleOrder.NotTradeQty = NeutralOrder.NotTradeQty) then
                    v_exitFlag := true;
                end if;
            else --部分成交
                v_settleQty := NeutralOrder.NotTradeQty - v_tradeQtySum;
                v_UnfrozenFunds:=SettleOrder.FrozenFunds*v_settleQty/SettleOrder.Quantity;
                v_Status := 2;
                v_exitFlag := true;
            end if;
            v_tradeQtySum := v_tradeQtySum + v_settleQty;
            --交收申报持仓交收，涉及持仓明细，持仓合计，资金
            v_ret := FN_T_D_SettleOne(p_CommodityID,SettleOrder.Price,Settle_bs_flag,SettleOrder.CustomerID,v_settleQty,0);
            if(v_ret < 0) then
                rollback;
                return v_ret;
            end if;
            --更新交收申报委托状态、冻结资金、仓单
            update T_DelayOrders set Status=v_Status,TradeQty=TradeQty+v_settleQty,UnfrozenFunds=UnfrozenFunds+v_UnfrozenFunds where A_OrderNo=SettleOrder.A_OrderNo;
            v_F_FrozenFunds := FN_F_UpdateFrozenFunds(SettleOrder.FirmID,-v_UnfrozenFunds,'15');
            if(v_DelayNeedBill = 1) then
                v_ret := FN_T_D_TradeBill(SettleOrder.FirmID,SettleOrder.CommodityID,v_settleQty);
            end if;
            exit when v_exitFlag=true;
        end loop;

        if(v_tradeQtySum > 0) then
            --2.2、生成中立仓反向持仓相关数据(方向=Settle_bs_flag,无交易手续费)
            --2.2.1、插入延期成交表反向持仓成交记录
            select SEQ_T_DelayTrade.nextval into v_A_TradeNo from dual;
            insert into T_DelayTrade
              (a_tradeno,       a_orderno,         tradetime,     CustomerID,        CommodityID,            bs_flag,   DelayOrderType,  quantity,   TradeType,    Firmid)
            values
              (v_A_TradeNo,NeutralOrder.A_OrderNo, sysdate,NeutralOrder.CustomerID,  p_CommodityID,     Settle_bs_flag,    2,    v_tradeQtySum, 1,  NeutralOrder.FirmID);
            --2.2.2、插入中立仓反向持仓明细表
            --持仓价格
            v_Price := NeutralOrder.Price;
            --计算保证金
            v_Margin := FN_T_ComputeMargin(NeutralOrder.FirmID,p_CommodityID,Settle_bs_flag,v_tradeQtySum,v_Price);
            if(v_Margin < 0) then
                Raise_application_error(-20040, 'computeMargin error');
            end if;
            --计算担保金
            v_Assure := FN_T_ComputeAssure(NeutralOrder.FirmID,p_CommodityID,Settle_bs_flag,v_tradeQtySum,v_Price);
            if(v_Assure < 0) then
                Raise_application_error(-20041, 'computeAssure error');
            end if;
            --保证金应加上担保金
            v_Margin := v_Margin + v_Assure;
            --插入持仓明细表
			--调用计算函数修改持仓单号 2011-2-15 by feijl
            select FN_T_ComputeHoldNo(SEQ_T_HoldPosition.nextval) into v_A_HoldNo from dual;
            insert into T_Holdposition
              (a_holdno,    a_tradeno,  CommodityID,    CustomerID , bs_flag,   price,    holdqty,    openqty, holdtime,HoldMargin,HoldAssure,Firmid,FloatingLoss,HoldType,AtClearDate)
            select v_A_HoldNo,a_tradeno,CommodityID,CustomerID,bs_flag,v_Price,v_tradeQtySum,v_tradeQtySum,sysdate,v_Margin,v_Assure,Firmid,0,2,v_TradeDate
            from T_DelayTrade where a_tradeno=v_A_TradeNo;
            --2.2.3、更新持仓合计表
            --更新交易客户持仓合计表
            select count(*) into v_num from T_CustomerHoldSum
            where CustomerID = NeutralOrder.CustomerID
              and CommodityID = p_CommodityID
              and bs_flag = Settle_bs_flag;
            if(v_num >0) then
                --2011/5/23取消调用FN_T_D_ChgCustHoldByQty()，因新增持仓时无法正确更新保证金、持仓金额、均价等，且可能会出现除数=0
                --v_ret := FN_T_D_ChgCustHoldByQty(NeutralOrder.CustomerID,p_CommodityID,Settle_bs_flag,-v_tradeQtySum);
                update T_CustomerHoldSum
                set holdQty = holdQty + v_tradeQtySum,
                holdFunds = holdFunds + v_Price*v_tradeQtySum*v_contractFactor,
                HoldMargin = HoldMargin + v_Margin,
                HoldAssure = HoldAssure + v_Assure,
                evenprice = (holdFunds + v_Price*v_tradeQtySum*v_contractFactor)/((holdQty + GageQty + v_tradeQtySum)*v_contractFactor)
                where CustomerID = NeutralOrder.CustomerID
                and CommodityID = p_CommodityID
                and bs_flag = Settle_bs_flag;
            else
              insert into T_CustomerHoldSum
                (CustomerID, CommodityID, bs_flag, holdQty, holdFunds,FloatingLoss, evenprice,FrozenQty,HoldMargin,HoldAssure,FirmID)
              values
                (NeutralOrder.CustomerID, p_CommodityID, Settle_bs_flag, v_tradeQtySum, v_Price*v_tradeQtySum*v_contractFactor,0, v_Price,0,v_Margin,v_Assure,NeutralOrder.FirmID);
            end if;
            --更新交易商持仓合计表
            select count(*) into v_num from T_FirmHoldSum
            where Firmid = NeutralOrder.FirmID
              and CommodityID = p_CommodityID
              and bs_flag = Settle_bs_flag;
            if(v_num >0) then
                --2011/5/23取消调用FN_T_D_ChgFirmHoldByQty()，因新增持仓时无法正确更新保证金、持仓金额、均价等，且可能会出现除数=0
                --v_ret := FN_T_D_ChgFirmHoldByQty(NeutralOrder.FirmID,p_CommodityID,Settle_bs_flag,-v_tradeQtySum,v_GageMode);
                update T_FirmHoldSum
                set holdQty = holdQty + v_tradeQtySum,
                holdFunds = holdFunds + v_Price*v_tradeQtySum*v_contractFactor,
                HoldMargin = HoldMargin + v_Margin,
                HoldAssure = HoldAssure + v_Assure,
                evenprice = (holdFunds + v_Price*v_tradeQtySum*v_contractFactor)/((holdQty + v_tradeQtySum + decode(v_GageMode,1,GageQty,0))*v_contractFactor)
                where Firmid = NeutralOrder.FirmID
                and CommodityID = p_CommodityID
                and bs_flag = Settle_bs_flag;
            else
              insert into T_FirmHoldSum
                (FirmID, CommodityID,      bs_flag,  holdQty,        holdFunds,FloatingLoss, evenprice,HoldMargin,HoldAssure)
              values
                (NeutralOrder.FirmID, p_CommodityID, Settle_bs_flag, v_tradeQtySum, v_Price*v_tradeQtySum*v_contractFactor,0,         v_Price, v_Margin,  v_Assure);
            end if;

            --更新临时保证金和临时担保金
            update T_Firm
            set runtimemargin = runtimemargin + v_Margin,
                RuntimeAssure = RuntimeAssure + v_Assure
            where Firmid = NeutralOrder.FirmID;
            --更新冻结资金
            v_F_FrozenFunds := FN_F_UpdateFrozenFunds(NeutralOrder.FirmID,v_Margin-v_Assure,'15');

            --2.3、生成中立仓交收持仓明细数据
            --2.3.1、插入延期成交表成交记录
            select SEQ_T_DelayTrade.nextval into v_A_TradeNo from dual;
            insert into T_DelayTrade
              (a_tradeno,       a_orderno,         tradetime,     CustomerID,        CommodityID,            bs_flag,   DelayOrderType,  quantity,   TradeType,    Firmid)
            values
              (v_A_TradeNo,NeutralOrder.A_OrderNo, sysdate,NeutralOrder.CustomerID,  p_CommodityID,     Neutral_bs_flag,    2,    v_tradeQtySum, 1,  NeutralOrder.FirmID);
            --2.3.2、插入交收持仓明细表
            --计算交收保证金
            v_SettleMargin_one := FN_T_ComputeSettleMargin(NeutralOrder.FirmID,p_CommodityID,Neutral_bs_flag,v_tradeQtySum,v_Price);
            if(v_SettleMargin_one < 0) then
                Raise_application_error(-20042, 'ComputeSettleMargin error');
            end if;
            --计算买方交收货款
            if(Neutral_bs_flag = 1) then
                v_Payout_one := FN_T_ComputePayout(NeutralOrder.FirmID,p_CommodityID,Neutral_bs_flag,v_tradeQtySum,v_Price);
                if(v_Payout_one < 0) then
                    Raise_application_error(-20043, 'computePayout error');
                end if;
            end if;
            --计算交收手续费
            if(v_NeutralFeeWay = 0) then
                v_Fee_one := 0;
            else
                v_Fee_one := FN_T_ComputeSettleFee(NeutralOrder.FirmID,p_CommodityID,Neutral_bs_flag,v_tradeQtySum,v_Price);
            end if;
            if(v_Fee_one < 0) then
              Raise_application_error(-20031, 'computeFee error');
            end if;
            --按字段名插入交收持仓明细表
            select SEQ_T_SettleHoldPosition.nextval into v_ID from dual;
            --调用计算函数修改持仓单号 2011-2-15 by feijl
            select FN_T_ComputeHoldNo(SEQ_T_HoldPosition.nextval) into v_A_HoldNo from dual;
            insert into t_settleholdposition
            (id, settleprocessdate, a_holdno, a_tradeno, customerid, commodityid, bs_flag, price, holdqty, openqty, holdtime, holdmargin, firmid, gageqty, holdassure, floatingloss, settlemargin, payout, settlefee, settle_pl, settleaddedtax, settleprice, settletype, holdtype, atcleardate)
            select v_ID,v_TradeDate,v_A_HoldNo, a_tradeno, customerid, commodityid, bs_flag, v_Price, quantity, quantity, sysdate,    0,   firmid,      0,       0,         0,      v_SettleMargin_one,v_Payout_one,v_Fee_one, 0,        0,         v_Price,       3,       2,     v_TradeDate
            from T_DelayTrade
            where a_tradeno=v_A_TradeNo;

            --2.4、更新交易商临时保证金，解冻资金，更新仓单数量
            for delayOrder in(select CommodityID,FirmID,BS_Flag,Quantity,TradeQty,FrozenFunds,UnfrozenFunds from T_DelayOrders where A_OrderNo=NeutralOrder.A_OrderNo)
            loop
                --如果是全部成交，解冻所有冻结资金；如果是部分成交按比例解冻资金
                if((delayOrder.Quantity-delayOrder.TradeQty)=v_tradeQtySum) then
                    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(delayOrder.FirmID,-(delayOrder.FrozenFunds-delayOrder.UnfrozenFunds),'15');
                else
                    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(delayOrder.FirmID,-(delayOrder.FrozenFunds*v_tradeQtySum/delayOrder.Quantity),'15');
                end if;
                if(v_DelayNeedBill = 1) then
                    v_ret := FN_T_D_TradeBill(delayOrder.FirmID,delayOrder.CommodityID,v_tradeQtySum);
                end if;
            end loop;

            --2.5、写交收资金流水
            for SettleHoldPosition in(select a.FirmID,a.CommodityID,sum(a.SettleMargin) SettleMargin,sum(a.Payout) Payout,sum(a.SettleFee) SettleFee,sum(a.Settle_PL) Settle_PL,sum(a.SettleAddedTax) SettleAddedTax  from T_SettleHoldPosition a where a.id=v_ID group by a.FirmID,a.CommodityID)
            loop
                --扣除交收货款，交收手续费，付交收盈利或收交收亏损,交收保证金 ，并写流水
                v_Balance := FN_F_UpdateFundsFull(SettleHoldPosition.FirmID,'15008',SettleHoldPosition.Payout,null,SettleHoldPosition.CommodityID,null,null);
                --注意：支持实时撮合后无法处理最低交收手续费，按实际交收手续费收取
                v_Balance := FN_F_UpdateFundsFull(SettleHoldPosition.FirmID,'15010',SettleHoldPosition.SettleFee,null,SettleHoldPosition.CommodityID,null,null);

                if(SettleHoldPosition.Settle_PL >= 0) then
                    v_Balance := FN_F_UpdateFundsFull(SettleHoldPosition.FirmID,'15011',SettleHoldPosition.Settle_PL,null,SettleHoldPosition.CommodityID,SettleHoldPosition.SettleAddedTax,null);
                else
                    v_Balance := FN_F_UpdateFundsFull(SettleHoldPosition.FirmID,'15012',-SettleHoldPosition.Settle_PL,null,SettleHoldPosition.CommodityID,-SettleHoldPosition.SettleAddedTax,null);
                end if;
                update T_Firm set RuntimeSettleMargin=RuntimeSettleMargin+SettleHoldPosition.SettleMargin where FirmID=SettleHoldPosition.FirmID;
                v_Balance := FN_F_UpdateFundsFull(SettleHoldPosition.FirmID,'15013',SettleHoldPosition.SettleMargin,null,SettleHoldPosition.CommodityID,null,null);
            end loop;
            --2.6、更新委托记录，必须放在最后一步，上面要用到委托的数量，资金信息
            update T_DelayOrders
            set Status=decode(TradeQty+v_tradeQtySum,Quantity,3,2),
                TradeQty=TradeQty+v_tradeQtySum,
                UnfrozenFunds=decode(TradeQty+v_tradeQtySum,Quantity,FrozenFunds,UnfrozenFunds+(FrozenFunds*v_tradeQtySum/Quantity))
            where A_OrderNo=NeutralOrder.A_OrderNo;
        end if;

        exit when NeutralOrder.NotTradeQty > v_tradeQtySum;
    end loop;

    --3、如果交收商品表中没有此商品则插入
    select count(*) into v_num from T_SettleCommodity where CommodityID=p_CommodityID;
    if(v_num = 0) then
        insert into T_SettleCommodity select v_TradeDate,a.* from T_Commodity a where a.CommodityID=p_CommodityID;
    end if;

    return 1;

end;
/

prompt
prompt Creating function FN_T_D_NEUTRALMATCH
prompt =====================================
prompt
create or replace function FN_T_D_NeutralMatch return number
/****
 * 中立仓申报配对
 * 返回值
 * 1 成功
 * -3  交收持仓数量大于可交收持仓数量
 * -4  交收抵顶数量大于可抵顶数量
 * -99  不存在相关数据
 * -100 其它错误
****/
as
    v_version varchar2(10):='1.0.2.2';
    v_ret     number(4);
    v_FL_ret            timestamp;
    v_errorcode number;
    v_errormsg  varchar2(200);
begin
    for cur_Commodity in(select CommodityID from T_Commodity where SettleWay=1 )
    loop
        v_ret := FN_T_D_NeutralMatchOne(cur_Commodity.CommodityID);
        if(v_ret < 0) then
            rollback;
            return v_ret;
        end if;
    end loop;

    --提交后计算此交易商浮亏，让其释放浮亏
    commit;
    v_FL_ret := FN_T_UpdateFloatingLoss(null,null,null);

    return 1;
exception
    when NO_DATA_FOUND then
        rollback;
        return -99;  --不存在相关数据
    when others then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_D_NeutralMatch',v_errorcode,v_errormsg);
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_T_D_UNFROZENBILL
prompt =====================================
prompt
create or replace function FN_T_D_UnFrozenBill(
    p_FirmID     varchar2,   --交易商ID
    p_CommodityID varchar2 ,--商品ID
    p_UnFrozenDelayQty       number --解冻延期数量
) return number
/****
 * 解冻仓单数量
 * 返回值
 * 1  成功
****/
as
	v_version varchar2(10):='1.0.2.2';
    v_WillFrozenQty    number(10);
    v_TempFrozenQty    number(10);
begin
/*
    --1、解冻仓单
    v_WillFrozenQty := p_UnFrozenDelayQty;
    for cur_ValidBill in (select rowid,FrozenDelayQty
                      from T_ValidBill
					  where FirmID_S = p_FirmID
					      and CommodityID = p_CommodityID
					      and BillType = 5
					      and Status = 1 order by CreateTime desc
					  )
    loop
        if(cur_ValidBill.FrozenDelayQty <= v_WillFrozenQty) then
            v_TempFrozenQty := cur_ValidBill.FrozenDelayQty ;
        else
        	v_TempFrozenQty := v_WillFrozenQty ;
        end if;
        update T_ValidBill
        set FrozenDelayQty=FrozenDelayQty-v_TempFrozenQty
        where rowid=cur_ValidBill.rowid;
        v_WillFrozenQty := v_WillFrozenQty - v_TempFrozenQty;
        exit when v_WillFrozenQty=0;
    end loop;
	*/
    return 1;

end;
/

prompt
prompt Creating function FN_T_D_SELLNEUTRALORDER_WD
prompt ============================================
prompt
create or replace function FN_T_D_SellNeutralOrder_WD(
  p_FirmID     varchar2,   --交易商ID
  p_CustomerID     varchar2,  --交易客户ID
  p_CommodityID varchar2 ,--商品ID
  p_Quantity       number ,--委托数量
  p_TradeQty       number ,--已成交数量
  p_Price       number ,--委托价格，行情结算价
  p_A_OrderNo_W     number,  --被撤委托单号
  p_quantity_wd       number,  --撤单数量
  p_frozenfunds     number,  --冻结资金
  p_unfrozenfunds       number  --解冻资金
) return number
/****
 * 中立仓卖委托撤单，该函数不可以执行提交和回滚操作
 * 返回值
 * 1  成功
****/
as
  v_version varchar2(10):='1.0.0.0';
  v_Payout_B    number(15,2);   --买方交收货款
  v_SettleMargin    number(15,2);   --买方交收保证金
  v_to_unfrozenF   number(15,2);
  v_F_FrozenFunds   number(15,2);   --交易商冻结资金
  v_HoldFunds   number(15,2);   --交易商反向持仓保证金
  v_DelayNeedBill number(2);    --延期交收是否需要仓单，0：不需要； 1：需要；
  v_ret  number(4);
begin
  --1. 根据参数是否需要释放冻结仓单
  select DelayNeedBill into v_DelayNeedBill from T_A_Market;
  if(v_DelayNeedBill = 1) then
	v_ret := FN_T_D_UnFrozenBill(p_FirmID,p_CommodityID,p_quantity_wd);
  end if;
  --2. 释放剩余的冻结资金，根据未成交数量
  if(p_Quantity - p_TradeQty = p_quantity_wd) then
    v_to_unfrozenF := p_frozenfunds - p_unfrozenfunds;
  else
    --冻结资金：
    --卖方冻结资金：卖方交收保证金＋反向持仓保证金
    --计算交收保证金
    v_SettleMargin := FN_T_ComputeSettleMargin(p_FirmID,p_CommodityID,2,p_quantity_wd,p_Price);
    --计算反向持仓保证金
    v_HoldFunds := FN_T_ComputeMargin(p_FirmID,p_CommodityID,1,p_quantity_wd,p_Price);
    --应冻结资金
    v_to_unfrozenF := v_SettleMargin + v_HoldFunds;
  end if;
  update T_DelayOrders set unfrozenfunds = unfrozenfunds + v_to_unfrozenF
  where A_orderNo = p_a_orderno_w;
  --3. 更新交易商财务冻结资金
  v_F_FrozenFunds := FN_F_UpdateFrozenFunds(p_FirmID,-v_to_unfrozenF,'15');

  return 1;
end;
/

prompt
prompt Creating function FN_T_D_SELLSETTLEORDER_WD
prompt ===========================================
prompt
create or replace function FN_T_D_SellSettleOrder_WD(
    p_FirmID     varchar2,   --交易商ID
    p_CustomerID     varchar2,  --交易客户ID
    p_CommodityID varchar2 ,--商品ID
    p_Quantity       number ,--委托数量
    p_TradeQty       number ,--已成交数量
    p_Price       number ,--委托价格，行情结算价
    p_A_OrderNo_W     number,  --被撤委托单号
    p_quantity_wd       number,  --撤单数量
    p_frozenfunds     number,  --冻结资金
    p_unfrozenfunds       number  --解冻资金
) return number
/****
 * 卖交收申报委托撤单
 * 返回值
 * 1 成功
****/
as
    v_version varchar2(10):='1.0.2.3';
	v_DelayNeedBill number(2);    --延期交收是否需要仓单，0：不需要； 1：需要；
    v_Margin         number(15,2);   --应收保证金
    v_SettleMargin_S    number(15,2);   --卖方交收保证金
    v_to_unfrozenF   number(15,2);
    v_F_FrozenFunds   number(15,2);   --交易商冻结资金
    v_MarginPriceType         number(1);     --计算成交保证金结算价类型 0:实时和闭市时都按开仓价；1:实时按昨结算价，闭市按当日结算价
    v_LastPrice    number(15,2);   --昨结算价
    v_ret  number(4);
begin
	--1、释放剩余的冻结持仓
    update T_CustomerHoldSum set frozenQty = frozenQty - p_quantity_wd
    where CustomerID = p_CustomerID
      and CommodityID = p_CommodityID
      and bs_flag = 2;
	--2、根据参数是否需要释放冻结仓单
	select DelayNeedBill into v_DelayNeedBill from T_A_Market;
	if(v_DelayNeedBill = 1) then
		v_ret := FN_T_D_UnFrozenBill(p_FirmID,p_CommodityID,p_quantity_wd);
	end if;
    --<<Added by Lizs 2010/7/16 卖交收申报时冻结交收保证金，撤单时解冻
    --3、释放剩余的冻结资金，根据未成交数量
    if(p_Quantity - p_TradeQty = p_quantity_wd) then
        v_to_unfrozenF := p_frozenfunds - p_unfrozenfunds;
    else
        --冻结资金：卖方交收保证金-卖方占用的交易保证金
        --计算交收保证金
        v_SettleMargin_S := FN_T_ComputeSettleMargin(p_FirmID,p_CommodityID,2,p_quantity_wd,p_Price);
        --计算交易保证金
        select MarginPriceType,LastPrice
        into v_MarginPriceType,v_LastPrice
        from T_Commodity where CommodityID=p_CommodityID;
        if(v_MarginPriceType = 1) then
            v_Margin := FN_T_ComputeMargin(p_FirmID,p_CommodityID,2,p_quantity_wd,v_LastPrice);
        else
            v_Margin := FN_T_ComputeMargin(p_FirmID,p_CommodityID,2,p_quantity_wd,p_Price);
        end if;
        if(v_Margin < 0) then
            Raise_application_error(-20040, 'computeMargin error');
        end if;
        v_to_unfrozenF := v_SettleMargin_S - v_Margin;
    end if;
    update T_DelayOrders set unfrozenfunds = unfrozenfunds + v_to_unfrozenF
    where A_orderNo = p_a_orderno_w;
    --更新冻结资金
    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(p_FirmID,-v_to_unfrozenF,'15');
    -->>
    return 1;
end;
/

prompt
prompt Creating function FN_T_D_ORDER_WD
prompt =================================
prompt
create or replace function FN_T_D_Order_WD(
	p_WithdrawerID       varchar2,  --撤单员ID
    p_A_OrderNo_W   number,             --被撤单委托单号
    p_WithdrawType  number,  			--撤单类型 1:委托撤单；4：闭市时自动撤单
    p_Quantity      number,              --撤单成功数量，如果是-1表示现查委托表来计算撤单数量
	p_DelayQuoShowType       number  --延期行情显示类型，0：交收申报结束和中立仓申报结束显示； 1：实时显示；
) return number
/****
 * 延期交易委托撤单
 * 1、如果是自动撤单则撤单员和撤单数量为null
 * 返回值
 * 1 成功
 * 2 已处理过
 * -99  不存在相关数据
 * -100 其它错误
****/
as
    v_version varchar2(10):='1.0.2.3';
    v_a_orderno_w    number(15);
    v_status         number(2);
    v_CommodityID varchar2(16);
    v_FirmID     varchar2(32);
    v_CustomerID     varchar2(40);
    v_bs_flag        number(2);
    v_ordertype      number(2);
    v_quantity       number(10);
    v_price          number(15,2);
    v_tradeqty       number(10);
    v_frozenfunds    number(15,2);
    v_unfrozenfunds  number(15,2);
    v_quantity_wd    number(10);
    v_ret  number(4);
    v_errorcode number;
    v_errormsg  varchar2(200);
begin
    v_a_orderno_w := p_A_OrderNo_W;
    --获取被撤单信息
    select CommodityID, Firmid, bs_flag, DelayOrderType, status, quantity, price, tradeqty, frozenfunds, unfrozenfunds,CustomerID
    into v_CommodityID, v_FirmID, v_bs_flag, v_ordertype, v_status, v_quantity, v_price, v_tradeqty, v_frozenfunds, v_unfrozenfunds,v_CustomerID
    from T_DelayOrders
    where a_orderno = v_a_orderno_w for update;

    if(v_status in (3,5,6)) then
        rollback;
        return 2;  --已处理过
    end if;

    if(p_WithdrawType = 4) then --自动撤单
    	v_quantity_wd := v_quantity - v_tradeqty;
    else
    	if(p_Quantity = -1) then  ---1表示现查委托表来计算撤单数量
    		v_quantity_wd := v_quantity - v_tradeqty;
    	else
        	v_quantity_wd := p_Quantity;
        end if;
    end if;
    if(v_ordertype=1) then    --交收申报
    	if(v_bs_flag = 1) then  --买
    		v_ret := FN_T_D_BuySettleOrder_WD(v_FirmID,v_CustomerID,v_CommodityID,v_Quantity,v_TradeQty,v_Price,v_A_OrderNo_W,v_quantity_wd,v_frozenfunds,v_unfrozenfunds);
    	else  --卖
            v_ret := FN_T_D_SellSettleOrder_WD(v_FirmID,v_CustomerID,v_CommodityID,v_Quantity,v_TradeQty,v_Price,v_A_OrderNo_W,v_quantity_wd,v_frozenfunds,v_unfrozenfunds);
    	end if;
    elsif(v_ordertype=2) then    --中立仓申报
    	-- add by tangzy 2010-08-07
		if(v_bs_flag = 1) then
            v_ret := FN_T_D_BuyNeutralOrder_WD(v_FirmID,v_CustomerID,v_CommodityID,v_Quantity,v_TradeQty,v_Price,v_A_OrderNo_W,v_quantity_wd,v_frozenfunds,v_unfrozenfunds);
		else
		    v_ret := FN_T_D_SellNeutralOrder_WD(v_FirmID,v_CustomerID,v_CommodityID,v_Quantity,v_TradeQty,v_Price,v_A_OrderNo_W,v_quantity_wd,v_frozenfunds,v_unfrozenfunds);
		end if;
    end if;

    --更新委托，1、对于委托撤单需要更新被撤委托的状态（5、6）和撤单类型（1、2）
    --        2、对于自动撤单需要更新被撤委托的状态（5、6）和撤单类型（3、4）
    if(p_WithdrawType = 4) then --自动撤单
          --更新委托状态
          if(v_tradeqty = 0) then
            v_status := 5; --全部撤单
          else
            v_status := 6; --部分成交后撤单
          end if;
	else
        --更新委托状态
        if(v_quantity = v_quantity_wd) then
            v_status := 5; --全部撤单
        elsif(v_quantity > v_quantity_wd) then
            v_status := 6; --部分成交后撤单
        else
            Raise_application_error(-20020, 'Parameter p_quantity > the order ''s available num');
        end if;

    end if;
	update T_DelayOrders set status=v_status,WithdrawType=p_WithdrawType,WithdrawTime=sysdate,WithdrawerID=p_WithdrawerID where A_orderNo = v_a_orderno_w;
    --行情实时显示则要更新行情
    --2010-01-21 解决自动撤单时不影响延期行情
    if(p_WithdrawType=1 and p_DelayQuoShowType = 1) then
	    if(v_ordertype=1) then    --交收申报
	    	if(v_bs_flag = 1) then  --买
	    		update T_DelayQuotation set BuySettleQty=BuySettleQty - v_quantity_wd,CreateTime=sysdate where CommodityID = v_CommodityID;
	    	else  --卖
	    		update T_DelayQuotation set SellSettleQty=SellSettleQty - v_quantity_wd,CreateTime=sysdate where CommodityID = v_CommodityID;
	    	end if;
	    elsif(v_ordertype=2) then    --中立仓申报
	    	-- add by tangzy 2010-08-07
			if(v_bs_flag = 1) then  --买
	    		update T_DelayQuotation set BuyNeutralQty=BuyNeutralQty - v_quantity_wd,CreateTime=sysdate where CommodityID = v_CommodityID;
	    	else  --卖
	    		update T_DelayQuotation set SellNeutralQty=SellNeutralQty - v_quantity_wd,CreateTime=sysdate where CommodityID = v_CommodityID;
	    	end if;
	    end if;
    end if;

    commit;
    return 1;

exception
    when NO_DATA_FOUND then
        rollback;
        return -99;  --不存在相关数据
    when others then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_D_Order_WD',v_errorcode,v_errormsg);
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_T_D_SELLNEUTRALORDER
prompt =========================================
prompt
create or replace function FN_T_D_SellNeutralOrder(
  p_FirmID     varchar2,   --交易商ID
  p_TraderID       varchar2,  --交易员ID
  p_CommodityID varchar2 ,--商品ID
  p_Quantity       number ,--数量
  p_Price       number ,--委托价格，行情结算价
  p_CustomerID     varchar2,  --交易客户ID
  p_ConsignerID    varchar2,  --代为委托员ID
  p_DelayQuoShowType number, --延期行情显示类型，0：交收申报结束和中立仓申报结束显示； 1：实时显示；
  p_DelayNeedBill    number  --延期交收是否需要仓单，0：不需要； 1：需要；
) return number
/****
 * 中立仓申报委托
 * 返回值
 * >0  成功提交，并返回委托单号
 * -2  交易商可用资金不足
 * -32 仓单数量不足
****/
as
  v_version varchar2(10):='1.0.0.0';
  v_Payout_B    number(15,2);   --买方交收货款
  v_SettleMargin    number(15,2);   --交收保证金
  v_HoldFunds     number(15,2);   --反向持仓冻结资金
  v_F_Funds      number(15,2):=0;   --应冻结资金
  v_F_FrozenFunds  number(15,2); --财务冻结资金
  v_A_Funds      number(15,2);   --可用资金
  v_A_OrderNo       number(15); --委托单号
  v_b_s_unsettleqty number(15);--交收申报买卖量之间的差值
  v_NeutralSide number(2); --中立仓方向
  v_ret  number(4);
  v_errorcode number;
  v_errormsg  varchar2(200);
begin
  --1. 根据参数是否需要检查并冻结仓单
  if(p_DelayNeedBill = 1) then
	v_ret := FN_T_D_CheckAndFrozenBill(p_FirmID,p_CommodityID,p_Quantity);
	if(v_ret = -1) then
		rollback;
		return -32;  --仓单数量不足
	end if;
  end if;
  --2. 检查并冻结资金：
  --卖方冻结资金：卖方交收保证金＋反向持仓保证金
  --计算交收保证金
  v_SettleMargin := FN_T_ComputeSettleMargin(p_FirmID,p_CommodityID,2,p_Quantity,p_Price);
  --计算反向持仓保证金
  v_HoldFunds := FN_T_ComputeMargin(p_FirmID,p_CommodityID,1,p_Quantity,p_Price);
  --应冻结资金
  v_F_Funds := v_SettleMargin + v_HoldFunds;
  --计算可用资金，并锁住财务资金
  v_A_Funds := FN_F_GetRealFunds(p_FirmID,1);
  if (v_F_Funds>v_A_Funds) then
    rollback;
    return -2; --可用资金不足
  end if;
  --3. 更新冻结资金
  v_F_FrozenFunds := FN_F_UpdateFrozenFunds(p_FirmID,v_F_Funds,'15');
  --4. 插入延期委托表，并返回委托单号
  select SEQ_T_DelayOrders.nextval into v_A_OrderNo from dual;
  insert into T_DelayOrders
    ( a_orderno,    CommodityID,   CustomerID,    traderid,   bs_flag, DelayOrderType, status, quantity, price, tradeqty, frozenfunds, unfrozenfunds, ordertime, withdrawtime, ordererip, signature,  FirmID ,ConsignerID)
  values
    (v_A_OrderNo,  p_CommodityID, p_CustomerID,  p_TraderID,         2,           2,         1,p_Quantity, p_Price,  0,     v_F_Funds,       0,         sysdate,      null,       null,     null,     p_FirmID ,p_ConsignerID);

  --5. 行情实时显示则要更新行情
  if(p_DelayQuoShowType = 1) then
    update T_DelayQuotation set SellNeutralQty=nvl(SellNeutralQty,0) + p_Quantity,CreateTime=sysdate where CommodityID = p_CommodityID;
  end if;

  commit;
  return v_A_OrderNo;
exception
  when NO_DATA_FOUND then
    rollback;
    return -99;  --不存在相关数据
  when others then
  v_errorcode:=sqlcode;
  v_errormsg :=sqlerrm;
  rollback;
  insert into T_DBLog(err_date,name_proc,err_code,err_msg)
  values(sysdate,'FN_T_D_SellNeutralOrder',v_errorcode,v_errormsg);
  commit;
  return -100;
end;
/

prompt
prompt Creating function FN_T_D_SELLSETTLEORDER
prompt ========================================
prompt
create or replace function FN_T_D_SellSettleOrder(
    p_FirmID     varchar2,   --交易商ID
    p_TraderID       varchar2,  --交易员ID
    p_CommodityID varchar2 ,--商品ID
    p_Quantity       number ,--数量
    p_Price       number ,--委托价格，行情结算价
  p_CustomerID     varchar2,  --交易客户ID
  p_ConsignerID       varchar2,  --代为委托员ID
  p_DelayQuoShowType       number,  --延期行情显示类型，0：交收申报结束和中立仓申报结束显示； 1：实时显示；
  p_DelayNeedBill       number  --延期交收是否需要仓单，0：不需要； 1：需要；
) return number
/****
 * 卖交收申报委托
 * 根据配置修改申报数量判断，用净订货量还是单边总持仓判断 by chenxc 2011-09-20
 * 返回值
 * >0  成功提交，并返回委托单号
 * -2  资金余额不足
 * -31  持仓不足
 * -32  仓单数量不足
 * -99  不存在相关数据
 * -100 其它错误
****/
as
    v_version varchar2(10):='1.0.2.3';
    v_HoldSum        number(10):=0;   --卖方持仓合计数量
    v_SettleMargin_S    number(15,2);   --卖方交收保证金
    v_SettleMargin_SSum    number(15,2):=0;   --卖方交收保证金汇总
    v_TradeMargin_S    number(15,2);   --卖方交易保证金
    v_TradeMargin_SSum    number(15,2):=0;   --卖方交易保证金汇总
    v_F_Funds      number(15,2):=0;   --应冻结资金
    v_A_Funds      number(15,2);   --可用资金
    v_F_FrozenFunds  number(15,2); --财务冻结资金
    v_ret  number(4);
    v_A_OrderNo       number(15); --委托单号
    v_HoldOrderNo  number(15):=0;--持仓委托单号
    v_errorcode number;
    v_errormsg  varchar2(200);
    v_DelayOrderIsPure        number(1);   --交收申报是否按净订货量申报
  v_HoldSum_S        number(10):=0;   --卖方持仓合计数量
  v_DelaySettlePriceType         number(10);   --交收申报交收类型 0：按结算价交收申报 ， 1：按订立价交收  -- add  by zhangjian
   v_sql varchar2(500);
   v_qtySum number(15):=0;  --已委托的交收申报冻结数量
   v_price number(15,6);-- 交收申报价格
   v_theOrderPriceSum number(15,6):=0;-- 本次交收申报订立价格汇总
   v_holdQty number(15):=0;--每笔持仓明细中的持仓数量
   v_tempQty number(15):=0;--中间变量
    v_alreadyQty number(15):=0;--本次委托已冻结数量
  type cur_T_HoldPosition is ref cursor;
  v_HoldPosition cur_T_HoldPosition;
  v_orderLogNo number(15):=0;--委托下单日志 ID。
  v_orderSumLogNo number(15):=0;--委托下单日志合计数据 ID；
  v_HoldSum_B number;
begin
  --1、检查持仓并冻结持仓
  begin
      select nvl(holdQty - frozenQty, 0) into v_HoldSum
      from T_CustomerHoldSum
      where CustomerID = p_CustomerID
        and CommodityID = p_CommodityID
        and bs_flag = 2 for update;
  exception
        when NO_DATA_FOUND then
            rollback;
           return -31;  --持仓不足
    end;
    --根据配置修改申报数量判断，用净订货量还是单边总持仓判断 by chenxc 2011-09-20
    --交收申报是否按净订货量申报
  select DelayOrderIsPure into v_DelayOrderIsPure from T_A_Market;
  if(v_DelayOrderIsPure = 1) then --按净订货量申报
      begin
        select holdQty+GageQty into v_HoldSum_B
        from T_CustomerHoldSum
        where CustomerID = p_CustomerID
          and CommodityID = p_CommodityID
          and bs_flag = 1 ;
    exception
          when NO_DATA_FOUND then
              v_HoldSum_S := 0;
      end;
      if(v_HoldSum-v_HoldSum_B < p_Quantity) then
          rollback;
          return -31;  --净订货量不足
      end if;
  else
      if(v_HoldSum < p_Quantity) then
          rollback;
          return -31;  --持仓不足
      end if;
    end if;
    --<<Added by Lizs 2010/7/15 卖交收申报时增加冻结交收保证金
    --2、检查并冻结资金：冻结卖方交收保证金-卖方占用的交易保证金
     --根据交收申报价格类型 判断如何冻结资金。0：按结算价交收 ；1：按订立价交收  mod by zhangjian
    select   DelaySettlePriceType into v_DelaySettlePriceType from t_commodity where commodityid=p_CommodityID;
    if(v_DelaySettlePriceType=1) then -- 如果是按订立价交收

      select nvl(sum(Quantity-TradeQty),0) into v_qtySum from T_DelayOrders where  commodityid=p_CommodityID and customerid=p_CustomerID   and status in (1,2) and bs_flag=2;
     -- select sum(quantity) into   v_aheadSettleQty from T_E_ApplyAheadSettle;
     -- v_qtySum:=v_qtySum+v_aheadSettleQty;--已经冻结的数量

    v_sql:='select price,HoldQty,a.A_HoldNo   from T_holdposition a,(select A_HoldNo from T_SpecFrozenHold group by A_HoldNo) b
                 where (a.HoldQty+a.GageQty) > 0 and a.A_HoldNo=b.A_HoldNo(+) and CustomerID='''||  p_CustomerID||'''
                   and CommodityID ='''|| p_CommodityID||''' and bs_flag =  2   '||' order by a.A_HoldNo';
     open v_HoldPosition for v_sql;
        loop
            fetch v_HoldPosition into v_price,v_holdQty,v_HoldOrderNo;
            exit when v_HoldPosition%NOTFOUND;
            v_HoldSum_S:=v_HoldSum_S+v_holdQty;
            v_tempQty:=0; --每次清空遍历数量
            if(v_HoldSum_S>v_qtySum)then --计算交收货款以及交收保证金累积，必须是大于当前延期委托表中已经存在的。
            if(p_Quantity>=(v_HoldSum_S-v_qtySum))then
            v_tempQty:=v_HoldSum_S-v_qtySum-v_alreadyQty;--当前冻结的数量
            v_alreadyQty:=v_tempQty+v_alreadyQty;
            else  --如果不满足当前条件则退出遍历
            v_tempQty:=p_Quantity-v_alreadyQty;
            v_HoldSum_S:=0;
             end if;
            end if;

           --计算交易保证金
              v_TradeMargin_S := FN_T_ComputeMargin(p_FirmID,p_CommodityID,2,v_tempQty,v_price);
            --计算交收保证金
              v_SettleMargin_S := FN_T_ComputeSettleMargin(p_FirmID,p_CommodityID,2,v_tempQty,v_price);

               v_TradeMargin_SSum :=v_TradeMargin_SSum+v_TradeMargin_S;--累加交易保证金
              v_SettleMargin_SSum :=v_SettleMargin_SSum+v_SettleMargin_S;--累加交收保证金
              v_theOrderPriceSum :=v_theOrderPriceSum+v_price*v_tempQty;--累加订立价格


                --循环每笔持仓明细都要插入委托日志  add by zhangjian 2012年3月2日
                   select SEQ_T_D_OrderLog.nextval into v_orderLogNo  from dual  ;
             insert into T_D_DelayOrderLog  values (v_orderLogNo,p_firmid,2,p_CommodityID,v_HoldOrderNo,v_price,v_tempQty,v_SettleMargin_S,v_TradeMargin_S,0,Sysdate,null );

               if(v_HoldSum_S=0)then
                   v_price:=v_theOrderPriceSum/p_Quantity;--如果退出循环则计算平均订立价格
                   exit;
               end if;

            end loop;

   elsif(v_DelaySettlePriceType=0)then --如果是按结算价交收
    v_price:=p_Price;
    --计算交易保证金
    v_TradeMargin_S := FN_T_ComputeMargin(p_FirmID,p_CommodityID,2,p_Quantity,v_price);
    --计算交收保证金
    v_SettleMargin_S := FN_T_ComputeSettleMargin(p_FirmID,p_CommodityID,2,p_Quantity,v_price);
              v_TradeMargin_SSum :=v_TradeMargin_S;
              v_SettleMargin_SSum :=v_SettleMargin_S;
  end if;
    --计算交收保证金
    --v_SettleMargin_S := FN_T_ComputeSettleMargin(p_FirmID,p_CommodityID,2,p_Quantity,p_Price);
    --计算交易保证金
    --v_TradeMargin_S := FN_T_ComputeMargin(p_FirmID,p_CommodityID,2,p_Quantity,p_Price);
    --应冻结资金

    v_F_Funds := v_SettleMargin_SSum - v_TradeMargin_SSum;
    --计算可用资金，并锁住财务资金
    v_A_Funds := FN_F_GetRealFunds(p_FirmID,1);

       --插入延期委托合计表日志   --add by zhangjian  2012年3月2日
    select SEQ_T_D_OrderSumLog.nextval  into v_orderSumLogNo from dual;
    insert into  T_D_DelayOrderSumLog values (v_orderSumLogNo,p_firmid,2,p_CommodityID,v_price,p_Quantity,v_SettleMargin_SSum,v_TradeMargin_SSum,0,v_A_Funds,v_F_Funds,Sysdate,null);


    if(v_A_Funds < v_F_Funds) then
        rollback;
        return -2;  --资金余额不足
    end if;
    --3、更新交易客户持仓合计的冻结数量
    update T_CustomerHoldSum set frozenQty = frozenQty + p_Quantity
    where CustomerID = p_CustomerID
    and CommodityID = p_CommodityID
    and bs_flag = 2;
    --4、根据参数是否需要检查并冻结仓单
    if(p_DelayNeedBill = 1) then
    v_ret := FN_T_D_CheckAndFrozenBill(p_FirmID,p_CommodityID,p_Quantity);
    if(v_ret = -1) then
          rollback;
          return -32;  --仓单数量不足
      end if;
  end if;
    --5、更新冻结资金
    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(p_FirmID,v_F_Funds,'15');
    -->>======================================================================
    --6、插入延期委托表，并返回委托单号
    select SEQ_T_DelayOrders.nextval into v_A_OrderNo from dual;
    insert into T_DelayOrders
      ( a_orderno,    CommodityID,   CustomerID,    traderid,   bs_flag, DelayOrderType, status, quantity, price, tradeqty, frozenfunds, unfrozenfunds, ordertime, withdrawtime, ordererip, signature,  FirmID ,ConsignerID)
    values
      (v_A_OrderNo,  p_CommodityID, p_CustomerID,  p_TraderID,     2,           1,          1,  p_Quantity, v_price,  0,      v_F_Funds,         0,         sysdate,      null,       null,     null,     p_FirmID ,p_ConsignerID);

    --行情实时显示则要更新行情
    if(p_DelayQuoShowType = 1) then
      update T_DelayQuotation set SellSettleQty=SellSettleQty + p_Quantity,CreateTime=sysdate where CommodityID = p_CommodityID;
    end if;

    commit;
    return v_A_OrderNo;
exception
    when NO_DATA_FOUND then
        rollback;
        return -99;  --不存在相关数据
    when others then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_D_SellSettleOrder',v_errorcode,v_errormsg);
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_T_D_SETTLEMATCHONE
prompt =======================================
prompt
create or replace function FN_T_D_SettleMatchOne
(
  p_CommodityID varchar2 --商品代码
)  return number
/****
 * 某商品交收申报配对
 * 返回值
 * 1 成功
 * -1  买方成交数量出错
 * -3  交收持仓数量大于可交收持仓数量
 * -4  交收抵顶数量大于可抵顶数量
****/
as
	v_version varchar2(10):='1.0.2.2';
    v_ret     number(4);
    v_OrderTradeQty      number(10):=0;
    v_TradeDate     date;
    v_Balance    number(15,2):=0;
    v_UnfrozenFunds   number(15,2);
    v_F_FrozenFunds   number(15,2);
    v_Status            number(2);
    v_num            number(10);
    v_DelayNeedBill number(2);    --延期交收是否需要仓单，0：不需要； 1：需要；
    v_tradedAmount   number(10):=0;  --成交数量
    v_unCloseQty     number(10); --未平数量，用于中间计算
    v_NeutralMatchPriority   number(2); --中立仓反向持仓是否优先撮合,0:不优先；1：优先
begin
	--1、如果交收商品表中没有此商品则插入
    select count(*) into v_num from T_SettleCommodity where CommodityID=p_CommodityID;
	if(v_num = 0) then
		select TradeDate into v_TradeDate from T_SystemStatus;
		insert into T_SettleCommodity select v_TradeDate,a.* from T_Commodity a where a.CommodityID=p_CommodityID;
	end if;
    select DelayNeedBill into v_DelayNeedBill from T_A_Market;
    select NEUTRALMATCHPriority into v_NeutralMatchPriority from t_a_market;
    --2、轮询买委托记录（中立仓反向持仓优先撮合时有反向持仓的会员委托优先排序，不优先时只按委托号排序）
    --for delayOrder_B in(select A_OrderNo,CommodityID,CustomerID,BS_Flag,(Quantity-TradeQty) NotTradeQty,Price,FrozenFunds,UnfrozenFunds,Quantity,FirmID from T_DelayOrders where DelayOrderType=1 and Status in(1,2) and BS_Flag=1 and CommodityID=p_CommodityID order by A_OrderNo for update)
    for delayOrder_B in(select A_OrderNo,CommodityID,CustomerID,BS_Flag,(Quantity-TradeQty) NotTradeQty,Price,FrozenFunds,UnfrozenFunds,Quantity,FirmID from T_DelayOrders,(select distinct(t.FirmID) as FID,1 as OrderType from T_HoldPosition t where t.BS_Flag=1 and t.HoldType=decode(v_NeutralMatchPriority,1,2,0) and t.CommodityID=p_CommodityID) hp where DelayOrderType=1 and Status in(1,2) and BS_Flag=1 and CommodityID=p_CommodityID and firmid=hp.FID(+) order by nvl(hp.OrderType,0) desc,A_OrderNo for update of A_OrderNo)
    loop
    	v_unCloseQty := delayOrder_B.NotTradeQty;
    	--轮询卖委托记录，成交完买委托的数量
      --for delayOrder_S in(select A_OrderNo,CommodityID,CustomerID,BS_Flag,(Quantity-TradeQty) NotTradeQty,Price,FrozenFunds,UnfrozenFunds,Quantity,FirmID from T_DelayOrders where DelayOrderType=1 and Status in(1,2) and BS_Flag=2 and CommodityID=p_CommodityID order by A_OrderNo for update)
      for delayOrder_S in(select A_OrderNo,CommodityID,CustomerID,BS_Flag,(Quantity-TradeQty) NotTradeQty,Price,FrozenFunds,UnfrozenFunds,Quantity,FirmID from T_DelayOrders,(select distinct(t.FirmID) as FID,1 as OrderType from T_HoldPosition t where t.BS_Flag=2 and t.HoldType=decode(v_NeutralMatchPriority,1,2,0) and t.CommodityID=p_CommodityID) hp where DelayOrderType=1 and Status in(1,2) and BS_Flag=2 and CommodityID=p_CommodityID and firmid=hp.FID(+) order by nvl(hp.OrderType,0) desc,A_OrderNo for update of A_OrderNo)
    	loop
    		if(delayOrder_S.NotTradeQty <= v_unCloseQty) then  --全部成交
    			v_tradedAmount:=delayOrder_S.NotTradeQty;
    			v_Status := 3;
    			v_UnfrozenFunds:=delayOrder_S.FrozenFunds-delayOrder_S.UnfrozenFunds;
            else  --部分成交
                v_tradedAmount:=v_unCloseQty;
                v_Status := 2;
    			v_UnfrozenFunds:=delayOrder_S.FrozenFunds*v_tradedAmount/delayOrder_S.Quantity;
    		end if;
	    	update T_DelayOrders set Status=v_Status,TradeQty=TradeQty+v_tradedAmount,UnfrozenFunds=UnfrozenFunds+v_UnfrozenFunds where A_OrderNo=delayOrder_S.A_OrderNo;
	        --更新冻结资金
			v_F_FrozenFunds := FN_F_UpdateFrozenFunds(delayOrder_S.FirmID,-v_UnfrozenFunds,'15');
    		if(v_DelayNeedBill = 1) then
    			v_ret := FN_T_D_TradeBill(delayOrder_S.FirmID,delayOrder_S.CommodityID,v_tradedAmount);
    		end if;
    		--卖方持仓交收，涉及持仓明细，持仓合计，资金
	    	v_ret := FN_T_D_SettleOne(delayOrder_S.CommodityID,delayOrder_S.Price,delayOrder_S.BS_Flag,delayOrder_S.CustomerID,v_tradedAmount,0);
	    	if(v_ret < 0) then
	    		rollback;
	        	return v_ret;
	    	end if;
    		v_unCloseQty:=v_unCloseQty - v_tradedAmount;
    		exit when v_unCloseQty=0;
    	end loop;
    	v_OrderTradeQty := delayOrder_B.NotTradeQty-v_unCloseQty;
    	if(v_unCloseQty = 0) then  --全部成交
    		v_Status := 3;
    		v_UnfrozenFunds:=delayOrder_B.FrozenFunds-delayOrder_B.UnfrozenFunds;
    	elsif(v_unCloseQty > 0 and v_unCloseQty < delayOrder_B.NotTradeQty) then  --部分成交
    		v_Status := 2;
    		v_UnfrozenFunds:=delayOrder_B.FrozenFunds*v_OrderTradeQty/delayOrder_B.Quantity;
    	elsif(v_unCloseQty = delayOrder_B.NotTradeQty) then  --无卖方配对记录，成功返回
    		return 1;
    	else  --出错回滚，要交收数量为负数了
    		rollback;
	        return -1;
    	end if;
    	update T_DelayOrders set Status=v_Status,TradeQty=TradeQty+v_OrderTradeQty,UnfrozenFunds=UnfrozenFunds+v_UnfrozenFunds where A_OrderNo=delayOrder_B.A_OrderNo;
        --更新冻结资金
		v_F_FrozenFunds := FN_F_UpdateFrozenFunds(delayOrder_B.FirmID,-v_UnfrozenFunds,'15');
		--买方持仓交收，涉及持仓明细，持仓合计，资金
    	v_ret := FN_T_D_SettleOne(delayOrder_B.CommodityID,delayOrder_B.Price,delayOrder_B.BS_Flag,delayOrder_B.CustomerID,v_OrderTradeQty,0);
    	if(v_ret < 0) then
    		rollback;
        	return v_ret;
    	end if;
    end loop;

    return 1;

end;
/

prompt
prompt Creating function FN_T_D_SETTLEMATCH
prompt ====================================
prompt
create or replace function FN_T_D_SettleMatch return number
/****
 * 交收申报配对
 * 返回值
 * 1 成功
 * -1  买方成交数量出错
 * -3  交收持仓数量大于可交收持仓数量
 * -4  交收抵顶数量大于可抵顶数量
 * -99  不存在相关数据
 * -100 其它错误
****/
as
	v_version varchar2(10):='1.0.2.2';
    v_ret     number(4);
    v_FL_ret            timestamp;
    v_errorcode number;
    v_errormsg  varchar2(200);
begin
    for cur_Commodity in(select CommodityID from T_Commodity where SettleWay=1 )
    loop
    	v_ret := FN_T_D_SettleMatchOne(cur_Commodity.CommodityID);
    	if(v_ret < 0) then
    		rollback;
        	return v_ret;
    	end if;
    end loop;

    --提交后计算此交易商浮亏，让其释放浮亏
    commit;
    v_FL_ret := FN_T_UpdateFloatingLoss(null,null,null);

    return 1;
exception
    when NO_DATA_FOUND then
        rollback;
        return -99;  --不存在相关数据
    when others then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_D_SettleMatch',v_errorcode,v_errormsg);
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_T_FIRMADD
prompt ==============================
prompt
create or replace function FN_T_FirmAdd
(
    p_FirmID m_firm.firmid%type --交易商代码
)return integer is
  /**
  * 订单系统添加交易商
  * 返回值： 1 成功
  注意不要提交commit，因为别的函数要调用它；
  **/
  v_cnt                number(5); --数字变量
begin
  --1、插入交易商表，默认正常状态
    select count(*) into v_cnt from T_Firm where firmid=p_firmid;
    if(v_cnt=0) then
        insert into T_Firm(FirmID,Status,ModifyTime) values(p_FirmID,0,sysdate);
    end if;
    --2、插入一条默认交易商ID+00小号的客户到客户表
    select count(*) into v_cnt from T_Customer where CustomerID=p_firmid||'00';
    if(v_cnt=0) then
        insert into T_Customer(CustomerID, FirmID,  Code,Status,CreateTime,ModifyTime)
        values( p_FirmID||'00', p_FirmID ,'00', 0, sysdate, sysdate);
    end if;

    return 1;
end;
/

prompt
prompt Creating function FN_T_FIRMDEL
prompt ==============================
prompt
create or replace function FN_T_FirmDel
(
    p_FirmID m_firm.firmid%type --交易商代码
)return integer is
  /**
  * 订单系统删除交易商
  * 返回值： 1 成功
  注意不要提交commit，因为别的函数要调用它；
  **/
  v_cnt                number(5); --数字变量
begin
  /*---mengyu 2013.08.29  注销交易不能删除更改数据保留即可*/
  /*  --2、删除交易商特殊保证金表此交易商记录，历史记录更新交易商ID加上_
  update T_H_FirmMargin set FirmID=FirmID || '_' where FirmID=p_FirmID;
    delete from T_A_FirmMargin where FirmID=p_FirmID;
    --3、删除交易商特殊手续费表此交易商记录，历史记录更新交易商ID加上_
    update T_H_FirmFee set FirmID=FirmID || '_' where FirmID=p_FirmID;
    delete from T_A_FirmFee where FirmID=p_FirmID;
    --4、删除特殊持仓量表此交易商记录
    delete from T_A_FirmMaxHoldQty where FirmID=p_FirmID;
    --5、删除委托表此交易商记录，历史记录更新交易商ID加上_
    update T_H_Orders set FirmID=FirmID || '_' where FirmID=p_FirmID;
    delete from T_Orders where FirmID=p_FirmID;
    --6、删除成交表此交易商记录，历史记录更新交易商ID加上_
    update T_H_Trade set FirmID=FirmID || '_' where FirmID=p_FirmID;
    delete from T_Trade where FirmID=p_FirmID;
    --7、删除持仓明细表中此交易商记录，历史记录更新交易商ID加上_
    update T_H_HoldPosition set FirmID=FirmID || '_' where FirmID=p_FirmID;
    delete from T_HoldPosition where FirmID=p_FirmID;
    --8、删除交易客户持仓合计表此交易商记录，历史记录更新交易商ID加上_
    update T_H_CustomerHoldSum set FirmID=FirmID || '_' where FirmID=p_FirmID;
    delete from T_CustomerHoldSum where FirmID=p_FirmID;
    --9、删除交易商持仓合计表此交易商记录，历史记录更新交易商ID加上_
    update T_H_FirmHoldSum set FirmID=FirmID || '_' where FirmID=p_FirmID;
    delete from T_FirmHoldSum where FirmID=p_FirmID;
    --11、更新交收交易客户持仓合计表此交易商记录，交易商ID加上_
    update T_SettleHoldPosition set FirmID=FirmID || '_' where FirmID=p_FirmID;
    --14、删除交易员表此交易商记录
    delete from T_Trader where TraderID in(select TraderID from M_Trader where FirmID=p_FirmID);
    --15、删除交易客户表此交易商记录
    delete from T_Customer where FirmID=p_FirmID;
    --16、删除交易商表此交易商，历史记录更新交易商ID加上_
    update T_H_Firm set FirmID=FirmID || '_' where FirmID=p_FirmID;
    delete from T_Firm where FirmID=p_FirmID;
    */
    return 1;

end;
/

prompt
prompt Creating function FN_T_FIRMEXITCHECK
prompt ====================================
prompt
CREATE OR REPLACE FUNCTION FN_T_FirmExitCheck
(
    p_FirmID in varchar2       --交易商ID
) RETURN NUMBER
/****
 * 交易商退市检查
 * 1、注意不要提交commit，因为别的函数要调用它；
 * 返回值
 * 1 成功
 * -1：此交易商存在持仓，不能退市！
****/
as
	v_version varchar2(10):='1.0.0.1';
    v_num   number(10);
begin
    --1、检查交易商是否存在持仓
    select nvl(sum(HoldQty+GageQty),0) into v_num from T_FirmHoldSum where FirmID=p_FirmID;
    if(v_num > 0) then
        return -1;
    end if;

    return 1;
end;
/

prompt
prompt Creating function FN_T_GAGECLOSEORDER
prompt =====================================
prompt
create or replace function FN_T_GageCloseOrder(
    p_FirmID         varchar2,   --交易商ID
    p_TraderID       varchar2,  --交易员ID
    p_CommodityID    varchar2 default null,
    p_bs_flag        number default null,
    p_price          number default null,
    p_quantity       number default null,
    p_closeMode      number default null,
    p_specPrice      number default null,
    p_timeFlag       number default null,
    p_closeFlag      number default null,   --平仓标志
	  p_CustomerID     varchar2,  --交易客户ID
	  p_ConsignerID    varchar2  --委托员ID
) return number
/****
 * 抵顶转让委托 add by yukx 20100424
 * 返回值
 * >0  成功提交，并返回委托单号
 * -21  持仓不足
 * -22  指定仓不足
 * -99  不存在相关数据
 * -100 其它错误
****/
as
	v_version varchar2(10):='1.0.3.x';
  v_HoldSum        number(10);
    v_A_OrderNo      number(15);   --委托号
    v_errorcode number;
    v_errormsg  varchar2(200);
begin
	--1验证数量
	begin
	    select nvl(GageQty - GageFrozenQty, 0) into v_HoldSum
	    from T_CustomerHoldSum
	    where CustomerID = p_CustomerID
	      and CommodityID = p_CommodityID
	      and bs_flag != p_bs_flag for update;
    exception
        when NO_DATA_FOUND then
	        rollback;
	        return -21;  --持仓不足
    end;
    if(v_HoldSum < p_quantity) then
        rollback;
        return -21;  --持仓不足
    end if;

    --2客户持仓合计抵顶冻结数量增加
    update T_CustomerHoldSum set GageFrozenQty = GageFrozenQty+p_quantity
           where CustomerID = p_CustomerID and CommodityID = p_CommodityID and BS_Flag != p_bs_flag;

    commit;

     --3、产生委托单号并插入委托表
	--调用计算函数修改委托单号 2011-2-15 by feijl
    select FN_T_ComputeOrderNo(SEQ_T_Orders.nextval) into v_A_OrderNo from dual;
    insert into T_Orders
      ( a_orderno,  a_orderno_w,   CommodityID,   Firmid,    traderid,   bs_flag,   ordertype, status, quantity, price, closemode, specprice,       timeflag,tradeqty, frozenfunds, unfrozenfunds, ordertime, withdrawtime, ordererip, signature,closeFlag,   CustomerID,ConsignerID,BillTradeType)
    values
      (v_A_OrderNo,   null,        p_CommodityID, p_Firmid,  p_traderid, p_bs_flag,     2,        1,  p_quantity, p_price, p_closemode, p_specprice, p_timeflag, 0,        0,              0,         sysdate,      null,       null,     null,  p_closeFlag,p_CustomerID,p_ConsignerID,2);

    return v_A_OrderNo;

exception
    when NO_DATA_FOUND then
        rollback;
        return -99;  --不存在相关数据
    when others then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_GageCloseOrder',v_errorcode,v_errormsg);
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_T_GAGECLOSETRADE
prompt =====================================
prompt
create or replace function FN_T_GageCloseTrade(
    p_A_OrderNo     number,  --委托单号
    p_M_TradeNo     number,  --撮合成交号
    p_Price         number,  --成交价
    p_Quantity      number,   --成交数量
  p_M_TradeNo_Opp     number,  --对方撮合成交号
    p_CommodityID varchar2,
    p_FirmID     varchar2,
    p_TraderID       varchar2,
    p_bs_flag        number,
    p_status         number,
    p_orderQty       number,--委托数量
    p_orderTradeQty       number,--委托已成交数量
    p_CustomerID        varchar2,
    p_OrderType      number,
    p_closeMode      number,
    p_specPrice      number,
    p_timeFlag       number,
    p_CloseFlag      number,
    p_contractFactor number,
  p_MarginPriceType         number,     --计算成交保证金结算价类型 0:实时和闭市时都按开仓价；1:实时按昨结算价，闭市按当日结算价;2:盘中按订立价，闭市结算时按当日结算价;
    p_marginAlgr         number,
    p_marginRate_b         number,
    p_marginRate_s         number,
    p_marginAssure_b         number,
    p_marginAssure_s         number,
    p_feeAlgr       number,
    p_feeRate_b         number,
    p_feeRate_s         number,
    p_TodayCloseFeeRate_B         number,
    p_TodayCloseFeeRate_S         number,
    p_HistoryCloseFeeRate_B         number,
    p_HistoryCloseFeeRate_S         number,
    p_ForceCloseFeeAlgr       number,
    p_ForceCloseFeeRate_B         number,
    p_ForceCloseFeeRate_S         number,
    p_YesterBalancePrice    number,
  p_AddedTaxFactor          number,  --增值税率系数=AddedTax/(1+AddedTax)
  p_GageMode    number,
  p_CloseAlgr    number,
  p_TradeDate date,
  p_FirmID_opp     varchar2
) return number
/****
 * 抵顶转让成交回报 仿平仓成交 指定平仓相关均被去掉  mod by yukx 20100427
 * 1、注意不要提交commit，因为别的函数要调用它；
 * 返回值
 * 1 成功
 * -1 成交数量大于未成交数量
 * -2 成交数量大于冻结数量
 * -3 平仓成交数量大于持仓数量
 * -100 其它错误
****/
as
  v_version varchar2(10):='1.0.3.x';
    v_price          number(15,2);
    v_frozenQty      number(10);
    v_holdQty        number(10);
    v_a_tradeno_closed number(15);
    v_Margin         number(15,2):=0;   --应收保证金
  v_Assure         number(15,2):=0;   --应收担保金
  v_Fee            number(15,2):=0;   --应收费用
    v_Fee_one            number(15,2);   --应收费用
    v_A_TradeNo      number(15);
    v_A_HoldNo       number(15);
    v_id             number(15);
    v_tmp_bs_flag    number(2);
    v_TradeType      number(1);
    v_AtClearDate          date;
    v_HoldTime          date;
    v_MarginPrice    number(15,2);  --计算成交保证金的价格
  v_HoldFunds    number(15,2):=0;  --平仓时应退持仓金额
    v_unCloseQty     number(10):=p_quantity; --未平数量，用于中间计算
  v_closeFL    number(15,2):=0;
    v_closeFL_one    number(15,2);   --单笔平仓盈亏，用于中间计算
  v_CloseAddedTax_one    number(15,2);   --单笔平仓增值税
    v_margin_one     number(15,2);   --用于中间计算
  v_Assure_one     number(15,2);   --用于中间计算
    v_tradedAmount   number(10):=0;  --成交数量
  v_GageQty       number(10);
  v_GageQty_fsum       number(10);
  v_F_FrozenFunds   number(15,2);
  type c_T_HoldPosition is ref cursor;
  v_T_HoldPosition c_T_HoldPosition;
  v_sql varchar2(500);
  v_str  varchar2(200);
  v_orderby  varchar2(100);
  v_firmHoldfunds number(15,2);--add by yukx 20100428 交易商持仓金额
  v_closeTodayHis        number(2);    --平今仓还是历史仓(0平今仓；1平历史仓)
  v_num            number(10);
        v_holddaysLimit number(1):=0;
begin
      --成交类型：抵顶转让  mod by yukx 20100427
      v_TradeType := 8;
      /*-- mod by yukx 20100427
      if(p_TraderID is not null) then
          v_TradeType := 1;  --有交易员为正常交易（开，平仓）
      else
        if(p_CloseFlag = 2) then
          v_TradeType := 3;  --交易员为空且平仓标志为2表示市场强平
        else
          v_TradeType := 4;  --否则有交易员的表示委托交易（开，平仓）
        end if;
      end if;
      */

        if(p_bs_flag=1) then  --委托平仓的买卖标志
            v_tmp_bs_flag:=2; --相当于被平仓的买卖标志
        else
            v_tmp_bs_flag:=1;
        end if;
        select GageQty into v_frozenQty --  mod by yukx 20100427
        from T_CustomerHoldSum
        where CustomerID = p_CustomerID
          and CommodityID = p_CommodityID
          and bs_flag = v_tmp_bs_flag for update;
        if(v_frozenqty <p_quantity) then
            rollback;
            return -2;
        end if;

        /*-- mod by yukx 20100427
        --指定平仓查询条件
        if(p_closeMode = 2) then  --指定时间平仓
            if(p_timeFlag = 1) then  --平今仓
                --从持仓明细表获得该交易客户当日该商品持仓合计
                v_str := ' and to_char(AtClearDate,''yyyy-MM-dd'')=''' || to_char(p_TradeDate,'yyyy-MM-dd') || ''' ';
          elsif(p_timeFlag = 2) then  --平历史仓
                  --从持仓明细表获得该交易客户非当日该商品持仓合计
                  v_str := ' and to_char(AtClearDate,''yyyy-MM-dd'')<>''' || to_char(p_TradeDate,'yyyy-MM-dd') || ''' ';
          end if;
        elsif(p_closeMode = 3) then  --指定价格平仓
            v_str := ' and Price =' || p_specPrice || ' ';
        end if;
        */

    --根据平仓算法(0先开先平；1后开先平；2持仓均价平仓(不排序)选择排序条件
    --2009-08-04增加强平时按后开先平顺序
    if(p_TraderID is null and p_CloseFlag = 2) then
      --v_orderby := ' order by A_HoldNo desc ';
              select holddayslimit into v_holddaysLimit from t_commodity where commodityid=p_CommodityID;
              if(v_holddaysLimit=0) then   --无持仓天数限制
                v_orderby := ' order by a.A_HoldNo desc ';
              else
                v_orderby := ' order by a.A_HoldNo asc ';
              end if;
        else
          if(p_CloseAlgr = 0) then
            v_orderby := ' order by A_HoldNo ';
        elsif(p_CloseAlgr = 1) then
            v_orderby := ' order by A_HoldNo desc ';
        end if;
      end if;
      v_str := v_str || v_orderby;

          if(p_Quantity = p_orderQty - p_orderTradeQty) then
            --更新委托
            update T_Orders
            set tradeqty=tradeqty + p_Quantity,
                Status=3,UpdateTime=systimestamp(3)
            where A_orderNo = p_A_OrderNo;
          elsif(p_Quantity < p_orderQty - p_orderTradeQty) then
            --更新委托
      if(p_status = 6) then  --状态为部分成交后撤单，如果部分成交回报在撤单回报之后，不用再更新状态了
              update T_Orders
              set tradeqty=tradeqty + p_Quantity,UpdateTime=systimestamp(3)
              where A_orderNo = p_A_OrderNo;
      else
              update T_Orders
              set tradeqty=tradeqty + p_Quantity,Status=2,UpdateTime=systimestamp(3)
              where A_orderNo = p_A_OrderNo;
      end if;
          else
            rollback;
            return -1;
          end if;


        --不指定平仓平持仓记录时以持仓明细表为主，而指定平仓时以当日指定平仓冻结表为主
        if(p_closeMode = 1) then --不指定平仓 -- mod by yukx 20100427
         --遍历持仓明细的数量并过滤掉指定平仓冻结的数量,此平仓没用到b.ID，因为b中没有它，所以用0替换
         v_sql := 'select a_holdno,a_tradeno,price,GageQty,HoldTime,AtClearDate,0 from T_holdposition a ' ||
                  ' where GageQty > 0 and CustomerID=''' || p_CustomerID ||
                  ''' and CommodityID =''' || p_CommodityID || ''' and bs_flag = ' || v_tmp_bs_flag || v_str;
     /*else  --指定平仓 -- mod by yukx 20100427
              v_sql := 'select a.a_holdno,a_tradeno,price,HoldQty,GageQty,HoldTime,AtClearDate,nvl(b.FrozenQty,0),b.ID from T_holdposition a,T_SpecFrozenHold b ' ||
                       ' where (a.HoldQty+a.GageQty) > 0 and b.A_HoldNo=a.A_HoldNo(+) and b.A_OrderNo= ' || p_A_OrderNo || v_str;
        */
      end if;
            open v_T_HoldPosition for v_sql;
            loop
                fetch v_T_HoldPosition into v_a_holdno, v_a_tradeno_closed, v_price,v_GageQty,v_HoldTime,v_AtClearDate,v_id;
                exit when v_T_HoldPosition%NOTFOUND;
                if(p_closeMode = 1) then --不指定平仓
                  if(v_GageQty<=v_unCloseQty) then
                      v_tradedAmount:=v_GageQty;
                  else
                      v_tradedAmount:=v_unCloseQty;
                  end if;
        /*-- mod by yukx 20100427
        else  --指定平仓
                  if(v_frozenQty<=v_unCloseQty) then
                      v_tradedAmount:=v_frozenQty;
                      delete from T_SpecFrozenHold where id=v_id;
                  else
                      v_tradedAmount:=v_unCloseQty;
                      update T_SpecFrozenHold set FrozenQty=FrozenQty-v_tradedAmount where id=v_id;
                  end if;
         */
        end if;

        --判断是平今仓还是平历史仓
          if(trunc(p_TradeDate) = trunc(v_AtClearDate)) then
              v_closeTodayHis := 0;
          else
            v_closeTodayHis := 1;
          end if;


        -- 计算抵顶转让成交后应扣除的手续费
        -- 如果平的是今天开的仓则按今开今平手续费计算
        if(v_TradeType = 3) then  --强平
          v_Fee_one := FN_T_ComputeFeeByArgs(p_bs_flag,v_tradedAmount,p_Price,p_contractFactor,p_ForceCloseFeeAlgr,p_ForceCloseFeeRate_B,p_ForceCloseFeeRate_S);
        else  --其它，如果平的是今天开的仓则按今开今平手续费计算
          if(v_closeTodayHis = 0) then  --平今仓
            v_Fee_one := FN_T_ComputeFeeByArgs(p_bs_flag,v_tradedAmount,p_Price,p_contractFactor,p_feeAlgr,p_TodayCloseFeeRate_B,p_TodayCloseFeeRate_S);
          else  --平历史仓
                v_Fee_one := FN_T_ComputeFeeByArgs(p_bs_flag,v_tradedAmount,p_Price,p_contractFactor,p_feeAlgr,p_HistoryCloseFeeRate_B,p_HistoryCloseFeeRate_S);
            end if;
        end if;
        if(v_Fee_one < 0) then
          Raise_application_error(-20030, 'computeFee error');
        end if;


        --计算应退保证金，根据设置选择开仓价还是昨结算价来算
        if(p_MarginPriceType = 1) then
              v_MarginPrice := p_YesterBalancePrice;
          elsif(p_MarginPriceType = 2) then
          if(v_closeTodayHis = 0) then  --平今仓
            v_MarginPrice := v_price;
          else  --平历史仓
                v_MarginPrice := p_YesterBalancePrice;
            end if;
        else  -- default type is 0
          v_MarginPrice := v_price;
        end if;
        /*-- mod by yukx 20100427
        v_Margin_one := FN_T_ComputeMarginByArgs(v_tmp_bs_flag,v_tradedAmount,v_MarginPrice,p_contractFactor,p_marginAlgr,p_marginRate_b,p_marginRate_s);
                if(v_Margin_one < 0) then
                    Raise_application_error(-20040, 'computeMargin error');
                end if;
            --计算担保金
            v_Assure_one := FN_T_ComputeAssureByArgs(v_tmp_bs_flag,v_tradedAmount,v_MarginPrice,p_contractFactor,p_marginAlgr,p_marginAssure_b,p_marginAssure_s);
            if(v_Assure_one < 0) then
                Raise_application_error(-20040, 'computeAssure error');
            end if;
            --保证金应加上担保金
            v_Margin_one := v_Margin_one + v_Assure_one;

        */
              --计算应退持仓金额
              v_HoldFunds := v_HoldFunds + v_tradedAmount*v_price*p_contractFactor;
                --计算平仓盈亏
                if(v_tmp_bs_flag=1) then  --v_tmp_bs_flag是持仓的买卖标志
                    v_closeFL_one := v_tradedAmount*(p_price-v_price)*p_contractFactor; --税前盈亏
                else
                    v_closeFL_one := v_tradedAmount*(v_price-p_price)*p_contractFactor; --税前盈亏
                end if;
              --计算平仓增值税,v_AddedTaxFactor增值税系数=AddedTax/(1+AddedTax) xief 20150811
              -- v_CloseAddedTax_one := round(v_closeFL_one*p_AddedTaxFactor,2);
                v_CloseAddedTax_one := 0;
                v_closeFL_one := v_closeFL_one - v_CloseAddedTax_one; --税后盈亏

        --调用计算函数修改成交单号 2011-2-15 by feijl
                select FN_T_ComputeTradeNo(SEQ_T_Trade.nextval) into v_A_TradeNo from dual;
                 insert into T_Trade
                  (a_tradeno, m_tradeno, a_orderno, a_tradeno_closed,tradetime, Firmid, CommodityID, bs_flag, ordertype, price, quantity, close_pl, tradefee,TradeType,HoldPrice,HoldTime,CustomerID,CloseAddedTax,M_TradeNo_Opp,AtClearDate,TradeAtClearDate,oppFirmid)
                values
                  (v_A_TradeNo, p_M_TradeNo, p_A_OrderNo, v_a_tradeno_closed, sysdate, p_Firmid, p_CommodityID,p_bs_flag, p_ordertype, p_price, v_tradedAmount, v_closeFL_one, v_Fee_one,v_TradeType,v_price,v_HoldTime,p_CustomerID,v_CloseAddedTax_one,p_M_TradeNo_Opp,v_AtClearDate,p_TradeDate,p_FirmID_opp);

                --更新持仓记录\持仓明细抵顶数量减少
                --去掉退保证金、担保金功能   mod by yukx 20100427
                -- fixed by tangzy 修复抵顶转让的bug
                -- ( "GageQty=GageQty-v_GageQty" -> "GageQty=GageQty-v_tradedAmount" )
                update T_holdposition
                set GageQty=GageQty-v_tradedAmount
                where a_holdno = v_a_holdno;
                v_unCloseQty:=v_unCloseQty - v_tradedAmount;

               /*-- mod by yukx 20100427
                v_Margin:=v_Margin + v_Margin_one;
                v_Assure:=v_Assure + v_Assure_one;
                */
                v_Fee:=v_Fee + v_Fee_one;
                v_closeFL:=v_closeFL + v_closeFL_one;

                exit when v_unCloseQty=0;
            end loop;
            close v_T_HoldPosition;
            if(v_unCloseQty>0) then --成交数量大于持仓数量，出错
                rollback;
                return -3;
            end if;

    --增加生效仓单抵顶表的总数量 -- mod by yukx 20100427
    update T_ValidGageBill set Quantity=Quantity+p_Quantity where FirmID=p_FirmID and CommodityID = p_CommodityID; --(select breedid from t_commodity where CommodityID = p_CommodityID);
    --减少交易客户持仓合计表的抵顶冻结数量  mod by yukx 20100427
    update T_CustomerHoldSum set GageFrozenQty=GageFrozenQty-p_Quantity where CustomerID=p_CustomerID and CommodityID=p_CommodityID and BS_Flag=v_tmp_bs_flag;
    --交易客户持仓合计、交易商持仓合计抵顶数量减少  mod by yukx 20100427
    if(p_GageMode=1) then
        v_firmHoldfunds := v_HoldFunds;
    else
        v_firmHoldfunds := 0;
    end if;
    v_num := FN_T_SubHoldSum(0,p_quantity,0,0,p_CommodityID,p_contractFactor,v_tmp_bs_flag,p_FirmID,v_firmHoldfunds,p_CustomerID,v_HoldFunds,p_GageMode,0);

    --去掉退保证金、担保金功能 -- mod by yukx 20100427
    --更新临时保证金和临时担保金
    /*update T_Firm
    set runtimemargin = runtimemargin - v_Margin,
    RuntimeAssure = RuntimeAssure - v_Assure
    where Firmid = p_FirmID;*/

    --更新冻结资金，释放个人部分的保证金  mod by yukx 20100427
    --v_F_FrozenFunds := FN_F_UpdateFrozenFunds(p_FirmID,-(v_Margin-v_Assure)+v_Fee-v_closeFL,'15');
    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(p_FirmID,v_Fee-v_closeFL,'15');
    return 1;

end;
/

prompt
prompt Creating function FN_T_GAGEQTY
prompt ==============================
prompt
create or replace function FN_T_GageQty(
    --p_ApplyID        number,     --申请单号 modify by yukx 20100421
    p_CommodityID varchar2, --商品代码
    p_BS_Flag        number,    --买卖标志，目前只有卖方
    p_CustomerID     varchar2,     --客户ID
    --p_BillID         varchar2, --仓单号 modify by yukx 20100421
    --p_Modifier       varchar2,   --创建人 modify by yukx 20100421
    p_Quantity       number   --仓单数量
) return number
/****
 * 抵顶
 * 返回值
 * 1 成功
 * 2 已处理过
 * -1  抵顶时超出可抵顶数量
 * -2  抵顶数量大于持仓数量
 * -3  抵顶数量大于可用数量
 * -4  没有对应的生效仓单抵顶记录
 * -100 其它错误
****/
as
	v_version varchar2(10):='1.0.3.1';
    v_CommodityID varchar2(16);
    v_FirmID     varchar2(32);
    v_BS_Flag        number(2);
    v_price          number(15,2);
    v_frozenQty      number(10);
    v_holdQty        number(10);
    v_Margin         number(15,2):=0;   --应收保证金
	v_Assure         number(15,2):=0;   --应收担保金
    v_A_HoldNo       number(15);
    v_HoldSumQty     number(10);
    v_MarginPriceType       number(1);
    v_ContractFactor T_Commodity.ContractFactor%type;
    v_errorcode      number;
    v_errormsg       varchar2(200);
    v_MarginPrice    number(15,2);  --计算成交保证金的价格
	v_HoldFunds    number(15,2):=0;  --平仓时应退持仓金额
    v_unCloseQty     number(10):=p_quantity; --未平数量，用于中间计算
    v_margin_one     number(15,2);   --用于中间计算
	v_Assure_one     number(15,2);   --用于中间计算
    v_tradedAmount   number(10):=0;  --成交数量
	v_CustomerID        varchar2(40);
	v_CloseAlgr           number(2);
	v_orderby  varchar2(100);
	v_F_FrozenFunds   number(15,2);
	type c_HoldPosition is ref cursor;
	v_HoldPosition c_HoldPosition;
	v_sql varchar2(1000);
	v_num            number(10);
	v_FL_ret            timestamp;
	v_AtClearDate          date;
	v_closeTodayHis        number(2);    --平今仓还是历史仓(0平今仓；1平历史仓)
	v_YesterBalancePrice    number(15,2);
	v_TradeDate date;
	v_GageMode number(2);--抵顶模式，分0全抵顶和1半抵顶，半抵顶时要计算浮亏，2009-10-14
  v_AvailableQuantity number(10);--可用数量 add by yukx 20100507
begin
     -- modify by yukx 20100421
	    --select count(*) into v_num from T_ValidBill where BillID = p_BillID and Status=1;
	    --if(v_num >0) then
	    --   rollback;
	    --    return 2;  --已处理过
	    --end if;

      --验证抵顶数量与可用数量 add by yukx 20100507
      --申请时数量已冻结，此时只需验证冻结数量是否满足，原：v_AvailableQuantity=Quantity-FrozenQty  20131211 by jwh
      begin
        select FrozenQty into v_AvailableQuantity from T_ValidGageBill
        where FirmID=(select FirmID from T_Customer where CustomerID=p_CustomerID)
          and commodityID=p_CommodityID;
        exception
          when NO_DATA_FOUND then
  	      return -4;--没有对应的生效仓单抵顶记录
      end;

      if(v_AvailableQuantity<p_Quantity) then
        return -3;--抵顶数量大于可用数量
      end if;

		v_CustomerID := p_CustomerID;
	    v_CommodityID := p_CommodityID;
        v_BS_Flag := p_BS_Flag;
        --获取平仓算法，保证金计算类型,合约因子
        select CloseAlgr,GageMode into v_CloseAlgr,v_GageMode from T_A_Market;
        select MarginPriceType,ContractFactor,LastPrice into v_MarginPriceType,v_ContractFactor,v_YesterBalancePrice from T_Commodity where CommodityID=v_CommodityID;
		select TradeDate into v_TradeDate from T_SystemStatus;

     begin
      select holdqty, frozenqty  into v_HoldSumQty, v_frozenQty from T_CustomerHoldSum
        where CustomerID = v_CustomerID
          and CommodityID = v_CommodityID
          and bs_flag = v_BS_Flag for update;
        exception
        when NO_DATA_FOUND then
  	     return -13;--未查询到对应持仓数量
      end;

      --申请时数量已冻结，此时只需验证冻结数量是否满足，原验证： p_quantity > v_HoldSumQty-v_frozenqty 20131211 by jwh
        if(p_quantity > v_frozenqty) then
            rollback;
            return -1;
        end if;
    	--遍历持仓明细的数量并过滤掉指定平仓冻结的数量
        --根据平仓算法(0先开先平；1后开先平；2持仓均价平仓(不排序)选择排序条件
        if(v_CloseAlgr = 0) then
	        v_orderby := ' order by a.A_HoldNo ';
	    elsif(v_CloseAlgr = 1) then
	        v_orderby := ' order by a.A_HoldNo desc ';
	    end if;


    	v_sql := 'select a.a_holdno,FirmID,price,(a.HoldQty-nvl(b.FrozenQty,0)),a.AtClearDate from T_holdposition a,(select A_HoldNo,nvl(sum(FrozenQty),0) FrozenQty from T_SpecFrozenHold group by A_HoldNo) b ' ||
                 ' where (a.HoldQty+a.GageQty) > 0 and a.A_HoldNo=b.A_HoldNo(+) and nvl(b.FrozenQty,0)<a.HoldQty and CustomerID=''' || v_CustomerID ||
                 ''' and CommodityID =''' || v_CommodityID || ''' and bs_flag = ' || v_BS_Flag || v_orderby;

            open v_HoldPosition for v_sql;
            loop
                fetch v_HoldPosition into v_a_holdno, v_FirmID, v_price, v_holdqty,v_AtClearDate;
                exit when v_HoldPosition%NOTFOUND;
                if(v_holdqty<=v_unCloseQty) then
                    v_tradedAmount:=v_holdqty;
                else
                    v_tradedAmount:=v_unCloseQty;
                end if;

                --计算应退保证金，根据设置选择开仓价还是昨结算价来算
				if(v_MarginPriceType = 1) then
			        v_MarginPrice := v_YesterBalancePrice;
			    elsif(v_MarginPriceType = 2) then
					--判断是平今仓还是平历史仓
				    if(trunc(v_TradeDate) = trunc(v_AtClearDate)) then
				        v_closeTodayHis := 0;
				    else
				    	v_closeTodayHis := 1;
				    end if;
					if(v_closeTodayHis = 0) then  --平今仓
						v_MarginPrice := v_price;
					else  --平历史仓
				        v_MarginPrice := v_YesterBalancePrice;
				    end if;
				else  -- default type is 0
					v_MarginPrice := v_price;
				end if;

                v_Margin_one := FN_T_ComputeMargin(v_FirmID,v_CommodityID,v_BS_Flag,v_tradedAmount,v_MarginPrice);
                if(v_Margin_one < 0) then
                    Raise_application_error(-20040, 'computeMargin error');
                end if;
		        --计算担保金
		        v_Assure_one := FN_T_ComputeAssure(v_FirmID,v_CommodityID,v_BS_Flag,v_tradedAmount,v_MarginPrice);
		        if(v_Assure_one < 0) then
		            Raise_application_error(-20041, 'computeAssure error');
		        end if;
		        --保证金应加上担保金
		        v_Margin_one := v_Margin_one + v_Assure_one;

                v_Margin:=v_Margin + v_Margin_one;
                v_Assure:=v_Assure + v_Assure_one;
	            --计算应退持仓金额
	            v_HoldFunds := v_HoldFunds + v_tradedAmount*v_price*v_ContractFactor;

                --更新持仓记录
		        update T_holdposition
                set holdqty = holdqty - v_tradedAmount,HoldMargin=HoldMargin-v_Margin_one,HoldAssure=HoldAssure-v_Assure_one,GageQty=GageQty+v_tradedAmount
                where a_holdno = v_a_holdno;
                v_unCloseQty:=v_unCloseQty - v_tradedAmount;
                exit when v_unCloseQty=0;
            end loop;
            close v_HoldPosition;
            if(v_unCloseQty>0) then --抵顶数量大于持仓数量，出错
                rollback;
                return -2;
            end if;

        --调用减少交易客户，交易商的持仓合计信息存储，注意参数值与减少持仓不一样   2009-10-15
        if(v_GageMode=1) then
        	v_num := FN_T_SubHoldSum(p_quantity,-p_quantity,v_Margin,v_Assure,v_CommodityID,v_ContractFactor,v_BS_Flag,v_FirmID,0,v_CustomerID,0,v_GageMode,p_quantity);
		else
			v_num := FN_T_SubHoldSum(p_quantity,-p_quantity,v_Margin,v_Assure,v_CommodityID,v_ContractFactor,v_BS_Flag,v_FirmID,v_HoldFunds,v_CustomerID,0,v_GageMode,p_quantity);
		end if;

        --更新保证金和担保金
        update T_Firm
        set runtimemargin = runtimemargin - v_Margin,
            RuntimeAssure = RuntimeAssure - v_Assure
        where Firmid = v_FirmID;
        --更新冻结资金，释放个人部分的保证金
		v_F_FrozenFunds := FN_F_UpdateFrozenFunds(v_FirmID,-(v_Margin-v_Assure),'15');

        --modify by yukx 20100421
        --插入生效仓单表
        --insert into T_ValidBill
        --    (ValidID,               ApplyID, CommodityID,   FirmID_S, CustomerID_S,BillID,  Quantity,  BillType,  Status,CreateTime,Creator)
        --values
        --    (SEQ_T_ValidBill.nextval,p_ApplyID,v_CommodityID, v_FirmID, v_CustomerID,p_BillID,p_Quantity,    1,        1  ,  sysdate,  p_Modifier);
        update T_ValidGageBill set Quantity=Quantity-p_Quantity,FrozenQty=FrozenQty-p_Quantity where FirmID=v_FirmID
               and commodityID=p_CommodityID;

    commit;
    --提交后计算此交易商浮亏
    v_FL_ret := FN_T_UpdateFloatingLoss(null,null,null);

    return 1;
exception
    when OTHERS then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_GageQty',v_errorcode,v_errormsg);
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_T_GAGEQTYCANCEL
prompt ====================================
prompt
create or replace function FN_T_GageQtyCancel(
    --p_ValidID       number,     --生效仓单号 modify by yukx 20100422
    --p_Modifier      varchar2,   --最后修改人 modify by yukx 20100422
    p_customerId      varchar2,   --交易客户代码
    p_commodityId     varchar2,   --商品代码
    p_Quantity        number,     --撤销抵顶数量
	  p_ApplyType     number    --申请种类:2：正常撤销已有抵顶;3：强制撤销已有抵顶
) return number
/****
 * 取消抵顶
 * 返回值
 * 1 成功
 * 2 已处理过
 * -11  取消抵顶时超出抵顶数量
 * -12  取消抵顶数量大于抵顶数量
 * -13  资金余额不足
 * -100 其它错误
****/
as
	v_version varchar2(10):='1.0.2.1';
    --v_CommodityID varchar2(16);  modify by yukx 20100422
    v_FirmID     varchar2(32);
    v_BS_Flag        number(2);
    v_price          number(15,2);
    v_GageQty       number(10);
    v_frozenGageQty number(10);
    v_holdQty        number(10);
    v_Margin         number(15,2):=0;   --应收保证金
	v_Assure         number(15,2):=0;   --应收担保金
    v_A_HoldNo       number(15);
    v_MarginPriceType       number(1);
    v_errorcode      number;
    v_errormsg       varchar2(200);
    v_MarginPrice    number(15,2);  --计算成交保证金的价格
	v_HoldFunds    number(15,2):=0;  --平仓时应退持仓金额
    v_unCloseQty     number(10); --未平数量，用于中间计算
    v_margin_one     number(15,2);   --用于中间计算
	v_Assure_one     number(15,2);   --用于中间计算
    v_tradedAmount   number(10):=0;  --成交数量
	--v_CustomerID        varchar2(16);  modify by yukx 20100422
	v_calFLPrice number(15,2) default 0;        --计算浮亏的价格
	v_ContractFactor T_Commodity.ContractFactor%type;
	v_FloatLoss_one         number(15,2):=0;    --正值表示的浮亏
	v_FloatLoss         number(15,2):=0;        --正值表示的浮亏合计
	v_A_Funds        number(15,2);   --可用资金
	--v_Quantity     number(10); --未平数量，用于中间计算  modify by yukx 20100422
	v_CloseAlgr           number(2);
	v_FloatingLossComputeType number(2);
	v_orderby  varchar2(100);
	v_VirtualFunds   number(15,2);   --虚拟资金
	v_F_FrozenFunds   number(15,2);
	v_MaxOverdraft   number(15,2);   --最大透支额度
	type c_HoldPosition is ref cursor;
	v_HoldPosition c_HoldPosition;
	v_sql varchar2(1000);
	v_num            number(10);
	v_FL_ret            timestamp;
	v_AtClearDate          date;
	v_closeTodayHis        number(2);    --平今仓还是历史仓(0平今仓；1平历史仓)
	v_YesterBalancePrice    number(15,2);
	v_TradeDate date;
	v_FloatingProfitSubTax number(1);
	v_AddedTax number(10,4);
	v_GageMode number(2);--抵顶模式，分0全抵顶和1半抵顶，半抵顶时要计算浮亏，2009-10-14
begin
     -- modify by yukx 20100422
	   -- select count(*) into v_num from T_ValidBill where ValidID = p_ValidID and Status=0;
	   -- if(v_num >0) then
	   --     rollback;
	   --     return 2;  --已处理过
	   -- end if;

    --  modify by yukx 20100422
		--根据生效仓单号查询卖方二级客户ID，商品统一代码，仓单数量
		--select CustomerID_S,CommodityID,Quantity into v_CustomerID,v_CommodityID,v_Quantity from T_ValidBill where ValidID=p_ValidID;
    --v_CustomerID   := p_customerId;
    --v_CommodityID  := p_commodityId;
    --v_Quantity     := p_Quantity;
        --获取平仓算法，保证金计算类型,合约因子
        select CloseAlgr,FloatingLossComputeType,FloatingProfitSubTax,GageMode into v_CloseAlgr,v_FloatingLossComputeType,v_FloatingProfitSubTax,v_GageMode from T_A_Market;
        select MarginPriceType,ContractFactor,LastPrice,AddedTax into v_MarginPriceType,v_ContractFactor,v_YesterBalancePrice,v_AddedTax from T_Commodity where CommodityID=p_commodityId;
		select TradeDate into v_TradeDate from T_SystemStatus;

        v_BS_Flag := 2; --卖抵顶
		v_unCloseQty := p_Quantity;
		--注意锁住持仓
        select GageQty,GageFrozenQty into v_GageQty,v_frozenGageQty
        from T_CustomerHoldSum
        where CustomerID = p_customerId
          and CommodityID = p_commodityId
          and bs_flag = v_BS_Flag for update;

        -- modify by yukx 20100422
        if(p_Quantity > v_GageQty-v_frozenGageQty) then
            rollback;
            return -11;
        end if;
    	--如果计算保证金价不是按开仓价，则在当前行情表中找昨结算价，未找到则找历史中最后一天的结算价
        begin
        	select nvl(Price,0) into v_calFLPrice from T_Quotation where CommodityID=p_commodityId;
        exception
            when NO_DATA_FOUND then
                select nvl(Price,0) into v_calFLPrice from T_H_Quotation where CommodityID=p_commodityId and ClearDate =(select max(ClearDate) from T_H_Quotation where CommodityID=p_commodityId);
        end;
        --找出抵顶数量大于0的持仓
        --取消抵顶时与抵顶时顺序相反
        --根据平仓算法(0先开先平；1后开先平；2持仓均价平仓(不排序)选择排序条件
        if(v_CloseAlgr = 0) then
	        v_orderby := ' order by A_HoldNo desc ';
	    elsif(v_CloseAlgr = 1) then
	        v_orderby := ' order by A_HoldNo ';
	    end if;
    	v_sql := 'select a_holdno,FirmID,price,GageQty,AtClearDate from T_holdposition ' ||
                 ' where GageQty>0 and CustomerID=''' || p_customerId ||
                 ''' and CommodityID =''' || p_commodityId || ''' and bs_flag = ' || v_BS_Flag || v_orderby;

            open v_HoldPosition for v_sql;
            loop
                fetch v_HoldPosition into v_a_holdno, v_FirmID, v_price, v_holdqty,v_AtClearDate;
                exit when v_HoldPosition%NOTFOUND;
                if(v_holdqty<=v_unCloseQty) then
                    v_tradedAmount:=v_holdqty;
                else
                    v_tradedAmount:=v_unCloseQty;
                end if;

                --计算应收保证金，根据设置选择开仓价还是昨结算价来算
				if(v_MarginPriceType = 1) then
			        v_MarginPrice := v_YesterBalancePrice;
			    elsif(v_MarginPriceType = 2) then
					--判断是平今仓还是平历史仓
				    if(trunc(v_TradeDate) = trunc(v_AtClearDate)) then
				        v_closeTodayHis := 0;
				    else
				    	v_closeTodayHis := 1;
				    end if;
					if(v_closeTodayHis = 0) then  --平今仓
						v_MarginPrice := v_price;
					else  --平历史仓
				        v_MarginPrice := v_YesterBalancePrice;
				    end if;
				else  -- default type is 0
					v_MarginPrice := v_price;
				end if;
                v_Margin_one := FN_T_ComputeMargin(v_FirmID,p_commodityId,v_BS_Flag,v_tradedAmount,v_MarginPrice);
                if(v_Margin_one < 0) then
                    Raise_application_error(-20040, 'computeMargin error');
                end if;
		        --计算担保金
		        v_Assure_one := FN_T_ComputeAssure(v_FirmID,p_commodityId,v_BS_Flag,v_tradedAmount,v_MarginPrice);
		        if(v_Assure_one < 0) then
		            Raise_application_error(-20041, 'computeAssure error');
		        end if;
		        --保证金应加上担保金
		        v_Margin_one := v_Margin_one + v_Assure_one;
		        --计算浮亏，根据参数是否扣税
				v_FloatLoss_one := FN_T_ComputeFPSubTax(v_Price,v_calFLPrice,v_tradedAmount,v_ContractFactor,v_BS_Flag,v_AddedTax,v_FloatingProfitSubTax);
				if(v_FloatingLossComputeType = 3 or v_FloatingLossComputeType = 4) then  --盘中算盈亏或不算盈亏
					--v_FloatLoss_one := -FN_T_ComputeFloatingProfit(v_Price,v_calFLPrice,v_tradedAmount,v_ContractFactor,v_BS_Flag); --盈亏并取反
					v_FloatLoss_one := -v_FloatLoss_one;
				else
		        	--v_FloatLoss_one := FN_T_ComputeFloatingLoss(v_Price,v_calFLPrice,v_tradedAmount,v_ContractFactor,v_BS_Flag); --浮亏
					if(v_FloatLoss_one > 0) then
						v_FloatLoss_one := 0;
					else
						v_FloatLoss_one := -v_FloatLoss_one;
					end if;
		        end if;
                v_Margin:=v_Margin + v_Margin_one;
                v_Assure:=v_Assure + v_Assure_one;
                v_FloatLoss := v_FloatLoss + v_FloatLoss_one;
	            --计算应退持仓金额
	            v_HoldFunds := v_HoldFunds + v_tradedAmount*v_price*v_ContractFactor;

                --更新持仓记录
		        update T_holdposition
                set holdqty = holdqty + v_tradedAmount,HoldMargin=HoldMargin+v_Margin_one,HoldAssure=HoldAssure+v_Assure_one,GageQty=GageQty-v_tradedAmount
                where a_holdno = v_a_holdno;

                v_unCloseQty:=v_unCloseQty - v_tradedAmount;
                exit when v_unCloseQty=0;
            end loop;
            close v_HoldPosition;
            if(v_unCloseQty>0) then --取消抵顶数量大于抵顶数量，出错
                rollback;
                return -12;
            end if;
            --根据申请种类:2：正常撤销已有抵顶;3：强制撤销已有抵顶，来判断金额是否足够释放此抵顶，如果是3不需要此判断
			if(p_ApplyType = 2) then
				select VirtualFunds,MaxOverdraft into v_VirtualFunds,v_MaxOverdraft from T_Firm where FirmID = v_FirmID;
		        --计算可用资金
		        v_A_Funds := FN_F_GetRealFunds(v_FirmID,0) + v_VirtualFunds + v_MaxOverdraft;
		        --如果是半抵顶则不释放浮亏2009-10-15
		        if(v_GageMode=1) then
		        	v_FloatLoss := 0;
				end if;
		        if(v_A_Funds < v_Margin-v_Assure + v_FloatLoss) then
		            rollback;
		            return -13;  --资金余额不足
		        end if;
	        end if;

        --调用减少交易客户，交易商的持仓合计信息存储，注意参数值与减少持仓不一样   2009-10-15
        if(v_GageMode=1) then
        	v_num := FN_T_SubHoldSum(-p_Quantity,p_Quantity,-v_Margin,-v_Assure,p_commodityId,v_ContractFactor,v_BS_Flag,v_FirmID,0,p_customerId,0,v_GageMode,0);
		else
			v_num := FN_T_SubHoldSum(-p_Quantity,p_Quantity,-v_Margin,-v_Assure,p_commodityId,v_ContractFactor,v_BS_Flag,v_FirmID,-v_HoldFunds,p_customerId,0,v_GageMode,0);
		end if;

        --更新保证金和担保金
        update T_Firm
        set runtimemargin = runtimemargin + v_Margin,
            RuntimeAssure = RuntimeAssure + v_Assure
        where Firmid = v_FirmID;
        --更新冻结资金，扣除个人部分的保证金
        v_F_FrozenFunds := FN_F_UpdateFrozenFunds(v_FirmID,v_Margin-v_Assure,'15');

        --modify by tangzy 20100729 增加where条件
        --modify by yukx 20100422 新增抵顶转让后部更新生效仓单表 直接增加生效抵顶仓单表的数量
        --更新生效仓单表的状态为已撤消
        --update T_ValidBill set Status=0,ModifyTime=sysdate,Modifier=p_Modifier where ValidID=p_ValidID;
        update T_ValidGageBill set Quantity = Quantity+p_Quantity
        where FirmID=v_FirmID and commodityID= p_CommodityID;
    commit;
    --提交后计算此交易商浮亏
    v_FL_ret := FN_T_UpdateFloatingLoss(null,null,null);

    return 1;
exception
    when OTHERS then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_GageQtyCancel',v_errorcode,v_errormsg);
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_T_GETHOLDDEADLINE
prompt ======================================
prompt
create or replace function FN_T_GETHOLDDEADLINE(p_begindate   date,
                                                p_commodityid varchar2)
/**
  * 获取持仓的到期日期
  */
 return date is
  v_date        date;
  v_cnt1        number;
  v_maxHoldDays number;

begin

  select c.maxholdpositionday
    into v_maxHoldDays
    from t_commodity c
   where c.commodityid = p_commodityid;
  if (v_maxHoldDays = 0) then   --如果持仓天数设置为0，则直接返回持仓日期
    return p_begindate;
  end if;

  select count(cleardate)
    into v_cnt1
    from t_h_market
   where cleardate >= p_begindate;

  if (v_maxHoldDays - v_cnt1 > 0) then    --未过期持仓
    select max(day)
      into v_date
      from (select *
              from (select day from t_tradedays order by day)
             where rownum <= v_maxHoldDays - v_cnt1);
  elsif (v_maxHoldDays - v_cnt1 <= 0) then   --过期持仓
    select max(cleardate)
      into v_date
      from (select *
              from (select cleardate
                      from t_h_market
                     where cleardate >= p_begindate
                     order by cleardate)
             where rownum <= v_maxHoldDays);
  end if;
  return v_date;
end;
/

prompt
prompt Creating function FN_T_UPDATEHOLDDAYS
prompt =====================================
prompt
create or replace function FN_T_UPDATEHOLDDAYS(p_commodityid varchar2)
/**
  * 更新指定商品的所有持仓的到期日期、到期天数
  */
 return number is
  v_date       date;
  v_deadline   date;
  v_remaindays number;
  v_ret        number;
begin

  for days in (select atcleardate
                 from t_holdposition
                where commodityid = p_commodityid
                group by atcleardate) loop
    --计算到期日期
    v_deadline := FN_T_GETHOLDDEADLINE(days.atcleardate, p_commodityid);
    --计算到期天数
    select count(*)
      into v_remaindays
      from t_tradedays
     where day <= v_deadline;
    --更新所有符合该条件的持仓
    update t_holdposition t
       set t.deadline = v_deadline, t.remainday = v_remaindays
     where t.atcleardate = days.atcleardate
       and commodityid = p_commodityid;

  end loop;
  return(0);
end;
/

prompt
prompt Creating procedure SP_F_STATUSINIT
prompt ==================================
prompt
create or replace procedure SP_F_StatusInit
as
/*********************
 检查财务结算状态存储
 存储说明：凡是进行初始化的系统
 需先调用本存储，对财务系统进行初始化

**********************/
v_status F_systemstatus.Status%type;
begin
  --1.检查财务系统交易状态
  begin
     select status into v_status  from F_systemstatus t where rownum < 2;
  exception
     when NO_DATA_FOUND then
       return;
  end;
  --2.如果状态不为结算完成状态，即返回
  if(v_status <> 2) then
    return;
  end if;

  --3.如果状态为结算完成，即修改状态为未结算
  update F_systemstatus set status = 0,note = '未结算';
  update F_CLEARSTATUS set status = 'N',finishtime = null;
end;
/

prompt
prompt Creating function FN_T_INITTRADE
prompt ================================
prompt
CREATE OR REPLACE FUNCTION FN_T_InitTrade
(
    p_ClearDate Date  --结算日期
)
RETURN NUMBER
/****
 * 初始化交易系统
 * 返回值 1 成功;-100 其它错误
****/
as
	v_version varchar2(10):='1.0.2.2';
	v_CommodityID varchar2(16);
	v_Price         number(15,2);
	v_ReserveCount   number(10);
	v_num            number(10);
        v_ret            number(10);
	v_quotationTwoSide  number(10);
    v_errorcode number;
    v_errormsg  varchar2(200);
    --当日行情游标,用来更新商品的昨结算价
    cursor cur_T_Quotation is select CommodityID,Price from T_Quotation;
    --商品交收游标
    cursor cur_T_Commodity is
        select CommodityID
        from T_Commodity
        where SettleDate<trunc(p_ClearDate);
begin
    --1、利用游标更新交收商品，只有交收日期小于当天日期并且持仓表中没有此商品的持仓，则可以从商品表中删除此商品
  	open cur_T_Commodity;
    loop
    	fetch cur_T_Commodity into v_CommodityID;
    	exit when cur_T_Commodity%notfound;
        select count(*) into v_num from T_FirmHoldSum where CommodityID = v_CommodityID and (HoldQty+GageQty)>0;
        if(v_num <= 0) then
		    delete from T_Commodity where CommodityID=v_CommodityID;
		    --2009-11-27 增加删除特殊设置的表
		    delete from T_A_FirmMargin where CommodityID=v_CommodityID;
		    delete from T_A_FirmFee where CommodityID=v_CommodityID;
		    delete from T_A_FirmMaxHoldQty where CommodityID=v_CommodityID;
        else
           update T_Commodity set status=1 where CommodityID=v_CommodityID;
        end if;
 	end loop;
    close cur_T_Commodity;
    --2、删除交易客户持仓明细表的持仓数量和抵顶数量都等于0的记录
    delete from T_HoldPosition where HoldQty=0 and GageQty=0;
    --3、删除交易客户持仓合计表的持仓数量和抵顶数量都等于0的记录
    delete from T_CustomerHoldSum where HoldQty=0 and GageQty=0;
    --4、删除交易商持仓合计表的持仓数量和抵顶数量都等于0的记录
    delete from T_FirmHoldSum where HoldQty=0 and GageQty=0;
    --5、利用游标更新商品昨结算价和订货量，by cxc 2009-08-17订货量改在从持仓量上汇总，这里只更新昨结算价
  	open cur_T_Quotation;
    loop
    	fetch cur_T_Quotation into v_CommodityID,v_Price;
    	exit when cur_T_Quotation%notfound;
    	update T_Commodity set LastPrice=v_Price where CommodityID=v_CommodityID;
 	end loop;
    close cur_T_Quotation;
    --6、更新商品上的订货量，且是双边的， 重新和持仓上的对一次，保证每天都正确，因为协议平仓，提前交收中没有更新行情上的订货量
    --add 2010-09-07 增加行情单双边判断
	select quotationTwoSide into v_quotationTwoSide from T_A_MARKET;
	update T_Commodity a
    set ReserveCount =
    nvl((
          select decode(v_quotationTwoSide,2,sum(HoldQty+GageQty),sum(HoldQty+GageQty)/2)
      	  from T_FirmHoldSum
      	  where CommodityID=a.CommodityID
          group by CommodityID
    ),0);
    --7、清空当日行情表
    delete from T_Quotation;
    --8、根据商品插入初始行情
    insert into T_Quotation(CommodityID,Price,YesterBalancePrice,ReserveCount,CreateTime)
                 select     CommodityID,LastPrice,LastPrice,      ReserveCount,sysdate
                 from T_Commodity where Status<>1;
    --8.5 更新行情的昨收盘价
    update T_Quotation a
    set (ClosePrice) =nvl(
    (
      select nvl(CurPrice,0)
      from T_H_Quotation
      where ClearDate =(select max(ClearDate) from T_H_Quotation) and CommodityID=a.CommodityID
    ),0);

    --9、清空当日延期行情表
    delete from T_DelayQuotation;
    --10、根据商品插入初始延期行情
    insert into T_DelayQuotation(CommodityID,BuySettleQty,SellSettleQty,BuyNeutralQty,SellNeutralQty,CreateTime,NeutralSide)
                 select          CommodityID,       0,           0,            0,             0,       sysdate ,     0
                 from T_Commodity where Status<>1 and SettleWay=1;

    --11、初始化当日最小序号表  2011-2-15 by feijl
    select count(*) into v_num from T_CurMinNo where TradeDate = TO_NUMBER(TO_CHAR(p_ClearDate,'yyMMdd'));
    if(v_num <= 0) then
		update T_CurMinNo set TradeDate = TO_NUMBER(TO_CHAR(p_ClearDate,'yyMMdd')),A_OrderNo=SEQ_T_Orders.nextval,A_TradeNo=SEQ_T_Trade.nextval,A_HoldNo=SEQ_T_HoldPosition.nextval;
    end if;
    --调用财务系统初始化存储 liuchao 20130411
    SP_F_StatusInit();

    --更新持仓的到期日期 add by zhaodc 2013-12-25
    select count(*) into v_ret from  t_commodity c where c.maxholdpositionday is not null;
    if ( v_ret > 0) then
      v_ret := fn_t_addTradeDays();
      for cmd in (select commodityid from t_commodity c where c.maxholdpositionday is not null)
      loop
        v_ret := fn_t_updateholddays(cmd.commodityid);
      end loop;
    end if;
    --将没有设置最大持仓天数（也叫做：到期日期）的订货明细的到期日期和到期天数清空
    update t_holdposition
       set deadline = null,remainday=null
     where commodityid in ( select commodityid from t_commodity where maxholdpositionday is null );

    commit;
    return 1;
exception
    when OTHERS then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_InitTrade',v_errorcode,v_errormsg);
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_T_OPENORDER
prompt ================================
prompt
create or replace function FN_T_OpenOrder(
    p_FirmID     varchar2,  --交易商ID
    p_TraderID       varchar2,  --交易员ID
    p_CommodityID varchar2,
    p_bs_flag        number,
    p_price          number,
    p_quantity       number,
    p_Margin     number,     --委托应收保证金
    p_Fee   number,   --委托应收手续费
    p_CustomerID     varchar2,  --交易客户ID
    p_ConsignerID       varchar2,  --委托员ID
    p_specialOrderFlag       number  --是否特殊委托(0：正常委托 1：特殊委托) 特殊委托只能和特殊委托成交
) return number
/****
 * 开仓委托
 * 返回值
 * >0  成功提交，并返回委托单号
 * -1  资金余额不足
 * -2  超过交易商对此商品的最大订货量
 * -3  超过交易商总的最大订货量
 * -4  超过品种最大订货量
 * -5  超过商品最大订货量
 * -6  超过交易商对此商品的最大净订货量
 * -7  超过单笔最大委托量（改在java中判断）2009-09-18
 * -99  不存在相关数据
 * -100 其它错误
****/
as
    v_version varchar2(10):='1.0.0.9';
    v_F_Funds        number(15,2):=0;   --应冻结资金
    v_VirtualFunds   number(15,2);   --虚拟资金
    v_A_Funds        number(15,2);   --可用资金
    v_HoldSum        number(15,0);   --持仓合计
    v_HoldSum_b        number(15,0);   --持仓合计b
    v_HoldSum_s        number(15,0);   --持仓合计s
    v_A_OrderNo      number(15,0);   --委托号
    v_NotTradeSum    number(15,0);   --开仓未成交合计
    v_NotTradeSum_b    number(15,0);   --开仓未成交合计b
    v_NotTradeSum_s    number(15,0);   --开仓未成交合计s
    v_BreedID      number(10,0);
    v_LimitBreedQty      number(10,0);
    v_LimitCmdtyQty      number(10,0);
    v_FirmCleanQty      number(10,0);
    v_FirmMaxHoldQty      number(10,0);
    v_MaxHoldQty      number(10,0); --交易商最大订货量
    v_MaxOverdraft        number(15,2):=0;   --最大透支额度
    v_F_FrozenFunds   number(15,2);   --冻结资金
    v_errorcode number;
    v_errormsg  varchar2(200);
begin
        --应冻结资金
        v_F_Funds := p_Margin + p_Fee;
        --获得虚拟资金
        select VirtualFunds,MaxHoldQty,MaxOverdraft into v_VirtualFunds,v_MaxHoldQty,v_MaxOverdraft from T_Firm where FirmID = p_FirmID;
        --计算可用资金，并锁住财务资金
        v_A_Funds := FN_F_GetRealFunds(p_FirmID,1) + v_VirtualFunds + v_MaxOverdraft;
        if(v_A_Funds < v_F_Funds) then
            rollback;
            return -1;  --资金余额不足
        else
            --1、验证是否超过交易商总的最大持仓量
            if(v_MaxHoldQty <> -1) then
                select nvl(sum(Quantity-TradeQty),0) into v_NotTradeSum
                from T_Orders
                where FirmID = p_FirmID
                and OrderType=1 and Status in(1,2);

                select nvl(sum(holdqty+GageQty),0) into v_HoldSum
                from T_FirmHoldSum
                where FirmID = p_FirmID;

                if(v_HoldSum + v_NotTradeSum + p_quantity > v_MaxHoldQty) then
                    rollback;
                    return -3;  --超过总的最大持仓量
                end if;
            end if;
            --在品种和商品属性中获取品种最大订货量，商品最大订货量，交易商最大净订货量，交易商最大订货量
            select a.BreedID,a.LimitBreedQty,b.LimitCmdtyQty,b.FirmCleanQty,b.FirmMaxHoldQty into v_BreedID,v_LimitBreedQty,v_LimitCmdtyQty,v_FirmCleanQty,v_FirmMaxHoldQty
            from T_A_Breed a,T_Commodity b
            where a.BreedID=b.BreedID and b.CommodityID=p_CommodityID;
            --获取交易商特殊订货量
            begin
                select CleanMaxHoldQty,MaxHoldQty
                into v_FirmCleanQty,v_FirmMaxHoldQty
                from T_A_FirmMaxHoldQty
                where FirmID=p_FirmID and CommodityID=p_CommodityID;
            exception
                when NO_DATA_FOUND then
                    null;
            end;
            --2、验证是否超过品种最大订货量
            if(v_LimitBreedQty <> -1) then
                select nvl(sum(a.Quantity-a.TradeQty),0) into v_NotTradeSum
                from T_Orders a,T_Commodity b
                where a.CommodityID=b.CommodityID and b.BreedID=v_BreedID
                and a.OrderType=1 and a.BS_Flag=p_bs_flag and a.Status in(1,2);

                select nvl(sum(a.holdqty+a.GageQty),0) into v_HoldSum
                from T_FirmHoldSum a,T_Commodity b
                where a.CommodityID=b.CommodityID and b.BreedID=v_BreedID and a.BS_Flag=p_bs_flag;
                if(v_HoldSum + v_NotTradeSum + p_quantity > v_LimitBreedQty) then
                    rollback;
                    return -4;  --超过品种最大订货量
                end if;
            end if;
            --3、验证是否超过商品最大订货量
            if(v_LimitCmdtyQty <> -1) then
                select nvl(sum(Quantity-TradeQty),0) into v_NotTradeSum
                from T_Orders
                where CommodityID=p_CommodityID
                and OrderType=1 and BS_Flag=p_bs_flag and Status in(1,2);

                select nvl(sum(holdqty+GageQty),0) into v_HoldSum
                from T_FirmHoldSum
                where CommodityID=p_CommodityID and BS_Flag=p_bs_flag;
                if(v_HoldSum + v_NotTradeSum + p_quantity > v_LimitCmdtyQty) then
                    rollback;
                    return -5;  --超过商品最大订货量
                end if;
            end if;
            --4、验证是否超过交易商对此商品的最大订货量
            if(v_FirmMaxHoldQty <> -1) then
                select nvl(sum(Quantity-TradeQty),0) into v_NotTradeSum
                from T_Orders
                where FirmID = p_FirmID and CommodityID=p_CommodityID
                and OrderType=1 and Status in(1,2);

                select nvl(sum(holdqty+GageQty),0) into v_HoldSum
                from T_FirmHoldSum
                where FirmID = p_FirmID and CommodityID=p_CommodityID;

                if(v_HoldSum + v_NotTradeSum + p_quantity > v_FirmMaxHoldQty) then
                    rollback;
                    return -2;  --超过交易商对此商品的最大订货量
                end if;
            end if;
            --5、验证是否超过交易商对此商品的最大净订货量
            if(v_FirmCleanQty <> -1) then
                select nvl(sum(holdqty+GageQty),0) into v_HoldSum_b
                from T_FirmHoldSum
                where FirmID = p_FirmID and CommodityID=p_CommodityID and BS_Flag=1;
                select nvl(sum(holdqty+GageQty),0) into v_HoldSum_s
                from T_FirmHoldSum
                where FirmID = p_FirmID and CommodityID=p_CommodityID and BS_Flag=2;
                if(p_bs_flag = 1) then
                    select nvl(sum(Quantity-TradeQty),0) into v_NotTradeSum_b
                    from T_Orders
                    where FirmID = p_FirmID and CommodityID=p_CommodityID and BS_Flag=1
                    and OrderType=1 and Status in(1,2);
                    if(v_HoldSum_b + v_NotTradeSum_b + p_quantity - v_HoldSum_s > v_FirmCleanQty) then
                        rollback;
                        return -6;  --超过交易商对此商品的最大净订货量
                    end if;
                else
                    select nvl(sum(Quantity-TradeQty),0) into v_NotTradeSum_s
                    from T_Orders
                    where FirmID = p_FirmID and CommodityID=p_CommodityID and BS_Flag=2
                    and OrderType=1 and Status in(1,2);
                    if(v_HoldSum_s + v_NotTradeSum_s + p_quantity - v_HoldSum_b > v_FirmCleanQty) then
                        rollback;
                        return -6;  --超过交易商对此商品的最大净订货量
                    end if;
                end if;
            end if;

        end if;

        --更新冻结资金
        v_F_FrozenFunds := FN_F_UpdateFrozenFunds(p_FirmID,v_F_Funds,'15');
        --插入委托表，并返回委托单号
		--调用计算函数修改委托单号 2011-2-15 by feijl
        select FN_T_ComputeOrderNo(SEQ_T_Orders.nextval) into v_A_OrderNo from dual;
        insert into T_Orders
          (a_orderno,a_orderno_w, CommodityID, Firmid, traderid,    bs_flag, ordertype, status, quantity, price, closemode, specprice, timeflag, tradeqty, frozenfunds, unfrozenfunds, ordertime, withdrawtime, ordererip, signature, CustomerID,ConsignerID,specialOrderFlag)
        values
          (v_A_OrderNo,  null, p_CommodityID, p_Firmid, p_traderid, p_bs_flag,    1 ,      1, p_quantity, p_price, null,     null,      null,    0,         v_F_Funds,     0,           sysdate,      null,        null,     null,p_CustomerID,p_ConsignerID,p_specialOrderFlag);
        commit;
        return v_A_OrderNo;
exception
    when NO_DATA_FOUND then
        rollback;
        return -99;  --不存在相关数据
    when others then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_OpenOrder',v_errorcode,v_errormsg);
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_T_OPENTRADE
prompt ================================
prompt
create or replace function FN_T_OpenTrade(
    p_A_OrderNo     number,  --委托单号
    p_M_TradeNo     number,  --撮合成交号
    p_Price         number,  --成交价
    p_Quantity      number,   --成交数量
    p_M_TradeNo_Opp     number,  --对方撮合成交号
    p_CommodityID varchar2,
    p_FirmID     varchar2,
    p_TraderID       varchar2,
    p_bs_flag        number,
    p_status         number,
    p_orderQty       number,--委托数量
    p_orderPrice          number,--委托价格
    p_orderTradeQty       number,--委托已成交数量
    p_frozenfunds    number,
    p_unfrozenfunds  number,
    p_CustomerID        varchar2,
    p_OrderType      number,
    p_contractFactor number,
    p_MarginPriceType         number,     --计算成交保证金结算价类型 0:实时和闭市时都按开仓价；1:实时按昨结算价，闭市按当日结算价；2:盘中按订立价，闭市结算时按当日结算价；
    p_marginAlgr         number,
    p_marginRate_b         number,
    p_marginRate_s         number,
    p_marginAssure_b         number,
    p_marginAssure_s         number,
    p_feeAlgr       number,
    p_feeRate_b         number,
    p_feeRate_s         number,
    p_YesterBalancePrice    number,
    p_GageMode    number,
    p_TradeDate date,
    p_FirmID_opp     varchar2
) return number
/****
 * 开仓成交回报
 * 1、注意不要提交commit，因为别的函数要调用它；
 * 返回值
 * 1 成功
 * -1 成交数量大于未成交数量
 * -100 其它错误
****/
as
    v_version varchar2(10):='1.0.2.2';
    v_num            number(10);
    v_to_unfrozenF   number(15,2):=0;
    v_Margin         number(15,2):=0;   --应收保证金
    v_Assure         number(15,2):=0;   --应收担保金
    v_Fee            number(15,2):=0;   --应收费用
    v_frozenMargin   number(15,2);   --应收保证金
    v_frozenFee      number(15,2);   --应收费用
    v_A_TradeNo      number(15);
    v_A_HoldNo       number(15);
    v_MarginPrice    number(15,2);  --计算成交保证金的价格
    v_unfrozenPrice    number(15,2);  --计算释放冻结保证金，手续费的价格
    v_TradeType      number(1);
    v_F_FrozenFunds   number(15,2);
begin
      --计算保证金价格
	  if(p_MarginPriceType = 1) then
	      v_MarginPrice := p_YesterBalancePrice;
	  else  -- default type is 0
		  v_MarginPrice := p_Price;
	  end if;
      if(p_TraderID is not null) then
          v_TradeType := 1;  --有交易员的表示正常交易（开，平仓）
      else
          v_TradeType := 4;  --交易员为空为委托交易（开，平仓）
      end if;

        if(p_Quantity = p_orderQty - p_orderTradeQty) then
            v_to_unfrozenF := p_frozenfunds - p_unfrozenfunds;
            --更新委托
            update T_Orders
            set unfrozenfunds=unfrozenfunds + v_to_unfrozenF,
                tradeqty=tradeqty + p_Quantity,
                Status=3,UpdateTime=systimestamp(3)
            where A_orderNo = p_A_OrderNo;
        elsif(p_Quantity < p_orderQty - p_orderTradeQty) then
		    if(p_MarginPriceType = 1) then
		        v_unfrozenPrice := p_YesterBalancePrice;
		    else  -- default type is 0
			    v_unfrozenPrice := p_orderPrice;
		    end if;
            v_frozenMargin := FN_T_ComputeMarginByArgs(p_bs_flag,p_Quantity,v_unfrozenPrice,p_contractFactor,p_marginAlgr,p_marginRate_b,p_marginRate_s);
            if(v_frozenMargin < 0) then
                Raise_application_error(-20040, 'computeMargin error');
            end if;
            v_frozenFee := FN_T_ComputeFeeByArgs(p_bs_flag,p_Quantity,p_orderPrice,p_contractFactor,p_feeAlgr,p_feeRate_b,p_feeRate_s);
            if(v_frozenFee < 0) then
                Raise_application_error(-20030, 'computeFee error');
            end if;
            v_to_unfrozenF := v_frozenMargin + v_frozenFee;
            --更新委托
			if(p_status = 6) then  --状态为部分成交后撤单，如果部分成交回报在撤单回报之后，不用再更新状态了
	            update T_Orders
	            set unfrozenfunds=unfrozenfunds + v_to_unfrozenF,
	                tradeqty=tradeqty + p_Quantity,UpdateTime=systimestamp(3)
	            where A_orderNo = p_A_OrderNo;
			else
	            update T_Orders
	            set unfrozenfunds=unfrozenfunds + v_to_unfrozenF,
	                tradeqty=tradeqty + p_Quantity,Status=2,UpdateTime=systimestamp(3)
	            where A_orderNo = p_A_OrderNo;
			end if;
        else
            rollback;
            return -1;
        end if;
        --计算成交后应扣除的手续费
        v_Fee := FN_T_ComputeFeeByArgs(p_bs_flag,p_Quantity,p_Price,p_contractFactor,p_feeAlgr,p_feeRate_b,p_feeRate_s);
        if(v_Fee < 0) then
          Raise_application_error(-20030, 'computeFee error');
        end if;
        --插入成交记录
		--调用计算函数修改成交单号 2011-2-15 by feijl
        select FN_T_ComputeTradeNo(SEQ_T_Trade.nextval) into v_A_TradeNo from dual;
        insert into T_Trade
          (a_tradeno,    m_tradeno, a_orderno,   tradetime, Firmid, CommodityID,   bs_flag,    ordertype,     price, quantity, close_pl, tradefee,TradeType,CustomerID,M_TradeNo_Opp,TradeAtClearDate,oppFirmID)
        values
          (v_A_TradeNo, p_M_TradeNo, p_A_OrderNo, sysdate, p_FirmID, p_CommodityID,p_bs_flag, p_OrderType,   p_price, p_quantity, 0,       v_Fee,v_TradeType,p_CustomerID,p_M_TradeNo_Opp,p_TradeDate,p_FirmID_opp);


		--计算保证金
        v_Margin := FN_T_ComputeMarginByArgs(p_bs_flag,p_Quantity,v_MarginPrice,p_contractFactor,p_marginAlgr,p_marginRate_b,p_marginRate_s);
        if(v_Margin < 0) then
            Raise_application_error(-20040, 'computeMargin error');
        end if;
        --计算担保金
        v_Assure := FN_T_ComputeAssureByArgs(p_bs_flag,p_Quantity,v_MarginPrice,p_contractFactor,p_marginAlgr,p_marginAssure_b,p_marginAssure_s);
        if(v_Assure < 0) then
            Raise_application_error(-20041, 'computeAssure error');
        end if;
        --保证金应加上担保金
        v_Margin := v_Margin + v_Assure;

        --插入持仓明细表
		--调用计算函数修改持仓单号 2011-2-15 by feijl
        select FN_T_ComputeHoldNo(SEQ_T_HoldPosition.nextval) into v_A_HoldNo from dual;
        insert into T_Holdposition
          (a_holdno,    a_tradeno,  CommodityID,    CustomerID , bs_flag,   price,    holdqty,    openqty, holdtime,HoldMargin,HoldAssure,Firmid,FloatingLoss,AtClearDate)
        values
          (v_A_HoldNo, v_A_TradeNo, p_CommodityID, p_CustomerID, p_bs_flag, p_price, p_quantity,p_quantity, sysdate,v_Margin,v_Assure,    p_FirmID,   0,      p_TradeDate);

        --更新交易客户持仓合计表
        select count(*) into v_num from T_CustomerHoldSum
        where CustomerID = p_CustomerID
          and CommodityID = p_CommodityID
          and bs_flag = p_bs_flag;
        if(v_num >0) then
            update T_CustomerHoldSum
            set holdQty = holdQty + p_Quantity,
            holdFunds = holdFunds + p_Price*p_Quantity*p_contractFactor,
            HoldMargin = HoldMargin + v_Margin,
            HoldAssure = HoldAssure + v_Assure,
            evenprice = (holdFunds + p_Price*p_Quantity*p_contractFactor)/((holdQty + GageQty + p_Quantity)*p_contractFactor)
            where CustomerID = p_CustomerID
            and CommodityID = p_CommodityID
            and bs_flag = p_bs_flag;
        else
          insert into T_CustomerHoldSum
            (CustomerID, CommodityID, bs_flag, holdQty, holdFunds,FloatingLoss, evenprice,FrozenQty,HoldMargin,HoldAssure,FirmID)
          values
            (p_CustomerID, p_CommodityID, p_bs_flag, p_Quantity, p_Price*p_Quantity*p_contractFactor,0, p_Price,0,v_Margin,v_Assure,p_FirmID);
        end if;

        --更新交易商持仓合计表
        select count(*) into v_num from T_FirmHoldSum
        where Firmid = p_FirmID
          and CommodityID = p_CommodityID
          and bs_flag = p_bs_flag;
        if(v_num >0) then
            update T_FirmHoldSum
            set holdQty = holdQty + p_Quantity,
            holdFunds = holdFunds + p_Price*p_Quantity*p_contractFactor,
            HoldMargin = HoldMargin + v_Margin,
            HoldAssure = HoldAssure + v_Assure,
            evenprice = (holdFunds + p_Price*p_Quantity*p_contractFactor)/((holdQty + p_Quantity + decode(p_GageMode,1,GageQty,0))*p_contractFactor)
            where Firmid = p_FirmID
            and CommodityID = p_CommodityID
            and bs_flag = p_bs_flag;
        else
          insert into T_FirmHoldSum
            (FirmID, CommodityID,      bs_flag,  holdQty,        holdFunds,FloatingLoss, evenprice,HoldMargin,HoldAssure)
          values
            (p_FirmID, p_CommodityID, p_bs_flag, p_Quantity, p_Price*p_Quantity*p_contractFactor,0,         p_Price, v_Margin,  v_Assure);
        end if;

        --更新临时保证金和临时担保金
        update T_Firm
        set runtimemargin = runtimemargin + v_Margin,
            RuntimeAssure = RuntimeAssure + v_Assure
        where Firmid = p_FirmID;
        --更新冻结资金，包括个人部分的保证金
		v_F_FrozenFunds := FN_F_UpdateFrozenFunds(p_FirmID,-v_to_unfrozenF+v_Margin-v_Assure+v_Fee,'15');

        return 1;

end;
/

prompt
prompt Creating function FN_T_OUTSTOCKCONFIRM
prompt ======================================
prompt
create or replace function FN_T_OUTSTOCKCONFIRM(
p_stockId  varchar2, --确认收货的仓单ID
p_operator varchar2 --操作员
)
return number
/**
   *  出库的仓单进行确认收货（如果有多个关联仓单，按本仓单占所有关联仓单数量百分比进行付尾款）
   *  返回值
   *  1 确认收货成功
   *  0 仓单正在使用中
   * -1 未找到此仓单交收配对信息无法确认收货
   * by 张天骥 2015-08-14
  ****/
 as
  v_tradeNo t_Settlematch.Matchid%type; --交收配对编号
  v_buyTax number(15,2);--交收配对税费
  v_hl_Amout number(15,2);--升贴水
  v_sellIncome number(15,2);--卖方收货款
  v_sellIncome_Ref number(15,2);--卖方基准货款
  v_payMent number(15,2);--全部尾款
  v_realpayMent number(15,2);--本仓单尾款
  v_amount number(15,2);--金额
  v_firmId_S t_Settlematch.Firmid_s%type;--卖方 ID
  v_firmId_B t_Settlematch.Firmid_b%type;--买方 ID
  v_commodityId t_Settlematch.Commodityid%type;--商品代码
  v_everyAmount number(15,2):=0;--单个关联的仓单数量
  v_confirmAmount number(15,2);--确认收货的商品数量
  v_stockTotal number(15,2):=0; --商品数量
  v_received number(1); --是否收货
  v_stockAmont number(15):=0;--关联仓单数量
begin
  --找到时间最近的关于此仓单的交收配对号
  begin
    select tradeNo into v_tradeNo from (select tradeNo from Bi_tradeStock where stockid = p_stockId and status = 1 order by releasetime desc) where Rownum = 1;
  exception
    when NO_DATA_FOUND then
      return 0;
  end;

  --查找对应的交收配对信息
  begin
    select sellincome,hl_Amount,sellincome_ref,Buytax,Firmid_s,Commodityid,Firmid_b  into
           v_sellIncome,v_hl_Amout,v_sellIncome_Ref,v_buyTax,v_firmId_S,v_commodityId,v_firmId_B from T_SETTLEMATCH where matchid = v_tradeNo for update;
  exception
    when NO_DATA_FOUND then
      return - 1;
  end;
  --查询所有关联仓单,计算关联的所有仓当数量
  for stock in (select * from BI_TRADESTOCK where tradeNo=v_tradeNo)
    loop
      --先确认关联的仓单是否确认收货
     select RECEIVED into v_received from (select RECEIVED from BI_BUSINESSRELATIONSHIP where  stockid=stock.stockId and BUYER=v_firmId_B
                 and seller=v_firmId_S order by selltime desc) where rowNum=1;
      --如果没有收货
      if(v_received=0) then
      select quantity into v_everyAmount from BI_STOCK where stockId = stock.stockid ;
       v_stockTotal:=v_stockTotal+v_everyAmount;
       v_stockAmont:=v_stockAmont+1;
       end if;
      end loop;

      select quantity into v_confirmAmount from Bi_Stock where stockId = p_stockId;
      --如果仓单数为0
      if(v_stockTotal=0) then
      return -1;
      end if;

      --计算尾款 ( 卖方基准货款 +升贴水 +税费 - 卖方收到的钱 +税费 )
      v_payMent:=(v_sellIncome_Ref+v_hl_Amout+v_buyTax)-(v_sellIncome+v_buyTax);
  --如果只剩下一个仓单没确认收货进行减法算钱
  if(v_stockAmont=1) then
  v_realpayMent:=v_payMent;
  else
    v_realpayMent:=(v_payMent/v_stockTotal)*v_confirmAmount;
  end if;

  --打尾款
  if(v_realpayMent!=0) then
    update t_Settlematch t set  t.Sellincome=t.Sellincome+v_realpayMent where t.matchId=v_tradeNo;
    --写流水
    v_amount:=FN_F_UpdateFundsFull(v_firmId_S,'15009',v_realpayMent,v_tradeNo,v_commodityId,null,null);
    --写入交收配对金额日志
    insert into t_Settlematchfundmanage(Id, Matchid, Firmid, Summaryno, Amount, Operatedate, Commodityid)
           values(seq_t_settlematchfundmanage.nextval,v_tradeNo,v_firmId_S,'15009',v_realpayMent,sysdate,v_commodityId);
    --写入交收配对日志
    insert into t_Settlematchlog(Id, Matchid, Operator, Operatelog, Updatetime)
           values(seq_t_settlematchlog.nextval,v_tradeNo,p_operator,'卖方确认收货,仓单号:'||p_stockId||',收货款,配对ID:'||v_tradeNo||'金额:'||v_realpayMent,sysdate);
    end if;
    --更新交收配对时间与变动人
    update t_Settlematch t set t.modifier=p_operator,t.modifytime=sysdate where t.matchid=v_tradeNo;

    --最后将买卖关系表置为完成状态
    update BI_BUSINESSRELATIONSHIP B set received=1,receiveddate=sysdate where b.selltime =
                 (select selltime from ( select selltime from BI_BUSINESSRELATIONSHIP where  stockid=p_stockId and BUYER=v_firmId_B
                 and seller=v_firmId_S order by selltime desc) where rowNum=1) and BUYER=v_firmId_B and seller=v_firmId_S and stockid=p_stockId;
      return 1;
end;
/

prompt
prompt Creating function FN_T_SELLBILLORDER
prompt ====================================
prompt
create or replace function FN_T_SellBillOrder(
    p_FirmID     varchar2,  --交易商ID
    p_TraderID       varchar2,  --交易员ID
    p_CommodityID varchar2,
    p_bs_flag        number,
    p_price          number,
    p_quantity       number,
  --p_Margin     number,     --委托应收保证金
    p_Fee   number,   --委托应收手续费
	p_CustomerID     varchar2,  --交易客户ID
	p_ConsignerID       varchar2 --委托员ID

) return number
/****
 * 卖仓单委托
 * 返回值
 * >0  成功提交，并返回委托单号
 * -1  资金余额不足
 * -2  超过交易商对此商品的最大订货量
 * -3  超过交易商总的最大订货量
 * -4  超过品种最大订货量
 * -5  超过商品最大订货量
 * -6  超过交易商对此商品的最大净订货量
 * -7  超过单笔最大委托量（改在java中判断）2009-09-18
 * -8  抵顶数量大于可用数量
 * -9  没有对应的生效仓单抵顶记录
 * -99  不存在相关数据
 * -100 其它错误
****/
as
	--v_version varchar2(10):='1.0.0.9';
    v_F_Funds        number(15,2):=0;   --应冻结资金
    v_VirtualFunds   number(15,2);   --虚拟资金
    v_A_Funds        number(15,2);   --可用资金
    v_HoldSum        number(15,0);   --持仓合计
	v_HoldSum_b        number(15,0);   --持仓合计b
	v_HoldSum_s        number(15,0);   --持仓合计s
    v_A_OrderNo      number(15,0);   --委托号
    v_NotTradeSum    number(15,0);   --开仓未成交合计
	v_NotTradeSum_b    number(15,0);   --开仓未成交合计b
	v_NotTradeSum_s    number(15,0);   --开仓未成交合计s
	v_BreedID      number(10,0);
	v_LimitBreedQty      number(10,0);
	v_LimitCmdtyQty      number(10,0);
	v_FirmCleanQty      number(10,0);
	v_FirmMaxHoldQty      number(10,0);
	v_MaxHoldQty      number(10,0); --交易商最大订货量
	v_MaxOverdraft        number(15,2):=0;   --最大透支额度
	v_F_FrozenFunds   number(15,2);   --冻结资金
    v_errorcode number;
    v_errormsg  varchar2(200);
  v_AvailableQuantity number(10);--可用数量 add by yukx 20100507
begin

      begin
        select Quantity-FrozenQty into v_AvailableQuantity from T_ValidGageBill
        where FirmID=p_FirmID
          and CommodityID = p_CommodityID;
          --and BreedID=(select BreedID from t_commodity where CommodityID=p_CommodityID);
        exception
          when NO_DATA_FOUND then
  	      return -9;--没有对应的生效仓单抵顶记录
      end;

      if(v_AvailableQuantity<p_Quantity) then
        return -8;--抵顶数量大于可用数量
      end if;

        --应冻结资金
        --zhengxuan 改为应冻结手续费不冻结保证金
        --v_F_Funds := p_Margin + p_Fee;
        v_F_Funds :=  p_Fee;

        --获得虚拟资金
        select VirtualFunds,MaxHoldQty,MaxOverdraft into v_VirtualFunds,v_MaxHoldQty,v_MaxOverdraft from T_Firm where FirmID = p_FirmID;
        --计算可用资金，并锁住财务资金
        v_A_Funds := FN_F_GetRealFunds(p_FirmID,1) + v_VirtualFunds + v_MaxOverdraft;
        if(v_A_Funds < v_F_Funds) then
            rollback;
            return -1;  --资金余额不足
        else
            --1、验证是否超过交易商总的最大持仓量
			if(v_MaxHoldQty <> -1) then
				select nvl(sum(Quantity-TradeQty),0) into v_NotTradeSum
	            from T_Orders
	            where FirmID = p_FirmID
				and OrderType=1 and Status in(1,2);

	            select nvl(sum(holdqty+GageQty),0) into v_HoldSum
	            from T_FirmHoldSum
	            where FirmID = p_FirmID;

	            if(v_HoldSum + v_NotTradeSum + p_quantity > v_MaxHoldQty) then
	                rollback;
	                return -3;  --超过总的最大持仓量
	            end if;
			end if;
			--在品种和商品属性中获取品种最大订货量，商品最大订货量，交易商最大净订货量，交易商最大订货量
			select a.BreedID,a.LimitBreedQty,b.LimitCmdtyQty,b.FirmCleanQty,b.FirmMaxHoldQty into v_BreedID,v_LimitBreedQty,v_LimitCmdtyQty,v_FirmCleanQty,v_FirmMaxHoldQty
			from T_A_Breed a,T_Commodity b
			where a.BreedID=b.BreedID and b.CommodityID=p_CommodityID;
			--获取交易商特殊订货量
		    begin
		        select CleanMaxHoldQty,MaxHoldQty
		    	into v_FirmCleanQty,v_FirmMaxHoldQty
		        from T_A_FirmMaxHoldQty
		        where FirmID=p_FirmID and CommodityID=p_CommodityID;
		    exception
		        when NO_DATA_FOUND then
		            null;
		    end;
			--2、验证是否超过品种最大订货量
			if(v_LimitBreedQty <> -1) then
	            select nvl(sum(a.Quantity-a.TradeQty),0) into v_NotTradeSum
	            from T_Orders a,T_Commodity b
	            where a.CommodityID=b.CommodityID and b.BreedID=v_BreedID
				and a.OrderType=1 and a.BS_Flag=p_bs_flag and a.Status in(1,2);

	            select nvl(sum(a.holdqty+a.GageQty),0) into v_HoldSum
	            from T_FirmHoldSum a,T_Commodity b
	            where a.CommodityID=b.CommodityID and b.BreedID=v_BreedID and a.BS_Flag=p_bs_flag;
	            if(v_HoldSum + v_NotTradeSum + p_quantity > v_LimitBreedQty) then
	                rollback;
	                return -4;  --超过品种最大订货量
	            end if;
			end if;
            --3、验证是否超过商品最大订货量
			if(v_LimitCmdtyQty <> -1) then
	            select nvl(sum(Quantity-TradeQty),0) into v_NotTradeSum
	            from T_Orders
	            where CommodityID=p_CommodityID
				and OrderType=1 and BS_Flag=p_bs_flag and Status in(1,2);

	            select nvl(sum(holdqty+GageQty),0) into v_HoldSum
	            from T_FirmHoldSum
	            where CommodityID=p_CommodityID and BS_Flag=p_bs_flag;
	            if(v_HoldSum + v_NotTradeSum + p_quantity > v_LimitCmdtyQty) then
	                rollback;
	                return -5;  --超过商品最大订货量
	            end if;
			end if;
            --4、验证是否超过交易商对此商品的最大订货量
			if(v_FirmMaxHoldQty <> -1) then
	            select nvl(sum(Quantity-TradeQty),0) into v_NotTradeSum
	            from T_Orders
	            where FirmID = p_FirmID and CommodityID=p_CommodityID
				and OrderType=1 and Status in(1,2);

	            select nvl(sum(holdqty+GageQty),0) into v_HoldSum
	            from T_FirmHoldSum
	            where FirmID = p_FirmID and CommodityID=p_CommodityID;

	            if(v_HoldSum + v_NotTradeSum + p_quantity > v_FirmMaxHoldQty) then
	                rollback;
	                return -2;  --超过交易商对此商品的最大订货量
	            end if;
			end if;
            --5、验证是否超过交易商对此商品的最大净订货量
			if(v_FirmCleanQty <> -1) then
	            select nvl(sum(holdqty+GageQty),0) into v_HoldSum_b
	            from T_FirmHoldSum
	            where FirmID = p_FirmID and CommodityID=p_CommodityID and BS_Flag=1;
	            select nvl(sum(holdqty+GageQty),0) into v_HoldSum_s
	            from T_FirmHoldSum
	            where FirmID = p_FirmID and CommodityID=p_CommodityID and BS_Flag=2;
	            if(p_bs_flag = 1) then
		            select nvl(sum(Quantity-TradeQty),0) into v_NotTradeSum_b
		            from T_Orders
		            where FirmID = p_FirmID and CommodityID=p_CommodityID and BS_Flag=1
					and OrderType=1 and Status in(1,2);
		            if(v_HoldSum_b + v_NotTradeSum_b + p_quantity - v_HoldSum_s > v_FirmCleanQty) then
		                rollback;
		                return -6;  --超过交易商对此商品的最大净订货量
		            end if;
		        else
		            select nvl(sum(Quantity-TradeQty),0) into v_NotTradeSum_s
		            from T_Orders
		            where FirmID = p_FirmID and CommodityID=p_CommodityID and BS_Flag=2
					and OrderType=1 and Status in(1,2);
		            if(v_HoldSum_s + v_NotTradeSum_s + p_quantity - v_HoldSum_b > v_FirmCleanQty) then
		                rollback;
		                return -6;  --超过交易商对此商品的最大净订货量
		            end if;
	            end if;
			end if;

       -- zhengxuan 增加生效仓单抵顶表冻结数量
       update T_ValidGageBill set Frozenqty=Frozenqty+p_quantity where FirmID=p_FirmID
               and CommodityID=p_CommodityID; --BreedID=(select BreedID from t_commodity where CommodityID=p_CommodityID);

        end if;

        --更新冻结资金
		v_F_FrozenFunds := FN_F_UpdateFrozenFunds(p_FirmID,v_F_Funds,'15');
		--插入委托表，并返回委托单号
		--调用计算函数修改委托单号 2011-2-15 by feijl
	    select FN_T_ComputeOrderNo(SEQ_T_Orders.nextval) into v_A_OrderNo from dual;
	    --zhengxuan 增加仓单交易类型
      insert into T_Orders
	      (a_orderno,a_orderno_w, CommodityID, Firmid, traderid,    bs_flag, ordertype, status, quantity, price, closemode, specprice, timeflag, tradeqty, frozenfunds, unfrozenfunds, ordertime, withdrawtime, ordererip, signature, CustomerID,ConsignerID,BillTradeType)
	    values
	      (v_A_OrderNo,  null, p_CommodityID, p_Firmid, p_traderid, p_bs_flag,    1 ,      1, p_quantity, p_price, null,     null,      null,    0,         v_F_Funds,     0,           sysdate,      null,        null,     null,p_CustomerID,p_ConsignerID,  1    );
	    commit;
	    return v_A_OrderNo;
exception
    when NO_DATA_FOUND then
        rollback;
        return -99;  --不存在相关数据
    when others then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_SellBillOrder',v_errorcode,v_errormsg);
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_T_SELLBILLTRADE
prompt ====================================
prompt
create or replace function FN_T_SellBillTrade (
    p_A_OrderNo     number,  --委托单号
    p_M_TradeNo     number,  --撮合成交号
    p_Price         number,  --成交价
    p_Quantity      number,   --成交数量
	  p_M_TradeNo_Opp     number,  --对方撮合成交号
    p_CommodityID varchar2,
    p_FirmID     varchar2,
    p_TraderID       varchar2,
    p_bs_flag        number,
    p_status         number,
    p_orderQty       number,--委托数量
    p_orderPrice          number,--委托价格
    p_orderTradeQty       number,--委托已成交数量
    p_frozenfunds    number,
    p_unfrozenfunds  number,
    p_CustomerID        varchar2,
    p_OrderType      number,
    p_contractFactor number,
	  p_MarginPriceType         number,     --计算成交保证金结算价类型 0:实时和闭市时都按开仓价；1:实时按昨结算价，闭市按当日结算价；2:盘中按订立价，闭市结算时按当日结算价；
    p_marginAlgr         number,
    p_marginRate_b         number,
    p_marginRate_s         number,
    p_marginAssure_b         number,
    p_marginAssure_s         number,
    p_feeAlgr       number,
    p_feeRate_b         number,
    p_feeRate_s         number,
    p_YesterBalancePrice    number,
    p_GageMode    number,
    p_TradeDate date,
    p_FirmID_opp     varchar2
) return number
/****
 * 卖仓单成交回报
 * 1、注意不要提交commit，因为别的函数要调用它；
 * 返回值
 * 1 成功
 * -1 成交数量大于未成交数量
 * -100 其它错误
****/
as
	v_version varchar2(10):='1.0.2.2';
    v_num            number(10);
    v_to_unfrozenF   number(15,2):=0;
    v_Margin         number(15,2):=0;   --应收保证金
	v_Assure         number(15,2):=0;   --应收担保金
    v_Fee            number(15,2):=0;   --应收费用
    v_frozenMargin   number(15,2);   --应收保证金
    v_frozenFee      number(15,2);   --应收费用
    v_A_TradeNo      number(15);
    v_A_HoldNo       number(15);
    v_MarginPrice    number(15,2);  --计算成交保证金的价格
	v_unfrozenPrice    number(15,2);  --计算释放冻结保证金，手续费的价格
    v_TradeType      number(1);
	v_F_FrozenFunds   number(15,2);
begin
      --计算保证金价格
	  if(p_MarginPriceType = 1) then
	      v_MarginPrice := p_YesterBalancePrice;
	  else  -- default type is 0
		  v_MarginPrice := p_Price;
	  end if;
    --zhengxuan 增加的成交记录成交类型为卖仓单；
    v_TradeType := 7;  --类型为卖仓单

    if(p_Quantity = p_orderQty - p_orderTradeQty) then
        v_to_unfrozenF := p_frozenfunds - p_unfrozenfunds;
        --更新委托
        update T_Orders
        set unfrozenfunds=unfrozenfunds + v_to_unfrozenF,
            tradeqty=tradeqty + p_Quantity,
            Status=3,UpdateTime=systimestamp(3)
        where A_orderNo = p_A_OrderNo;
    elsif(p_Quantity < p_orderQty - p_orderTradeQty) then
        if(p_MarginPriceType = 1) then
            v_unfrozenPrice := p_YesterBalancePrice;
        else  -- default type is 0
         v_unfrozenPrice := p_orderPrice;
        end if;
        --zhengxuan 释放卖仓单委托冻结手续费
        v_frozenMargin := 0 ;
        --FN_T_ComputeMarginByArgs(p_bs_flag,p_Quantity,v_unfrozenPrice,p_contractFactor,p_marginAlgr,p_marginRate_b,p_marginRate_s);
        if(v_frozenMargin < 0) then
            Raise_application_error(-20040, 'computeMargin error');
        end if;
        v_frozenFee := FN_T_ComputeFeeByArgs(p_bs_flag,p_Quantity,v_unfrozenPrice,p_contractFactor,p_feeAlgr,p_feeRate_b,p_feeRate_s);
        if(v_frozenFee < 0) then
            Raise_application_error(-20030, 'computeFee error');
        end if;
        v_to_unfrozenF := v_frozenMargin + v_frozenFee;
        --更新委托
        if(p_status = 6) then  --状态为部分成交后撤单，如果部分成交回报在撤单回报之后，不用再更新状态了
           update T_Orders
           set unfrozenfunds=unfrozenfunds + v_to_unfrozenF,
               tradeqty=tradeqty + p_Quantity,UpdateTime=systimestamp(3)
           where A_orderNo = p_A_OrderNo;
        else
           update T_Orders
           set unfrozenfunds=unfrozenfunds + v_to_unfrozenF,
               tradeqty=tradeqty + p_Quantity,Status=2,UpdateTime=systimestamp(3)
           where A_orderNo = p_A_OrderNo;
        end if;
    else
        rollback;
        return -1;
    end if;
    --计算成交后应扣除的手续费
    v_Fee := FN_T_ComputeFeeByArgs(p_bs_flag,p_Quantity,p_Price,p_contractFactor,p_feeAlgr,p_feeRate_b,p_feeRate_s);
    if(v_Fee < 0) then
      Raise_application_error(-20030, 'computeFee error');
    end if;
    --插入成交记录
	--调用计算函数修改成交单号 2011-2-15 by feijl
    select FN_T_ComputeTradeNo(SEQ_T_Trade.nextval) into v_A_TradeNo from dual;
    insert into T_Trade
      (a_tradeno,    m_tradeno, a_orderno,   tradetime, Firmid, CommodityID,   bs_flag,    ordertype,     price, quantity, close_pl, tradefee,TradeType,CustomerID,M_TradeNo_Opp,TradeAtClearDate,oppFirmid)
    values
      (v_A_TradeNo, p_M_TradeNo, p_A_OrderNo, sysdate, p_FirmID, p_CommodityID,p_bs_flag, p_OrderType,   p_price, p_quantity, 0,       v_Fee,v_TradeType,p_CustomerID,p_M_TradeNo_Opp,p_TradeDate,p_FirmID_opp);

		-- zhengxuan 计算保证金 不算保证金  保证金为0
    v_Margin := 0;
    --FN_T_ComputeMarginByArgs(p_bs_flag,p_Quantity,v_MarginPrice,p_contractFactor,p_marginAlgr,p_marginRate_b,p_marginRate_s);
    if(v_Margin < 0) then
        Raise_application_error(-20040, 'computeMargin error');
    end if;
    --zhengxuan 计算担保金 不算担保金  担保金为0
    v_Assure := 0;
    --FN_T_ComputeAssureByArgs(p_bs_flag,p_Quantity,v_MarginPrice,p_contractFactor,p_marginAlgr,p_marginAssure_b,p_marginAssure_s);
    if(v_Assure < 0) then
        Raise_application_error(-20041, 'computeAssure error');
    end if;
    --保证金应加上担保金
    v_Margin := v_Margin + v_Assure;

    --插入持仓明细表
    --zhengxuan  持仓保证金，担保金都是0；
	--调用计算函数修改持仓单号 2011-2-15 by feijl
    select FN_T_ComputeHoldNo(SEQ_T_HoldPosition.nextval) into v_A_HoldNo from dual;
    insert into T_Holdposition
      (a_holdno,    a_tradeno,  CommodityID,    CustomerID , bs_flag,   price,    holdqty,    openqty, holdtime,HoldMargin,HoldAssure,Firmid,FloatingLoss,AtClearDate,gageQty)
    values
      (v_A_HoldNo, v_A_TradeNo, p_CommodityID, p_CustomerID, p_bs_flag, p_price, 0       ,p_quantity, sysdate,      0   ,   0      ,    p_FirmID,   0,     p_TradeDate,p_quantity);

    --更新交易客户持仓合计表
    --zhengxuan  持仓保证金，担保金都是0；
    select count(*) into v_num from T_CustomerHoldSum
    where CustomerID = p_CustomerID
      and CommodityID = p_CommodityID
      and bs_flag = p_bs_flag;
    if(v_num >0) then
        update T_CustomerHoldSum
        set holdQty = holdQty + 0,
        holdFunds = holdFunds + p_Price*p_Quantity*p_contractFactor,
        HoldMargin = HoldMargin + 0,
        HoldAssure = HoldAssure + 0,
        evenprice = (holdFunds + p_Price*p_Quantity*p_contractFactor)/((holdQty + GageQty + p_Quantity)*p_contractFactor),
         gageQty = gageQty+p_Quantity
        where CustomerID = p_CustomerID
        and CommodityID = p_CommodityID
        and bs_flag = p_bs_flag;
    else
        insert into T_CustomerHoldSum
              (CustomerID  , CommodityID  , bs_flag  , holdQty,         holdFunds                  ,FloatingLoss, evenprice,FrozenQty,HoldMargin,HoldAssure,FirmID  ,gageQty)
        values
              (p_CustomerID, p_CommodityID, p_bs_flag,    0   , p_Price*p_Quantity*p_contractFactor,    0       , p_Price  ,     0   ,     0    ,    0     ,p_FirmID,p_Quantity);
    end if;

    --更新交易商持仓合计表
    --zhengxuan 持仓保证金，担保金都是0 ；
    select count(*) into v_num from T_FirmHoldSum
    where Firmid = p_FirmID
    and CommodityID = p_CommodityID
    and bs_flag = p_bs_flag;

    if(v_num >0) then
        update T_FirmHoldSum
        set holdQty = holdQty + 0,
        holdFunds = holdFunds + decode(p_GageMode,1,p_Price*p_Quantity*p_contractFactor,0),--持仓金额
        HoldMargin = HoldMargin + 0,
        HoldAssure = HoldAssure + 0,
        evenprice = decode(holdQty + decode(p_GageMode,1,p_Quantity,0) + decode(p_GageMode,1,GageQty,0), 0,
                  0,
                  (holdFunds +decode(p_GageMode,1,p_Price*p_Quantity*p_contractFactor,0))/((holdQty + decode(p_GageMode,1,p_Quantity,0) + decode(p_GageMode,1,GageQty,0))*p_contractFactor) ), --均价
        gageQty = gageQty+p_Quantity
        where Firmid = p_FirmID
        and CommodityID = p_CommodityID
        and bs_flag = p_bs_flag;
    else
      insert into T_FirmHoldSum
        (FirmID  , CommodityID  ,   bs_flag, holdQty,                       holdFunds                           ,FloatingLoss,        evenprice                ,HoldMargin,HoldAssure,gageQty)
      values
        (p_FirmID, p_CommodityID, p_bs_flag,   0   , decode(p_GageMode,1,p_Price*p_Quantity*p_contractFactor,0) ,     0      ,   decode(p_GageMode,1,p_Price,0),  0       ,  0       ,p_Quantity);
    end if;

    --更新临时保证金和临时担保金
    update T_Firm
    set runtimemargin = runtimemargin + v_Margin,
        RuntimeAssure = RuntimeAssure + v_Assure
    where Firmid = p_FirmID;
    --更新冻结资金，包括个人部分的保证金
    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(p_FirmID,-v_to_unfrozenF+v_Margin-v_Assure+v_Fee,'15');

    --zhengxuan 生效仓单抵顶表释放冻结数量并减少总数量；
    update T_ValidGageBill set Quantity=Quantity-p_Quantity,Frozenqty=Frozenqty-p_Quantity where FirmID=p_FirmID
           and CommodityID=p_CommodityID; --BreedID=(select BreedID from t_commodity where CommodityID=p_CommodityID);
    return 1;
end;
/

prompt
prompt Creating function FN_T_SETTLECANCEL
prompt ===================================
prompt
create or replace function Fn_T_SettleCancel
(
    p_matchId varchar2, --配对编号
    p_operator varchar2 --操作人
) return number
/****
 * 撤销配对调用此存储
 * 返回值
 *  1 成功  其他失败
 *  2 处理完成
 *  3 撤销
 *  4 已货权转移
****/
as
 v_status number;  --配对状态  0 未处理 1 处理中 2 处理完成 3 撤销
 v_isTransfer number;--是否货权转移 0：未货权转移 1：已货权转移
 v_Balance number(15,2):=0;
begin
     select status,isTransfer into v_status,v_isTransfer from t_settlematch where matchId=p_matchId for update;
     if(v_status=2 or v_status=3)then
        return v_status;
     elsif(v_status=1 and v_isTransfer=1)then
        return 4;
     else
         --轮询配对关联表，还原交收持仓明细数据
         for rel in (select * from T_MatchSettleholdRelevance t where t.matchid=p_matchId)
         loop
           update t_settleholdposition set happenmatchqty=happenmatchqty-rel.quantity,happenMatchSettleMargin=happenMatchSettleMargin-rel.settlemargin,
           happenMatchPayout=happenMatchPayout-rel.settlePayOut,matchstatus=decode(happenmatchqty-rel.quantity,0,0,1) where id=rel.settleId;
         end loop;
          --轮询交收配对金额处理表，还原配对处理的金额
         for man in (select * from T_SettleMatchFundManage t where t.matchid=p_matchId)
         loop
           v_Balance := FN_F_UpdateFundsFull(man.firmId,man.summaryNo,-man.amount,p_matchId,man.commodityId,null,null);
           if(man.summaryNo='15013')then
              update T_Firm set RuntimeSettleMargin=RuntimeSettleMargin-man.amount where firmid = man.firmid;
           elsif(man.summaryNo='15014')then
              update T_Firm set RuntimeSettleMargin=RuntimeSettleMargin+man.amount where firmid = man.firmid;
           end if;
           insert into T_SettleMatchFundManage(id,MatchID,Firmid,Summaryno,Amount,Operatedate,Commodityid)
           values (SEQ_T_SettleMatchFundManage.Nextval,man.matchId,man.firmId,man.summaryNo,-man.amount,sysdate,man.commodityId);
         end loop;
         --撤销时将对应的持仓单号上的税费进行处理 by 张天骥 2015/08/14
         for woman in (select * from t_Settleandhold t where t.matchid=p_matchId)
           loop
             if(woman.bs_flag='1')then
             update t_Settleholdposition  set SETTLEADDEDTAX=SETTLEADDEDTAX-woman.tax where ID = woman.settleholdpositionid;
             end if;
          end loop;

         --修改配对状态为撤销
            update t_settlematch set status=3,modifier=p_operator,modifyTime=sysdate where matchId=p_matchId;
         --插入交收配对日志
            insert into t_settlematchlog (id,matchid,operator,operatelog,updatetime)
            values (SEQ_t_settlematchlog.Nextval,p_matchId,p_operator,'撤销，配对ID:'||p_matchId,sysdate);
          --删除配对关联表
          delete from T_MatchSettleholdRelevance where matchid=p_matchId;
          --删除仓单冻结表
          --2014-01-21撤销时不删除仓单冻结表，方便撤销后看仓单信息
          --delete from T_billFrozen where Operation=p_matchId;
         return 1;
     end if;
end;
/

prompt
prompt Creating function FN_T_SETTLEMATCH
prompt ==================================
prompt
create or replace function FN_T_SettleMatch
(
    p_commodityId varchar2, --商品代码
    p_quantity number,  --交收数量
    p_status number, --状态
    p_result number, --履约状态
    p_firmID_B varchar2,  --买方交易商代码
    p_firmID_S varchar2,  --卖方交易商代码
    p_settleDate varchar2, --交收日期
    p_matchId varchar2 ,--配对编号
    p_operator varchar2 --操作人
) return number
/****
 *
 *  轮询持仓时过滤交收类型不为提前交收即可（除延期商品交收申报当日下市外，交收持仓不会出现同时存在延期和到期交收的情况，这是遗留问题，暂时排除该情况）
 *  添加配对时交收类型只看商品设置的交收类型与持仓的交收类型无关
 * 返回值
 *  1 成功
 * -1 买方持仓不足
 * -2 卖方持仓不足
****/
as
 v_contractFactor number;  --合约因子
 v_buypayout_ref number(15,2):=0;--买方参考货款
 v_buyPayout number(15,2):=0;--已收买方货款
 v_sellincom_ref number(15,2):=0;--卖方参考货款
 v_buyMargin number(15,2):=0;--买方交收保证金
 v_sellMargin number(15,2):=0;--卖方交收保证金
 v_everybuyPayout number(15,2):=0;--买方每笔持仓已收货款
 v_everybuyMargin number(15,2):=0;--买方每笔持仓交收保证金
 v_everysellMargin number(15,2):=0;--卖方每笔持仓交收保证金
 v_price number;
 v_settleprice_b number:=0;
 v_settleprice_s number:=0;
 v_weight number(15,4);
 v_amountQty_s number(10);
 v_amountQty_b number(10);
 v_quantity number(10);
 v_settlePriceType number(2); --到期交收价格计算 0,1,3 统一价 2订立价
 v_delaySettlePriceType number(2);--延期交收申报交收价格类型 0统一价 1订立价
 v_settleType number(2);--配对表的交收方式 1到期 3延期
 v_settleDate varchar2(20);--交收日期 （到期交收取持仓明细的交收处理日期，延期为p_settleDate）
 v_settleWay number(2);--商品表交收方式0中远期（到期） 1连续现货（延期） 2专场交易 （到期）
 v_count number;
 v_taxIncluesive number(1);--商品价格中是否含税  1 不含税 0 含税
 v_addedtax number(10,4):=0;--商品增值税率
 v_buytax number(15,2):=0;--买方总税
 v_everytax number(15,2):=0;--每笔税费
 v_fundsflow number;--没用的流水返回值
begin
    --到历史商品表查询商品参数 如果历史查不到查当前商品（因为交易结算时商品导历史，所以在交易结算前做当天的延期申报配对时只能查当前商品表）
    select count(*) into v_count from t_h_commodity where commodityid=p_commodityId and trunc(cleardate)=to_date(p_settleDate,'yyyy-MM-dd');
    if v_count=0 then
       select settlepricetype,delaySettlePriceType,contractFactor,settleWay,TAXINCLUSIVE,addedtax into v_settlePriceType,v_delaySettlePriceType,v_contractFactor,v_settleWay,v_taxIncluesive,v_addedtax from t_commodity where commodityid=p_commodityId;
    else
       select settlepricetype,delaySettlePriceType,contractFactor,settleWay,TAXINCLUSIVE,addedtax into v_settlePriceType,v_delaySettlePriceType,v_contractFactor,v_settleWay,v_taxIncluesive,v_addedtax from t_h_commodity where commodityid=p_commodityId and trunc(cleardate)=to_date(p_settleDate,'yyyy-MM-dd');
    end if;
--延期交收还是到期交收，settleType =1为延期订立价交割，其他为到期交割
    if v_settleWay=1 then
       v_settleType:=3;
       if v_delaySettlePriceType=1 then
          v_settlePriceType:=2;
       end if;
    else
        v_settleType:=1;
    end if;
    --查询买卖双方的可配对数量
    select  nvl(sum(HoldQty+GageQty-happenMATCHQTY),0)  into v_amountQty_b from t_settleholdposition t where CommodityID=p_commodityId and BS_Flag=1 and FirmID=p_firmID_B and settletype<>2 and trunc(SettleProcessDate)=to_date(p_settleDate,'yyyy-MM-dd') ;
    select  nvl(sum(HoldQty+GageQty-happenMATCHQTY),0) into v_amountQty_s from t_settleholdposition t where CommodityID=p_commodityId and BS_Flag=2 and FirmID=p_firmID_S and settletype<>2 and trunc(SettleProcessDate)=to_date(p_settleDate,'yyyy-MM-dd') ;
    if(v_amountQty_b<p_quantity)then
        return -1;--买方持仓不足
    end if;
    if(v_amountQty_s<p_quantity)then
        return -2;--卖方持仓不足
    end if;

   --买方
   v_weight:=p_quantity;--配对数量
   for debit in (select * from t_settleholdposition t where CommodityID=p_commodityId and BS_Flag=1 and FirmID=p_firmID_B and settletype<>2 and trunc(SettleProcessDate)=to_date(p_settleDate,'yyyy-MM-dd') order by a_holdno asc)
    loop
       v_settleDate:=p_settleDate;
       v_quantity:=debit.HoldQty+debit.GageQty-debit.happenmatchqty;
       if(v_settlePriceType=2)then
          v_price:=debit.price;
       else
          v_price:=debit.settlePrice;
       end if;
      v_settleprice_b:=debit.settlePrice;
      --部分配对
      if v_quantity > v_weight  then
        --如果商品货款中含税
         if(v_taxIncluesive=0) then
         --税费
         v_everytax:=(v_price*v_weight*v_contractFactor)*(v_addedtax/(1+v_addedtax));
        --基准货款 = 货款 - 税费
          v_buypayout_ref:=v_buypayout_ref+(v_price*v_weight*v_contractFactor-v_everytax);
          --如果商品货款中不含税
         else
           --税费
           v_everytax:=(v_price*v_weight*v_contractFactor)*v_addedtax;
          --基准货款不变
          v_buypayout_ref:=v_buypayout_ref+v_price*v_weight*v_contractFactor;
         end if;
         --每笔交收货款
          v_everybuyPayout:=debit.Payout/(debit.HoldQty+debit.GageQty)*v_weight;
          --保证金
          v_everybuyMargin:=debit.SettleMargin/(debit.HoldQty+debit.GageQty)*v_weight;
          v_buyPayout:=v_buyPayout+v_everybuyPayout;
          v_buyMargin:=v_buyMargin+v_everybuyMargin;
          --税费
          v_buytax:=v_buytax + v_everytax;
          --修改交收持仓明细配对状态=部分配对，已配对数量，已配对货款，已配对保证金
          update T_SettleHoldPosition set MATCHStatus=1,happenmatchqty = happenmatchqty + v_weight,happenMatchPayout=happenMatchPayout+v_everybuyPayout ,
                 happenMatchSettleMargin=happenMatchSettleMargin+v_everybuyMargin,SETTLEADDEDTAX=debit.SETTLEADDEDTAX+v_everytax where id=debit.id;
          --插入交收配对关联表
          insert into T_MatchSettleholdRelevance (MatchID, SettleID, Quantity, Price, SettlePayOut, Settlemargin) values (p_matchId, debit.id, v_weight, v_price, v_everybuyPayout, v_everybuyMargin);
          v_weight:=0;
      else
        --全部配对的情况
         if v_quantity > 0 then
         --如果商品货款中含税
         if(v_taxIncluesive=0) then
         --税费
         v_everytax:=(v_price*v_quantity*v_contractFactor)*(v_addedtax/(1+v_addedtax));
        --基准货款 = 货款 - 税费
          v_buypayout_ref:=v_buypayout_ref+(v_price*v_quantity*v_contractFactor-v_everytax);
          --如果商品货款中不含税
         else
           --税费
           v_everytax:=(v_price*v_quantity*v_contractFactor)*v_addedtax;
          --基准货款不变
          v_buypayout_ref:=v_buypayout_ref+v_price*v_quantity*v_contractFactor;
         end if;
          v_weight:=v_weight - v_quantity;
          --最后一笔持仓用减法换算已配对货款和保证金
          v_everybuyPayout:=debit.Payout-debit.happenMatchPayout;
          v_everybuyMargin:=debit.SettleMargin-debit.happenMatchSettleMargin;
          v_buyPayout:=v_buyPayout+v_everybuyPayout;
          v_buyMargin:=v_buyMargin+v_everybuyMargin;
           --税费
          v_buytax:=v_buytax + v_everytax;
          --修改交收持仓明细配对状态=全部配对，已配对数量，已配对货款，已配对保证金
          update T_SettleHoldPosition set MATCHStatus=2,happenmatchqty = debit.HoldQty+debit.GageQty ,happenMatchPayout=happenMatchPayout+v_everybuyPayout ,
                 happenMatchSettleMargin=happenMatchSettleMargin+v_everybuyMargin,SETTLEADDEDTAX=debit.SETTLEADDEDTAX+v_everytax  where id=debit.id;
          --插入交收配对关联表
          insert into T_MatchSettleholdRelevance (MatchID, SettleID, Quantity, Price, SettlePayOut, Settlemargin) values (p_matchId, debit.id, v_quantity, v_price, v_everybuyPayout, v_everybuyMargin);
        end if;
      end if;
      exit when v_weight=0;
    end loop;

    --卖方
    v_weight:=p_quantity;--配对数量
    for debit in (select * from t_settleholdposition t where CommodityID=p_commodityId and BS_Flag=2 and FirmID=p_firmID_S and settletype<>2 and trunc(SettleProcessDate)=to_date(p_settleDate,'yyyy-MM-dd') order by a_holdno asc)
     loop
      v_settleDate:=p_settleDate;
      v_quantity:=debit.HoldQty+debit.GageQty-debit.happenmatchqty;
      if(v_settlePriceType=2)then
          v_price:=debit.price;
      else
          v_price:=debit.settlePrice;
      end if;
      v_settleprice_s:=debit.settlePrice;
      if v_quantity > v_weight  then
         --如果商品货款中含税
         if(v_taxIncluesive=0) then
         --税费
          v_everytax:=(v_price*v_weight*v_contractFactor)*(v_addedtax /(1+v_addedtax));
        --基准货款 = 货款 - 税费
           v_sellincom_ref:=v_sellincom_ref+(v_price*v_weight*v_contractFactor-v_everytax);
          --如果商品货款中不含税
         else
          --基准货款不变
            v_sellincom_ref:=v_sellincom_ref+v_price*v_weight*v_contractFactor;
         end if;
          v_everysellMargin:=debit.SettleMargin/(debit.HoldQty+debit.GageQty)*v_weight;
          v_sellMargin:=v_sellMargin+v_everysellMargin;
          --修改交收持仓明细配对状态=部分配对，已配对数量，已配对保证金
          update T_SettleHoldPosition set MATCHStatus=1,happenmatchqty = happenmatchqty + v_weight,
                 happenMatchSettleMargin=happenMatchSettleMargin+v_everysellMargin where id=debit.id;
          --插入交收配对关联表
          insert into T_MatchSettleholdRelevance (MatchID, SettleID, Quantity, Price, SettlePayOut, Settlemargin) values (p_matchId, debit.id, v_weight, v_price, 0, v_everysellMargin);
          v_weight:=0;
      else
         if v_quantity > 0 then
            --如果商品货款中含税
         if(v_taxIncluesive=0) then
          v_everytax:=(v_price*v_quantity*v_contractFactor)*(v_addedtax/(1+v_addedtax));
        --基准货款 = 货款 - 税费
          v_sellincom_ref:=v_sellincom_ref+(v_price*v_quantity*v_contractFactor-v_everytax);
          --如果商品货款中不含税
         else
           --税费
           --v_everytax:=(v_price*v_quantity*v_contractFactor)*v_addedtax;
          --基准货款不变
          v_sellincom_ref:=v_sellincom_ref+v_price*v_quantity*v_contractFactor;
         end if;
          v_everysellMargin:=debit.SettleMargin-debit.happenMatchSettleMargin;
          v_sellMargin:=v_sellMargin+v_everysellMargin;
          v_weight:=v_weight - v_quantity;
          --修改交收持仓明细配对状态=全部配对，已配对数量，已配对保证金
          update T_SettleHoldPosition set MATCHStatus=2,happenmatchqty = debit.HoldQty+debit.GageQty ,
                 happenMatchSettleMargin=happenMatchSettleMargin+v_everysellMargin where id=debit.id;
          --插入交收配对关联表
          insert into T_MatchSettleholdRelevance (MatchID, SettleID, Quantity, Price, SettlePayOut, Settlemargin) values (p_matchId, debit.id, v_quantity, v_price, 0, v_everysellMargin);
        end if;
      end if;
      exit when v_weight=0;
    end loop;
    --插入交收配对表
    insert into T_SettleMatch (MatchID,  CommodityID,  ContractFactor,  Quantity,Status,Result,SettleType, FirmID_B,  BuyPrice,  BuyPayout_Ref,  BuyPayout,  BuyMargin,
                               FirmID_S,SellPrice,SellIncome_Ref,SellIncome,SellMargin,CreateTime,ModifyTime,SettleDate, Modifier,buytax,taxIncluesive)
                         values(p_matchId,p_commodityId,v_contractFactor,p_quantity,p_status,p_result,v_settleType,p_firmID_B,v_settleprice_b,v_buypayout_ref,v_buyPayout,v_buyMargin,
                               p_firmID_S,v_settleprice_s,v_sellincom_ref,0,v_sellMargin,sysdate, sysdate,to_date(v_settleDate,'yyyy-MM-dd'),p_operator,v_buytax,v_taxIncluesive);
    --插入交收配对日志表
    insert into T_SettleMatchLog(id,Matchid,operator,Operatelog,Updatetime) values(seq_t_settlematchlog.nextval,p_matchId,p_operator,'添加交收配对：配对数量'||p_quantity||',买方：'||p_firmID_B||',价格：'||v_settleprice_b||',卖方:'||p_firmID_S||'价格：'||v_settleprice_s,sysdate);
     --配对成功后首先将税收付清 ,无论商品是否含税都会收费 ,收买方税费,如果不是履约，不进行税费收取
     if(p_result =1) then
       v_fundsflow:=fn_f_updatefundsfull(p_firmID_B,'15100',v_buytax,p_matchId,p_commodityId,null,null);
      insert into T_SettleMatchFundManage(Id,Matchid,Firmid,Summaryno,Amount,Operatedate,Commodityid) values(seq_t_settlematchfundmanage.nextval,p_matchId,p_firmID_B,'15100',v_buytax,sysdate,p_commodityId);
      --写配对日志
      insert into t_Settlematchlog(id,Matchid,Operator,Operatelog,Updatetime) values(seq_t_settlematchlog.nextval,p_matchId,'系统','收买方增值税,配对ID:'||p_matchId||' 金额:'||v_buytax,sysdate);
      --付卖方税费流水
       v_fundsflow:=fn_f_updatefundsfull(p_firmID_S,'15101',v_buytax,p_matchId,p_commodityId,null,null);
      insert into T_SettleMatchFundManage(Id,Matchid,Firmid,Summaryno,Amount,Operatedate,Commodityid) values(seq_t_settlematchfundmanage.nextval,p_matchId,p_firmID_S,'15101',v_buytax,sysdate,p_commodityId);
      insert into t_Settlematchlog(id,Matchid,Operator,Operatelog,Updatetime) values(seq_t_settlematchlog.nextval,p_matchId,'系统','付卖方增值税,配对ID:'||p_matchId||' 金额:'||v_buytax,sysdate);
      end if;
return 1;
end;
/

prompt
prompt Creating function FN_T_TRADEDAYEND
prompt ==================================
prompt
create or replace function FN_T_TradeDayEnd
return varchar2
/****
 * 交易日期变更结束，可多次做
 * 返回值 字符串
 * 成功 返回交易日期字符串，比如'2009-08-01'
 * '-1' 交易系统状态不是交易结算完成或财务结算完成
****/
as
	v_version varchar2(10):='1.0.2.2';
    v_CommodityID varchar2(16);
    v_FirmID varchar2(32);
    v_Margin         number(15,2):=0;
    v_Assure         number(15,2):=0;
    v_FloatLoss         number(15,2):=0;        --计算持仓明细的浮动盈亏合计，正值为浮盈，负为浮亏
    v_TradeDate date;
    v_Status number(2);
	v_FloatingLossComputeType number(2);
	v_LastFloatingLossComputeType number(2);
	v_TradeFlowType number(2);
	v_Balance    number(15,2);
	v_num            number(10);
	v_ret           number(5);

    --按商品写流水游标
    type cur_CmdtyDaily is ref cursor;
	v_CmdtyDaily cur_CmdtyDaily;
	v_sql varchar2(500);

  -- add by yukx 20100428 用于记录交易客户持仓合计表的冻结数量和抵顶冻结数量
  v_c_customerid varchar2(40);
  v_c_commodityid varchar2(16);
  v_c_bs_flag number(5);
  v_c_frozenqty number(10);
  v_c_gagefrozenqty number(10);
  type cue_qtyAboutCustonerhold is ref cursor;
  v_qtyAboutCustonerhold cue_qtyAboutCustonerhold;

begin
      -- 一、获取交易日期、浮亏计算方式
	  select TradeDate,Status into v_TradeDate,v_Status from T_SystemStatus;
	  --判断能否做日期变更
	  if(v_Status <> 10 and v_Status <> 3) then
	  	  rollback;
	  	  return '-1';
	  end if;

	  --二、延期交易结算
	  v_ret := FN_T_D_CloseProcess();

      select FloatingLossComputeType,TradeFlowType into v_FloatingLossComputeType,v_TradeFlowType from T_A_Market;
      v_ret := FN_T_TradeFlow(v_TradeFlowType);
      -- 二、退、收资金并写流水
        --1退上日结算保证金
        v_sql := 'select FirmID,CommodityID,sum(HoldMargin)-sum(HoldAssure),sum(HoldAssure) from T_H_FirmHoldSum where ClearDate =(select max(ClearDate) from T_H_Market) group by FirmID,CommodityID';
        open v_CmdtyDaily for v_sql;
        loop
            fetch v_CmdtyDaily into v_FirmID,v_CommodityID,v_Margin,v_Assure;
            exit when v_CmdtyDaily%NOTFOUND;
			--更新资金余额，并写退上日结算保证金流水
			if(v_Margin <> 0) then
	    		v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15003',v_Margin,null,v_CommodityID,v_Assure,null);
	    	end if;
        end loop;
        close v_CmdtyDaily;

        --2扣除当天结算保证金
        v_sql := 'select FirmID,CommodityID,sum(HoldMargin)-sum(HoldAssure),sum(HoldAssure) from T_FirmHoldSum group by FirmID,CommodityID';
        open v_CmdtyDaily for v_sql;
        loop
            fetch v_CmdtyDaily into v_FirmID,v_CommodityID,v_Margin,v_Assure;
            exit when v_CmdtyDaily%NOTFOUND;
			--更新资金余额，并写退上日结算保证金流水
			if(v_Margin <> 0) then
	    		v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15002',v_Margin,null,v_CommodityID,v_Assure,null);
	    	end if;
        end loop;
        close v_CmdtyDaily;

        --3如果存在上日交易的数据则退上日浮亏
	    select count(*) into v_num from T_H_Market where ClearDate =(select max(ClearDate) from T_H_Market);
	    if(v_num >0) then
	        --获取上一交易日的浮亏计算方式
	        select FloatingLossComputeType into v_LastFloatingLossComputeType from T_H_Market where ClearDate =(select max(ClearDate) from T_H_Market);
		    if(v_LastFloatingLossComputeType = 0) then     --商品分买卖
		        v_sql := 'select FirmID,CommodityID,sum(case when FloatingLoss>0 then 0 else -FloatingLoss end) from T_H_FirmHoldSum where ClearDate =(select max(ClearDate) from T_H_Market) group by FirmID,CommodityID';
		        open v_CmdtyDaily for v_sql;
		        loop
		            fetch v_CmdtyDaily into v_FirmID,v_CommodityID,v_FloatLoss;
		            exit when v_CmdtyDaily%NOTFOUND;
					--更新资金余额，并写退上日浮亏流水
					if(v_FloatLoss <> 0) then
			    		v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15005',v_FloatLoss,null,v_CommodityID,null,null);
			    	end if;
		        end loop;
		        close v_CmdtyDaily;
		    elsif(v_LastFloatingLossComputeType = 1) then  --商品不分买卖
		        v_sql := 'select FirmID,CommodityID,sum(FloatingLoss) from T_H_FirmHoldSum where ClearDate =(select max(ClearDate) from T_H_Market) group by FirmID,CommodityID';
		        open v_CmdtyDaily for v_sql;
		        loop
		            fetch v_CmdtyDaily into v_FirmID,v_CommodityID,v_FloatLoss;
		            exit when v_CmdtyDaily%NOTFOUND;
		            if(v_FloatLoss <= 0) then
		            	v_FloatLoss := -v_FloatLoss;
						--更新资金余额，并写退上日浮亏流水
						if(v_FloatLoss <> 0) then
				    		v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15005',v_FloatLoss,null,v_CommodityID,null,null);
				    	end if;
			        end if;
		        end loop;
		        close v_CmdtyDaily;
		    elsif(v_LastFloatingLossComputeType = 2) then  --不分商品
		        v_sql := 'select FirmID,case when sum(FloatingLoss) >0 then 0 else  -sum(FloatingLoss) end from T_H_FirmHoldSum where ClearDate =(select max(ClearDate) from T_H_Market) group by FirmID ';
		        open v_CmdtyDaily for v_sql;
		        loop
		            fetch v_CmdtyDaily into v_FirmID,v_FloatLoss;
		            exit when v_CmdtyDaily%NOTFOUND;
					--更新资金余额，并写退上日浮亏流水
					if(v_FloatLoss <> 0) then
			    		v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15016',v_FloatLoss,null,null,null,null);
			    	end if;
		        end loop;
		        close v_CmdtyDaily;
		    elsif(v_LastFloatingLossComputeType = 3 or v_LastFloatingLossComputeType = 4) then  --盘中算盈亏或不算盈亏
		        v_sql := 'select FirmID,-sum(FloatingLoss) from T_H_FirmHoldSum where ClearDate =(select max(ClearDate) from T_H_Market) group by FirmID ';
		        open v_CmdtyDaily for v_sql;
		        loop
		            fetch v_CmdtyDaily into v_FirmID,v_FloatLoss;
		            exit when v_CmdtyDaily%NOTFOUND;
					--更新资金余额，并写退上日浮亏流水
					if(v_FloatLoss <> 0) then
			    		v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15016',v_FloatLoss,null,null,null,null);
			    	end if;
		        end loop;
		        close v_CmdtyDaily;
		    end if;
	    end if;

        --4扣除当天结算浮亏
	    if(v_FloatingLossComputeType = 0) then     --商品分买卖
	        v_sql := 'select FirmID,CommodityID,sum(case when FloatingLoss>0 then 0 else -FloatingLoss end) from T_FirmHoldSum group by FirmID,CommodityID';
	        open v_CmdtyDaily for v_sql;
	        loop
	            fetch v_CmdtyDaily into v_FirmID,v_CommodityID,v_FloatLoss;
	            exit when v_CmdtyDaily%NOTFOUND;
				--更新资金余额，并写扣除当日浮亏流水
				if(v_FloatLoss <> 0) then
		    		v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15004',v_FloatLoss,null,v_CommodityID,null,null);
		    	end if;
	        end loop;
	        close v_CmdtyDaily;
	    elsif(v_FloatingLossComputeType = 1) then  --商品不分买卖
	        v_sql := 'select FirmID,CommodityID,sum(FloatingLoss) from T_FirmHoldSum group by FirmID,CommodityID';
	        open v_CmdtyDaily for v_sql;
	        loop
	            fetch v_CmdtyDaily into v_FirmID,v_CommodityID,v_FloatLoss;
	            exit when v_CmdtyDaily%NOTFOUND;
	            if(v_FloatLoss <= 0) then
	            	v_FloatLoss := -v_FloatLoss;
					--更新资金余额，并写扣除当日浮亏流水
					if(v_FloatLoss <> 0) then
			    		v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15004',v_FloatLoss,null,v_CommodityID,null,null);
			    	end if;
		        end if;
	        end loop;
	        close v_CmdtyDaily;
	    elsif(v_FloatingLossComputeType = 2) then  --不分商品
	        v_sql := 'select FirmID,case when sum(FloatingLoss) >0 then 0 else -sum(FloatingLoss) end from T_FirmHoldSum group by FirmID ';
	        open v_CmdtyDaily for v_sql;
	        loop
	            fetch v_CmdtyDaily into v_FirmID,v_FloatLoss;
	            exit when v_CmdtyDaily%NOTFOUND;
				--更新资金余额，并写扣除当日浮亏流水
				if(v_FloatLoss <> 0) then
		    		v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15015',v_FloatLoss,null,null,null,null);
		    	end if;
	        end loop;
	        close v_CmdtyDaily;
	    elsif(v_FloatingLossComputeType = 3 or v_FloatingLossComputeType = 4) then  --盘中算盈亏或不算盈亏
	        v_sql := 'select FirmID,-sum(FloatingLoss) from T_FirmHoldSum group by FirmID ';
	        open v_CmdtyDaily for v_sql;
	        loop
	            fetch v_CmdtyDaily into v_FirmID,v_FloatLoss;
	            exit when v_CmdtyDaily%NOTFOUND;
				--更新资金余额，并写扣除当日浮亏流水
				if(v_FloatLoss <> 0) then
		    		v_Balance := FN_F_UpdateFundsFull(v_FirmID,'15015',v_FloatLoss,null,null,null,null);
		    	end if;
	        end loop;
	        close v_CmdtyDaily;
	    end if;

        -- 三、更新交易商资金
        --1、更新虚拟资金为0,上日结算资金更新为当日结算资金，上日的交收保证金更新为当日的
        update T_Firm set VirtualFunds=0,ClearMargin=RuntimeMargin,ClearAssure=RuntimeAssure,ClearFL=RuntimeFL,ClearSettleMargin=RuntimeSettleMargin;
        --2、删除历史当日数据并导入历史交易商信息表
		delete from T_H_Firm where ClearDate=v_TradeDate;
        insert into T_H_Firm select v_TradeDate,a.* from T_Firm a;
        --3、更新当日历史交易商表中的上日的资金为上一交易日的当日资金
        --故意用sum求和(一个交易商只有一条记录)，解决更新时没有记录报错
	    update T_H_Firm a
        set (ClearFL,ClearMargin,ClearAssure,ClearSettleMargin) =
        (
          select nvl(sum(RuntimeFL),0),nvl(sum(RuntimeMargin),0),nvl(sum(RuntimeAssure),0),nvl(sum(RuntimeSettleMargin),0)
          from T_H_Firm
          where ClearDate =(select max(ClearDate) from T_H_Firm where ClearDate<v_TradeDate) and FirmID=a.FirmID
        )
        where a.ClearDate=v_TradeDate;

		-- 四、导入历史数据并删除当日数据
        --1、导入历史委托表并删除当日数据
        insert into T_H_Orders select v_TradeDate,a.* from T_Orders a;
        delete from T_Orders;
        --2、导入历史成交表并删除当日数据
        insert into T_H_Trade select v_TradeDate,a.* from T_Trade a;
        delete from T_Trade;

		-- 五、删除历史当日数据并导入当日历史数据
        --1、删除历史当日数据并导入历史市场参数表
		delete from T_H_Market where ClearDate=v_TradeDate;
        insert into T_H_Market select v_TradeDate,a.* from T_A_Market a;
	    --2、删除历史当日数据并导入历史行情
		delete from T_H_Quotation where ClearDate=v_TradeDate;
	    insert into T_H_Quotation select v_TradeDate,a.* from T_Quotation a;
        --3、删除历史当日数据并导入历史商品表
		delete from T_H_Commodity where ClearDate=v_TradeDate;
        insert into T_H_Commodity select v_TradeDate,a.* from T_Commodity a;
        --4、删除历史当日数据并导入历史持仓明细表
		delete from T_H_HoldPosition where ClearDate=v_TradeDate;
        insert into T_H_HoldPosition select v_TradeDate,a.* from T_HoldPosition a;
        --5、删除历史当日数据并导入历史交易客户持仓合计表
		delete from T_H_CustomerHoldSum where ClearDate=v_TradeDate;
        insert into T_H_CustomerHoldSum select v_TradeDate,a.* from T_CustomerHoldSum a;
        --6、删除历史当日数据并导入历史交易商持仓合计表
		delete from T_H_FirmHoldSum where ClearDate=v_TradeDate;
        insert into T_H_FirmHoldSum select v_TradeDate,a.* from T_FirmHoldSum a;
        --7、删除历史当日数据并导入历史交易商特殊保证金表
		delete from T_H_FirmMargin where ClearDate=v_TradeDate;
        insert into T_H_FirmMargin select v_TradeDate,a.* from T_A_FirmMargin a;
        --8、删除历史当日数据并导入历史交易商特殊手续费表
		delete from T_H_FirmFee where ClearDate=v_TradeDate;
        insert into T_H_FirmFee select v_TradeDate,a.* from T_A_FirmFee a;

		-- 六、释放冻结数据
	    --1、交易客户持仓合计表冻结数量清0
      -- mod by yukx 201040028 为支持提前交收冻结持仓注释下边sql
	    --update T_CustomerHoldSum set FrozenQty=0;
      -- mod by yukx 201040028 交易客户持仓合计表的冻结数量和抵顶冻结数量存在不为0的记录时，向系统日志表添加记录
      /**open v_qtyAboutCustonerhold for select customerid,commodityid,bs_flag,frozenqty,gagefrozenqty from t_customerholdsum order by customerid,commodityid,bs_flag;
      loop
        fetch v_qtyAboutCustonerhold into  v_c_customerid,v_c_commodityid,v_c_bs_flag,v_c_frozenqty,v_c_gagefrozenqty;
        exit when v_qtyAboutCustonerhold%NOTFOUND;
        if(v_c_frozenqty+v_c_gagefrozenqty>0) then
             insert into c_globallog_all(id,operator,operatetime,operatetype,operatecontent,operateresult,logtype)
              values(SEQ_C_GLOBALLOG.Nextval,'SYSTEM', sysdate,1502,'v_c_customerid='||v_c_customerid||',v_c_commodityid='||v_c_commodityid||',v_c_bs_flag='||v_c_bs_flag||',v_c_frozenqty='||v_c_frozenqty||',v_c_gagefrozenqty='||v_c_gagefrozenqty,2,3);
        end if;
      end loop;*/
      ---- add by tangzy 2010-06-21 交易客户持仓合计冻结数量修改，先清0，再根据提前交收申请的记录来更新冻结数量
      update T_CustomerHoldSum t
        set FrozenQty = 0,
            gagefrozenqty = 0;
      -- 计算买方冻结数量
      update T_CustomerHoldSum t
         set FrozenQty = nvl((select sum(quantity)
                               from t_e_applyaheadsettle
                              where customerid_b = t.customerid
                                and commodityid = t.commodityid
                                and status = 1),0)
       where bs_flag = 1;
      -- 计算卖方冻结数量
      update T_CustomerHoldSum t
         set FrozenQty = nvl((select sum(quantity) - sum(gageqty)
                               from t_e_applyaheadsettle
                              where customerid_s = t.customerid
                                and commodityid = t.commodityid
                                and status = 1),0),
            gagefrozenqty = nvl((select sum(gageqty)
                               from t_e_applyaheadsettle
                              where customerid_s = t.customerid
                                and commodityid = t.commodityid
                                and status = 1),0)
       where bs_flag = 2;
      ---- add by tangzy 2010-06-21 end

        --2、清空当日指定平仓冻结表
        delete from T_SpecFrozenHold;
        --3、释放所有冻结资金
		SP_F_UnFrozenAllFunds('15');

        -- 七、修改交易系统状态为财务结算完成
        update T_SystemStatus set TradeDate=v_TradeDate,Status=3,SectionID=null,Note=null,RecoverTime=null;
    --成功返回交易日期字符串
    return to_char(v_TradeDate,'yyyy-MM-dd');
end;
/

prompt
prompt Creating function FN_T_UNTRADETRANSFER
prompt ======================================
prompt
create or replace function FN_T_UnTradeTransfer(
    p_ID            number,         --非交易过户表ID
    p_CommodityID   varchar2,       --商品代码
    p_BS_Flag       number,         --买卖标志
    p_bCustomerID   varchar2,       --接收方交易客户ID
    p_sCustomerID   varchar2,       --过户方交易客户ID
    p_quantity      number          --过户数量

) return number
/****
 * 非交易过户
 * 返回值
 * 1 成功
 * -1  可平仓持仓数量不足
 * -5  交易状态不为闭市
 * -15 没有找到对应的持仓记录
****/
as
	   v_version               varchar2(10):='1.0.2.1';
     v_status                number(2);
     v_CommodityID           varchar2(16);
     v_CustomerID            varchar2(40);
     v_FirmID                varchar2(32);
     v_FirmID_b              varchar2(32);
     v_HoldQty               number;
     v_HoldSumQty            number(10);
     v_frozenQty             number(10);
     v_Margin                number(15,2):=0;
     v_Margin_one            number(15,2):=0;
	   v_Assure                number(15,2):=0;
	   v_Assure_one            number(15,2):=0;
     v_BS_Flag               number(2);
     v_Price                 number(15,2);
     v_ContractFactor        number(12,2);
     v_MarginPriceType       number(1);
     v_MarginPrice           number(15,2);  --计算成交保证金的价格
	   v_HoldFunds             number(15,2):=0;  --平仓时应退持仓金额，不包括抵顶的
	   v_CustomerHoldFunds     number(15,2):=0;  --平仓时应退持仓金额，包括抵顶的
     v_TradeDate             date;
	   v_A_HoldNo              number(15);
	   v_GageQty               number(10);
	   v_unCloseQty            number(10):=p_quantity; --未平数量，用于中间计算
	   --v_unCloseQtyGage        number(10):=p_GageQty; --未平数量，用于中间计算
	   v_tradedAmount          number(10):=0;  --成交数量
	   v_tradedAmountGage      number(10):=0;  --成交数量
	   v_F_FrozenFunds         number(15,2);
	   v_AtClearDate           date;
	   v_HoldTime              date;
	   --v_tmp_bs_flag           number(2);
  	 type c_HoldPosition is ref cursor;
  	 v_HoldPosition c_HoldPosition;
  	 v_sql                   varchar2(500);
  	 v_closeTodayHis         number(2);    --平今仓还是历史仓(0平今仓；1平历史仓)
  	 v_YesterBalancePrice    number(15,2);
  	 v_num                   number(10);
begin

     select status into v_status from t_systemstatus;
     if(v_status != 1) then --不等于闭市状态
         rollback;
         return -5;--只有闭市状态下才进行做非交易过户
     end if;

		 v_CustomerID := p_sCustomerID;  --过户方交易客户ID
	   v_CommodityID := p_CommodityID;
     v_BS_Flag := p_BS_Flag;
     /*if(v_BS_Flag=1) then  --持仓的买卖标志
         v_tmp_bs_flag:=2; --开仓的买卖标志
     else
         v_tmp_bs_flag:=1;
     end if;*/
     --锁住交易客户持仓合计，以防止并发更新
     begin
       select HoldQty,FrozenQty,GageQty
         into v_HoldSumQty, v_frozenQty, v_GageQty
         from T_CustomerHoldSum
        where CustomerID = v_CustomerID
          and CommodityID = v_CommodityID
          and bs_flag = v_BS_Flag for update;
     exception
         when NO_DATA_FOUND then
  	     return -15;--没有找到对应的持仓记录
     end;

     if(p_quantity > v_frozenQty) then--过户数量已冻结
         rollback;
         return -1;--可过户持仓数量不足
     end if;

     select Contractfactor,MarginPriceType,LastPrice
       into v_ContractFactor,v_MarginPriceType,v_YesterBalancePrice
       from T_Commodity where CommodityID=v_CommodityID;

     select TradeDate into v_TradeDate from T_SystemStatus;

     v_sql := 'select a.a_holdno,FirmID,price,(a.HoldQty-nvl(b.FrozenQty,0)),GageQty,HoldTime,AtClearDate,nvl(b.FrozenQty,0)' ||
              '  from T_holdposition a,(select A_HoldNo,nvl(sum(FrozenQty),0) FrozenQty from T_SpecFrozenHold group by A_HoldNo) b ' ||
              ' where (a.HoldQty+a.GageQty) > 0 and a.A_HoldNo=b.A_HoldNo(+) and CustomerID=''' || v_CustomerID || ''' and CommodityID =''' || v_CommodityID || ''' and bs_flag = ' || v_BS_Flag || ' order by a.A_HoldNo ';

	   --遍历持仓明细的数量并过滤掉指定平仓冻结的数量
     open v_HoldPosition for v_sql;
         loop
             fetch v_HoldPosition into v_a_holdno, v_FirmID, v_price, v_holdqty,v_GageQty,v_HoldTime,v_AtClearDate,v_frozenQty;
                exit when v_HoldPosition%NOTFOUND;
                --如果此笔持仓全部被指定平仓冻结且没有抵顶则指向下一条记录
                if(v_holdqty <> 0) then
	                  v_tradedAmount:=0;
	                  v_tradedAmountGage:=0;
	                  v_Margin_one:=0;
	                  v_Assure_one:=0;

                    --判断是平今仓还是平历史仓
        				    if(trunc(v_TradeDate) = trunc(v_AtClearDate)) then
        				        v_closeTodayHis := 0;
        				    else
        				    	  v_closeTodayHis := 1;
        				    end if;

        	          --1、计算应退款项
        	          if(v_holdqty > 0) then
        		            if(v_holdqty<=v_unCloseQty) then
        		                v_tradedAmount:=v_holdqty;
        		            else
        		                v_tradedAmount:=v_unCloseQty;
        		            end if;

                        --计算应退保证金价格，根据设置选择开仓价还是昨结算价来算
        						    if(v_MarginPriceType = 1) then
        					          v_MarginPrice := v_YesterBalancePrice;
        					      elsif(v_MarginPriceType = 2) then
        							      --判断是平今仓还是平历史仓
        							      if(v_closeTodayHis = 0) then  --平今仓
        								        v_MarginPrice := v_price;
        							      else  --平历史仓
        						            v_MarginPrice := v_YesterBalancePrice;
        						        end if;
        						    else  -- default type is 0
        							      v_MarginPrice := v_price;
        						    end if;

                        --计算应退保证金
        		            v_Margin_one := FN_T_ComputeMargin(v_FirmID,v_CommodityID,v_BS_Flag,v_tradedAmount,v_MarginPrice);
        		            if(v_Margin_one < 0) then
        		                Raise_application_error(-20040, 'computeMargin error');
        		            end if;
        				        --计算担保金
        				        v_Assure_one := FN_T_ComputeAssure(v_FirmID,v_CommodityID,v_BS_Flag,v_tradedAmount,v_MarginPrice);
        				        if(v_Assure_one < 0) then
        				            Raise_application_error(-20041, 'computeAssure error');
        				        end if;
        				        --保证金应加上担保金
        				        v_Margin_one := v_Margin_one + v_Assure_one;
        		            v_Margin:=v_Margin + v_Margin_one;
        		            v_Assure:=v_Assure + v_Assure_one;
        			          --计算应退持仓金额，不包括抵顶的
        			          v_HoldFunds := v_HoldFunds + v_tradedAmount*v_price*v_ContractFactor;
                    end if;

  	                --二级客户合计金额
  	                v_CustomerHoldFunds := v_CustomerHoldFunds + v_tradedAmount*v_price*v_ContractFactor;

	                  --更新持仓记录(过户方)
                    update T_holdposition
                       set holdqty = holdqty - v_tradedAmount,
                           HoldMargin=HoldMargin-v_Margin_one,
                           HoldAssure=HoldAssure-v_Assure_one
                     where a_holdno = v_a_holdno;

                     --获取过户方交易商
                     select FirmID into v_FirmID_b from T_Customer where CustomerID = p_bCustomerID;
                     --更新持仓记录（接收方）
                     --select FN_T_ComputeHoldNo(SEQ_T_HoldPosition.nextval) into v_A_HoldNo_s from dual;
                     insert into T_Holdposition
                         (a_holdno,                   a_tradeno, CommodityID,   CustomerID,    bs_flag,       price,         holdqty,        openqty,        holdtime, HoldMargin,   HoldAssure,   Firmid,     FloatingLoss, AtClearDate)
                     values
                         (SEQ_T_HoldPosition.nextval, -1,        p_CommodityID, p_bCustomerID, v_BS_Flag, v_MarginPrice, v_tradedAmount, v_tradedAmount, sysdate,  v_Margin_one, v_Assure_one, v_FirmID_b, 0,            v_TradeDate);

                     --更新交易客户持仓合计表（接收方）
                     select count(*) into v_num from T_CustomerHoldSum
                      where CustomerID = p_bCustomerID
                        and CommodityID = p_CommodityID
                        and bs_flag = v_BS_Flag;
                     if(v_num >0) then
                         update T_CustomerHoldSum
                            set holdQty = holdQty + v_tradedAmount,
                                holdFunds = holdFunds + v_Margin_one,
                                HoldMargin = HoldMargin + v_Margin_one,
                                HoldAssure = HoldAssure + v_Assure_one,
                                evenprice = (holdFunds + v_Margin_one)/((holdQty + GageQty + v_tradedAmount)*v_ContractFactor)
                          where CustomerID = p_bCustomerID
                            and CommodityID = p_CommodityID
                            and bs_flag = v_BS_Flag;
                     else
                         insert into T_CustomerHoldSum
                             (CustomerID,    CommodityID,   bs_flag,       holdQty,        holdFunds,    FloatingLoss, evenprice,     FrozenQty, HoldMargin,   HoldAssure,   FirmID)
                         values
                             (p_bCustomerID, p_CommodityID, v_BS_Flag, v_tradedAmount, v_Margin_one, 0,            v_MarginPrice, 0,         v_Margin_one, v_Assure_one, v_FirmID_b);
                     end if;

                    --更新买方交易商持仓合计表（接收方）
                    select count(*) into v_num from T_FirmHoldSum
                    where Firmid = v_FirmID_b
                      and CommodityID = p_CommodityID
                      and bs_flag = v_BS_Flag;
                    if(v_num >0) then
                        update T_FirmHoldSum
                           set holdQty = holdQty + v_tradedAmount,
                               holdFunds = holdFunds + v_Margin_one,
                               HoldMargin = HoldMargin + v_Margin_one,
                               HoldAssure = HoldAssure + v_Assure_one,
                               evenprice = (holdFunds + v_Margin_one)/((holdQty + v_tradedAmount + GageQty)*v_ContractFactor)
                         where Firmid = v_FirmID_b
                           and CommodityID = p_CommodityID
                           and bs_flag = v_BS_Flag;
                    else
                      insert into T_FirmHoldSum
                        (FirmID,     CommodityID,   bs_flag,       holdQty,        holdFunds,    FloatingLoss, evenprice,     HoldMargin,   HoldAssure)
                      values
                        (v_FirmID_b, p_CommodityID, v_BS_Flag, v_tradedAmount, v_Margin_one, 0,            v_MarginPrice, v_Margin_one, v_Assure_one);
                    end if;

                    --更新临时保证金和临时担保金（接收方）
                    update T_Firm
                       set runtimemargin = runtimemargin + v_Margin_one,
            		           RuntimeAssure = RuntimeAssure + v_Assure_one
                     where Firmid = v_FirmID_b;

                    --更新冻结资金，释放个人部分的保证金（接收方）
		                v_F_FrozenFunds := FN_F_UpdateFrozenFunds(v_FirmID_b,v_Margin_one-v_Assure_one,'15');

	                   --每次减少过户数量
                     v_unCloseQty:=v_unCloseQty - v_tradedAmount;

                end if;
                exit when v_unCloseQty=0;
            end loop;
        close v_HoldPosition;

        if(v_unCloseQty>0) then --平仓持仓数量大于可平仓持仓数量
            rollback;
            return -1;
        end if;

        --减少交易客户，交易商的持仓合计信息(过户方)
        v_num := FN_T_SubHoldSum(p_quantity,0,v_Margin,v_Assure,v_CommodityID,v_ContractFactor,v_BS_Flag,v_FirmID,v_HoldFunds,v_CustomerID,v_CustomerHoldFunds,0,p_quantity);

        --更新临时保证金和临时担保金（过户方）
        update T_Firm
           set runtimemargin = runtimemargin - v_Margin,
		           RuntimeAssure = RuntimeAssure - v_Assure
         where Firmid = v_FirmID;

        --更新冻结资金，释放个人部分的保证金（过户方）
		    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(v_FirmID,-(v_Margin-v_Assure),'15');

        --更新持仓冻结表
        delete T_Holdfrozen where Operation = to_char(p_ID) and frozentype = 2;

        --更新非交易过户表审核状态
        update T_UnTradeTransfer set Status=1,modifytime=sysdate where Transferid = p_ID;

    return 1;

end;
/

prompt
prompt Creating function FN_T_UPDATELASTPRICE
prompt ======================================
prompt
CREATE OR REPLACE FUNCTION FN_T_UpdateLastPrice
(
  p_CommodityID varchar2,   --商品代码
  p_Price number     --价格
)  return number
/***
 * 修改开盘指导价
 *
 * 返回值：成功返回1；
 ****/
as
  v_version varchar2(10):='1.0.4.4';
begin
	update T_Commodity set LastPrice=p_Price where CommodityID=p_CommodityID;
	update T_Quotation set Price=p_Price,YesterBalancePrice=p_Price,CreateTime=sysdate where CommodityID=p_CommodityID;
    return 1;
end;
/

prompt
prompt Creating function FN_T_UPDATEQUOTATION
prompt ======================================
prompt
CREATE OR REPLACE FUNCTION FN_T_UpdateQuotation
(
    p_CommodityID varchar2,   --商品代码
    p_YesterBalancePrice number, --昨结算价
    p_ClosePrice number,               --昨收盘价
    p_OpenPrice number,               --今开市价
    p_HighPrice number,               --最高价
    p_LowPrice number,               --最低价
    p_CurPrice number,               --最新价
    p_CurAmount number,               --现量(最新价所对应的成交量)
    p_OpenAmount number,               --开仓
	p_BuyOpenAmount number,               --买开仓
	p_SellOpenAmount number,               --卖开仓
    p_CloseAmount number,               --平仓
    p_BuyCloseAmount number,               --买平仓
    p_SellCloseAmount number,               --卖平仓
    p_ReserveCount number,               --订货量
    p_ReserveChange number,               --仓差
    p_Price number,                --结算价
    p_TotalMoney number,                --总成交额
    p_TotalAmount number,                --总成交量
    p_Spread number,                --涨跌
    p_BuyPrice1 number,                --买入价1
    p_SellPrice1 number,                --卖出价1
    p_BuyAmount1 number,                --申买量1
    p_SellAmount1 number,                --申卖量1
    p_BuyPrice2 number,                --买入价2
    p_SellPrice2 number ,               --卖出价2
    p_BuyAmount2 number ,               --申买量2
    p_SellAmount2 number,                --申卖量2
    p_BuyPrice3 number,                --买入价3
    p_SellPrice3 number,                --卖出价3
    p_BuyAmount3 number,                --申买量3
    p_SellAmount3 number ,               --申卖量3
    p_BuyPrice4 number ,               --买入价4
    p_SellPrice4 number,                --卖出价4
    p_BuyAmount4 number,                --申买量4
    p_SellAmount4 number,                --申卖量4
    p_BuyPrice5 number,                --买入价5
    p_SellPrice5 number,                --卖出价5
    p_BuyAmount5 number,                --申买量5
    p_SellAmount5 number,                --申卖量5
    p_OutAmount number,                --外盘
    p_InAmount number,                --内盘
    p_TradeCue number,                --交易提示
    p_NO number,                --计数字段
    p_CreateTime timestamp      --2009-09-21 增加更新时间，为null则取systimestamp(3)，将集合竞价行情时间更新成开市时间
) RETURN NUMBER
/****
 * 更新行情
 * 返回值
 * 1 成功
 * -100 失败
****/
as
	v_version varchar2(10):='1.0.0.9';
    v_num   number(10);
    v_errorcode number;
    v_errormsg  varchar2(200);
begin
    select count(*) into v_num from T_Quotation where CommodityID = p_CommodityID;
    if(v_num >0) then
        update T_Quotation set YesterBalancePrice=p_YesterBalancePrice,ClosePrice=p_ClosePrice,OpenPrice=p_OpenPrice,HighPrice=p_HighPrice,
        LowPrice=p_LowPrice,CurPrice=p_CurPrice,CurAmount=p_CurAmount,OpenAmount=p_OpenAmount,BuyOpenAmount=p_BuyOpenAmount,SellOpenAmount=p_SellOpenAmount,CloseAmount=p_CloseAmount,BuyCloseAmount=p_BuyCloseAmount,SellCloseAmount=p_SellCloseAmount,
        ReserveCount=p_ReserveCount,ReserveChange=p_ReserveChange,Price=p_Price,TotalMoney=p_TotalMoney,TotalAmount=p_TotalAmount,Spread=p_Spread,BuyPrice1=p_BuyPrice1,SellPrice1=p_SellPrice1
        ,BuyAmount1=p_BuyAmount1,SellAmount1=p_SellAmount1,BuyPrice2=p_BuyPrice2,SellPrice2=p_SellPrice2,BuyAmount2=p_BuyAmount2,SellAmount2=p_SellAmount2,BuyPrice3=p_BuyPrice3,SellPrice3=p_SellPrice3,BuyAmount3=p_BuyAmount3,SellAmount3=p_SellAmount3
        ,BuyPrice4=p_BuyPrice4,SellPrice4=p_SellPrice4,BuyAmount4=p_BuyAmount4,SellAmount4=p_SellAmount4,BuyPrice5=p_BuyPrice5,SellPrice5=p_SellPrice5,BuyAmount5=p_BuyAmount5,SellAmount5=p_SellAmount5,OutAmount=p_OutAmount,InAmount=p_InAmount
        ,TradeCue=p_TradeCue,NO=p_NO,CreateTime=decode(p_CreateTime,null,systimestamp(3),p_CreateTime)
        where CommodityID = p_CommodityID;
    else
        insert into T_Quotation(CommodityID,YesterBalancePrice,ClosePrice,OpenPrice,HighPrice,
        LowPrice,CurPrice,CurAmount,OpenAmount,BuyOpenAmount,SellOpenAmount,CloseAmount,BuyCloseAmount,SellCloseAmount,ReserveCount,ReserveChange,Price,TotalMoney,TotalAmount,Spread,
        BuyPrice1,SellPrice1,BuyAmount1,SellAmount1,BuyPrice2,SellPrice2,BuyAmount2,SellAmount2,BuyPrice3,SellPrice3,
        BuyAmount3,SellAmount3,BuyPrice4,SellPrice4,BuyAmount4,SellAmount4,BuyPrice5,SellPrice5,BuyAmount5,SellAmount5,
        OutAmount,InAmount,TradeCue,NO,CreateTime)
        values(p_CommodityID,p_YesterBalancePrice,p_ClosePrice,p_OpenPrice,p_HighPrice,p_LowPrice,p_CurPrice,p_CurAmount,p_OpenAmount,p_BuyOpenAmount,p_SellOpenAmount,p_CloseAmount,p_BuyCloseAmount,p_SellCloseAmount,p_ReserveCount,p_ReserveChange,p_Price,p_TotalMoney,p_TotalAmount,p_Spread,p_BuyPrice1,
        p_SellPrice1,p_BuyAmount1,p_SellAmount1,p_BuyPrice2,p_SellPrice2,p_BuyAmount2,p_SellAmount2,p_BuyPrice3,p_SellPrice3,p_BuyAmount3,
        p_SellAmount3,p_BuyPrice4,p_SellPrice4,p_BuyAmount4,p_SellAmount4,p_BuyPrice5,p_SellPrice5,p_BuyAmount5,p_SellAmount5,
        p_OutAmount,p_InAmount,p_TradeCue,p_NO,decode(p_CreateTime,null,systimestamp(3),p_CreateTime));
    end if;
    commit;
    return 1;
exception
    when OTHERS then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_UpdateQuotation',v_errorcode,v_errormsg);
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_T_UPDATERUNTIMESETTLEMARGIN
prompt ================================================
prompt
CREATE OR REPLACE FUNCTION FN_T_UpdateRuntimeSettleMargin
(
  p_FirmID varchar2,   --交易商代码
  p_RuntimeSettleMargin number     --发生额（正值增加，负值减少）
)  return number
/***
 * 更新交易商当日交收保证金
 * version 1.0.0.6
 *
 * 返回值：交易商当日交收保证金
 ****/
is
  v_RuntimeSettleMargin number(15,2);
begin
  update T_Firm set RuntimeSettleMargin=RuntimeSettleMargin + p_RuntimeSettleMargin where FirmID=p_FirmID
  returning RuntimeSettleMargin into v_RuntimeSettleMargin;
  if(SQL%ROWCOUNT = 0) then
    Raise_application_error(-20099, 'FirmID not existed !'); --不存在的交易商代码
  end if;

  return v_RuntimeSettleMargin;
end;
/

prompt
prompt Creating function FN_T_UPDATETRADE
prompt ==================================
prompt
create or replace function FN_T_UpdateTrade(
    p_A_OrderNo     number,  --委托单号
    p_M_TradeNo     number,  --撮合成交号
    p_Price         number,  --成交价
    p_Quantity      number,   --成交数量
    p_M_TradeNo_Opp     number,  --对方撮合成交号
    p_A_OrderNo_Other     number,  --另外一方委托单号
    p_M_TradeNo_Other     number,  --另外一方撮合成交号
    p_Price_Other         number,  --另外一方成交价
    p_Quantity_Other      number,   --另外一方成交数量
  p_M_TradeNo_Opp_Other     number  --另外一方对方撮合成交号
) return number
/****
 * 更新成交回报,根据委托类型分别调用开平仓存储，如果成功则调用计算浮亏函数
 * 返回值
 * 1 成功
 * 2 已处理过
 * -1 成交数量大于未成交数量
 * -2 成交数量大于冻结数量
 * -3 平仓成交数量大于持仓数量
 * -100 其它错误
 *开仓平仓，增加对手交易商ID mod by liuchao 20130603
****/
as
    v_version varchar2(10):='1.0.2.1';
    v_CommodityID varchar2(16);
    v_CommodityID_opp varchar2(16);
    v_FirmID     varchar2(32);
    v_FirmID_Other     varchar2(32);
    v_TraderID       varchar2(40);
    v_TraderID_opp       varchar2(40);
    v_bs_flag        number(2);
    v_bs_flag_opp        number(2);
    v_status         number(2);
    v_status_opp         number(2);
    v_orderQty       number(10);
    v_orderQty_opp       number(10);
    v_orderPrice          number(15,2);
    v_orderPrice_opp          number(15,2);
    v_orderTradeQty       number(10);
    v_orderTradeQty_opp       number(10);
    v_frozenfunds    number(15,2);
    v_frozenfunds_opp    number(15,2);
    v_unfrozenfunds  number(15,2);
    v_unfrozenfunds_opp  number(15,2);
    v_CustomerID        varchar2(40);
    v_CustomerID_opp        varchar2(40);
    v_OrderType      number(2);
    v_OrderType_opp      number(2);
    v_closeMode      number(2);
    v_closeMode_opp      number(2);
    v_specPrice      number(15,2);
    v_specPrice_opp      number(15,2);
    v_timeFlag       number(1);
    v_timeFlag_opp       number(1);
    v_CloseFlag      number(1);
    v_CloseFlag_opp      number(1);
    v_contractFactor T_Commodity.contractfactor%type;
    v_MarginPriceType         number(1);     --计算成交保证金结算价类型 0:实时和闭市时都按开仓价；1:实时按昨结算价，闭市按当日结算价
    v_marginAlgr         number(2);
    v_marginRate_b         number(10,4);
    v_marginRate_s         number(10,4);
    v_marginAssure_b         number(10,4);
    v_marginAssure_s         number(10,4);
    v_feeAlgr       number(2);
    v_feeRate_b         number(15,9);
    v_feeRate_s         number(15,9);
    v_TodayCloseFeeRate_B         number(15,9);
    v_TodayCloseFeeRate_S         number(15,9);
    v_HistoryCloseFeeRate_B         number(15,9);
    v_HistoryCloseFeeRate_S         number(15,9);
    v_ForceCloseFeeAlgr       number(2);
    v_ForceCloseFeeRate_B         number(15,9);
    v_ForceCloseFeeRate_S         number(15,9);
    v_AddedTaxFactor T_Commodity.AddedTaxFactor%type;--增值税率系数=AddedTax/(1+AddedTax)
    v_YesterBalancePrice    number(15,2);
    v_num            number(10);
    v_ret            number(4);
    v_FL_ret            number(4);
    v_errorcode      number;
    v_errormsg       varchar2(200);
    v_GageMode number(2);--抵顶模式，分0全抵顶和1半抵顶，半抵顶时要计算浮亏，2009-10-14
    v_CloseAlgr        number(2);    --平仓算法(0先开先平；1后开先平；2持仓均价平仓)
    v_TradeDate date;
    v_BillTradeType_one number(2);   --仓单交易类型 0：正常默认；  1：卖仓单；    3：抵顶转让  mod by yukx 20100428
    v_BillTradeType_two number(2);   --仓单交易类型 0：正常默认；  1：卖仓单；    3：抵顶转让  mod by yukx 20100428
begin
  --判断是否已处理过
   -- select count(*) into v_num from T_Trade where m_tradeno in(p_M_TradeNo,p_M_TradeNo_Other);
    if(v_num >0) then
        rollback;
        return 2;  --已处理过
    end if;
    --获取平仓算法,抵顶模式
    select CloseAlgr,GageMode into v_CloseAlgr,v_GageMode from T_A_Market;
    --取结算日期
  select TradeDate into v_TradeDate from T_SystemStatus;
    --
    select CommodityID,   Firmid,  TraderID, bs_flag, status, quantity, price, tradeqty, frozenfunds, unfrozenfunds,CustomerID,OrderType,closeMode,specPrice,timeFlag,CloseFlag,billTradeType
    into v_CommodityID,v_FirmID,v_TraderID,v_bs_flag,v_status,v_orderQty,v_orderPrice,v_orderTradeQty,v_frozenfunds,v_unfrozenfunds,v_CustomerID,v_OrderType,v_closeMode,v_specPrice,v_timeFlag,v_CloseFlag,v_BillTradeType_one
    from T_Orders
    where A_OrderNo = p_A_OrderNo for update;
    --查找另一方委托信息，委托单号和交易商不一样
    --将所查询的数据全部换成不同的变量  liuchao 20130603
      select CommodityID,   Firmid,  TraderID, bs_flag, status, quantity, price, tradeqty, frozenfunds, unfrozenfunds,CustomerID,OrderType,closeMode,specPrice,timeFlag,CloseFlag,billTradeType
      into v_CommodityID_opp,v_FirmID_Other,v_TraderID_opp,v_bs_flag_opp,v_status_opp,v_orderQty_opp,v_orderPrice_opp,v_orderTradeQty_opp,v_frozenfunds_opp,v_unfrozenfunds_opp,v_CustomerID_opp,v_OrderType_opp,v_closeMode_opp,v_specPrice_opp,v_timeFlag_opp,v_CloseFlag_opp,v_BillTradeType_two
      from T_Orders
      where A_OrderNo = p_A_OrderNo_Other for update;
    --更新一方成交
    --获取商品信息
    select contractfactor,MarginPriceType,marginalgr,marginrate_b,marginrate_s,marginAssure_b,marginAssure_s,feealgr,feerate_b,feerate_s,TodayCloseFeeRate_B,TodayCloseFeeRate_S,HistoryCloseFeeRate_B,HistoryCloseFeeRate_S,ForceCloseFeeAlgr,ForceCloseFeeRate_B,ForceCloseFeeRate_S,AddedTaxFactor,LastPrice
    into v_contractFactor,v_MarginPriceType,v_marginAlgr,v_marginRate_b,v_marginRate_s,v_marginAssure_b,v_marginAssure_s,v_feeAlgr,v_feeRate_b,v_feeRate_s,v_TodayCloseFeeRate_B,v_TodayCloseFeeRate_S,v_HistoryCloseFeeRate_B,v_HistoryCloseFeeRate_S,v_ForceCloseFeeAlgr,v_ForceCloseFeeRate_B,v_ForceCloseFeeRate_S,v_AddedTaxFactor,v_YesterBalancePrice
    from T_Commodity where CommodityID=v_CommodityID;
    --获取特户的交易保证金，保证金算法
    begin
        select marginalgr,marginrate_b,marginrate_s,marginAssure_b,marginAssure_s
      into v_marginAlgr,v_marginRate_b,v_marginRate_s,v_marginAssure_b,v_marginAssure_s
        from T_A_FirmMargin
        where FirmID=v_FirmID and CommodityID=v_CommodityID;
    exception
        when NO_DATA_FOUND then
            null;
    end;

    --获取交易商对应套餐手续费系数，手续费算法
    begin
        select feealgr,feerate_b,feerate_s,TodayCloseFeeRate_B,TodayCloseFeeRate_S,HistoryCloseFeeRate_B,HistoryCloseFeeRate_S,ForceCloseFeeAlgr,ForceCloseFeeRate_B,ForceCloseFeeRate_S
      into v_feeAlgr,v_feeRate_b,v_feeRate_s,v_TodayCloseFeeRate_B,v_TodayCloseFeeRate_S,v_HistoryCloseFeeRate_B,v_HistoryCloseFeeRate_S,v_ForceCloseFeeAlgr,v_ForceCloseFeeRate_B,v_ForceCloseFeeRate_S
        from T_A_Tariff
        where TariffID=(select TariffID from t_firm where FirmID=v_FirmID) and CommodityID=v_CommodityID;
    exception
        when NO_DATA_FOUND then
            null;
    end;

    --获取特户的交易手续费，手续费算法
    begin
        select feealgr,feerate_b,feerate_s,TodayCloseFeeRate_B,TodayCloseFeeRate_S,HistoryCloseFeeRate_B,HistoryCloseFeeRate_S,ForceCloseFeeAlgr,ForceCloseFeeRate_B,ForceCloseFeeRate_S
      into v_feeAlgr,v_feeRate_b,v_feeRate_s,v_TodayCloseFeeRate_B,v_TodayCloseFeeRate_S,v_HistoryCloseFeeRate_B,v_HistoryCloseFeeRate_S,v_ForceCloseFeeAlgr,v_ForceCloseFeeRate_B,v_ForceCloseFeeRate_S
        from T_A_FirmFee
        where FirmID=v_FirmID and CommodityID=v_CommodityID;
    exception
        when NO_DATA_FOUND then
            null;
    end;

  if(v_OrderType = 1) then --开仓 --增加对手交易商ID  mod by liuchao 20130603
      if(v_BillTradeType_one=1) then --卖仓单 modify by yukx 20100421
           v_ret := FN_T_SellBillTrade(p_A_OrderNo,p_M_TradeNo,p_Price,p_Quantity,p_M_TradeNo_Opp,v_CommodityID,v_FirmID,v_TraderID,v_bs_flag,v_status,v_orderQty,v_orderPrice,v_orderTradeQty,v_frozenfunds,v_unfrozenfunds,v_CustomerID,v_OrderType,v_contractFactor,v_MarginPriceType,v_marginAlgr,v_marginRate_b,v_marginRate_s,v_marginAssure_b,v_marginAssure_s,v_feeAlgr,v_feeRate_b,v_feeRate_s,v_YesterBalancePrice,v_GageMode,v_TradeDate,v_FirmID_Other);
      else
           v_ret := FN_T_OpenTrade(p_A_OrderNo,p_M_TradeNo,p_Price,p_Quantity,p_M_TradeNo_Opp,v_CommodityID,v_FirmID,v_TraderID,v_bs_flag,v_status,v_orderQty,v_orderPrice,v_orderTradeQty,v_frozenfunds,v_unfrozenfunds,v_CustomerID,v_OrderType,v_contractFactor,v_MarginPriceType,v_marginAlgr,v_marginRate_b,v_marginRate_s,v_marginAssure_b,v_marginAssure_s,v_feeAlgr,v_feeRate_b,v_feeRate_s,v_YesterBalancePrice,v_GageMode,v_TradeDate,v_FirmID_Other);
      end if;
  elsif(v_OrderType = 2) then  --平仓
      if(v_BillTradeType_one=2) then --抵顶转让 modify by yukx 20100421
           v_ret := FN_T_GageCloseTrade(p_A_OrderNo,p_M_TradeNo,p_Price,p_Quantity,p_M_TradeNo_Opp,v_CommodityID,v_FirmID,v_TraderID,v_bs_flag,v_status,v_orderQty,v_orderTradeQty,v_CustomerID,v_OrderType,v_closeMode,v_specPrice,v_timeFlag,v_CloseFlag,v_contractFactor,v_MarginPriceType,v_marginAlgr,v_marginRate_b,v_marginRate_s,v_marginAssure_b,v_marginAssure_s,v_feeAlgr,v_feeRate_b,v_feeRate_s,v_TodayCloseFeeRate_B,v_TodayCloseFeeRate_S,v_HistoryCloseFeeRate_B,v_HistoryCloseFeeRate_S,v_ForceCloseFeeAlgr,v_ForceCloseFeeRate_B,v_ForceCloseFeeRate_S,v_YesterBalancePrice,v_AddedTaxFactor,v_GageMode,v_CloseAlgr,v_TradeDate,v_FirmID_Other);
      else
           v_ret := FN_T_CloseTrade(p_A_OrderNo,p_M_TradeNo,p_Price,p_Quantity,p_M_TradeNo_Opp,v_CommodityID,v_FirmID,v_TraderID,v_bs_flag,v_status,v_orderQty,v_orderTradeQty,v_CustomerID,v_OrderType,v_closeMode,v_specPrice,v_timeFlag,v_CloseFlag,v_contractFactor,v_MarginPriceType,v_marginAlgr,v_marginRate_b,v_marginRate_s,v_marginAssure_b,v_marginAssure_s,v_feeAlgr,v_feeRate_b,v_feeRate_s,v_TodayCloseFeeRate_B,v_TodayCloseFeeRate_S,v_HistoryCloseFeeRate_B,v_HistoryCloseFeeRate_S,v_ForceCloseFeeAlgr,v_ForceCloseFeeRate_B,v_ForceCloseFeeRate_S,v_YesterBalancePrice,v_AddedTaxFactor,v_GageMode,v_CloseAlgr,v_TradeDate,v_FirmID_Other);
      end if;
  end if;
  --成功后更新另一方成交
  if(v_ret = 1) then
      --获取商品信息
      select contractfactor,MarginPriceType,marginalgr,marginrate_b,marginrate_s,marginAssure_b,marginAssure_s,feealgr,feerate_b,feerate_s,TodayCloseFeeRate_B,TodayCloseFeeRate_S,HistoryCloseFeeRate_B,HistoryCloseFeeRate_S,ForceCloseFeeAlgr,ForceCloseFeeRate_B,ForceCloseFeeRate_S,AddedTaxFactor,LastPrice
      into v_contractFactor,v_MarginPriceType,v_marginAlgr,v_marginRate_b,v_marginRate_s,v_marginAssure_b,v_marginAssure_s,v_feeAlgr,v_feeRate_b,v_feeRate_s,v_TodayCloseFeeRate_B,v_TodayCloseFeeRate_S,v_HistoryCloseFeeRate_B,v_HistoryCloseFeeRate_S,v_ForceCloseFeeAlgr,v_ForceCloseFeeRate_B,v_ForceCloseFeeRate_S,v_AddedTaxFactor,v_YesterBalancePrice
      from T_Commodity where CommodityID=v_CommodityID_opp;
      --获取特户的交易保证金，保证金算法
      begin
          select marginalgr,marginrate_b,marginrate_s,marginAssure_b,marginAssure_s
        into v_marginAlgr,v_marginRate_b,v_marginRate_s,v_marginAssure_b,v_marginAssure_s
          from T_A_FirmMargin
          where FirmID=v_FirmID_Other and CommodityID=v_CommodityID_opp;
      exception
          when NO_DATA_FOUND then
              null;
      end;

      --获取交易商对应套餐手续费系数，手续费算法
      begin
    select feealgr,feerate_b,feerate_s,TodayCloseFeeRate_B,TodayCloseFeeRate_S,HistoryCloseFeeRate_B,HistoryCloseFeeRate_S,ForceCloseFeeAlgr,ForceCloseFeeRate_B,ForceCloseFeeRate_S
    into v_feeAlgr,v_feeRate_b,v_feeRate_s,v_TodayCloseFeeRate_B,v_TodayCloseFeeRate_S,v_HistoryCloseFeeRate_B,v_HistoryCloseFeeRate_S,v_ForceCloseFeeAlgr,v_ForceCloseFeeRate_B,v_ForceCloseFeeRate_S
    from T_A_Tariff
    where TariffID=(select TariffID from t_firm where FirmID=v_FirmID_Other) and CommodityID=v_CommodityID_opp;
      exception
    when NO_DATA_FOUND then
        null;
      end;

      --获取特户的交易手续费，手续费算法
      begin
          select feealgr,feerate_b,feerate_s,TodayCloseFeeRate_B,TodayCloseFeeRate_S,HistoryCloseFeeRate_B,HistoryCloseFeeRate_S,ForceCloseFeeAlgr,ForceCloseFeeRate_B,ForceCloseFeeRate_S
        into v_feeAlgr,v_feeRate_b,v_feeRate_s,v_TodayCloseFeeRate_B,v_TodayCloseFeeRate_S,v_HistoryCloseFeeRate_B,v_HistoryCloseFeeRate_S,v_ForceCloseFeeAlgr,v_ForceCloseFeeRate_B,v_ForceCloseFeeRate_S
          from T_A_FirmFee
          where FirmID=v_FirmID_Other and CommodityID=v_CommodityID_opp;
      exception
          when NO_DATA_FOUND then
              null;
      end;
    if(v_OrderType_opp = 1) then --开仓   --增加对手交易商ID  mod by liuchao 20130603
       if(v_BillTradeType_two=1) then --卖仓单 modify by yukx 20100421
           v_ret := FN_T_SellBillTrade(p_A_OrderNo_Other,p_M_TradeNo_Other,p_Price_Other,p_Quantity_Other,p_M_TradeNo_Opp_Other,v_CommodityID_opp,v_FirmID_Other,v_TraderID_opp,v_bs_flag_opp,v_status_opp,v_orderQty_opp,v_orderPrice_opp,v_orderTradeQty_opp,v_frozenfunds_opp,v_unfrozenfunds_opp,v_CustomerID_opp,v_OrderType_opp,v_contractFactor,v_MarginPriceType,v_marginAlgr,v_marginRate_b,v_marginRate_s,v_marginAssure_b,v_marginAssure_s,v_feeAlgr,v_feeRate_b,v_feeRate_s,v_YesterBalancePrice,v_GageMode,v_TradeDate,v_FirmID);
       else
           v_ret := FN_T_OpenTrade(p_A_OrderNo_Other,p_M_TradeNo_Other,p_Price_Other,p_Quantity_Other,p_M_TradeNo_Opp_Other,v_CommodityID_opp,v_FirmID_Other,v_TraderID_opp,v_bs_flag_opp,v_status_opp,v_orderQty_opp,v_orderPrice_opp,v_orderTradeQty_opp,v_frozenfunds_opp,v_unfrozenfunds_opp,v_CustomerID_opp,v_OrderType_opp,v_contractFactor,v_MarginPriceType,v_marginAlgr,v_marginRate_b,v_marginRate_s,v_marginAssure_b,v_marginAssure_s,v_feeAlgr,v_feeRate_b,v_feeRate_s,v_YesterBalancePrice,v_GageMode,v_TradeDate,v_FirmID);
       end if;
    elsif(v_OrderType_opp = 2) then  --平仓
      if(v_BillTradeType_two=2) then --抵顶转让 modify by yukx 20100421
          v_ret := FN_T_GageCloseTrade(p_A_OrderNo_Other,p_M_TradeNo_Other,p_Price_Other,p_Quantity_Other,p_M_TradeNo_Opp_Other,v_CommodityID_opp,v_FirmID_Other,v_TraderID_opp,v_bs_flag_opp,v_status_opp,v_orderQty_opp,v_orderTradeQty_opp,v_CustomerID_opp,v_OrderType_opp,v_closeMode_opp,v_specPrice_opp,v_timeFlag_opp,v_CloseFlag_opp,v_contractFactor,v_MarginPriceType,v_marginAlgr,v_marginRate_b,v_marginRate_s,v_marginAssure_b,v_marginAssure_s,v_feeAlgr,v_feeRate_b,v_feeRate_s,v_TodayCloseFeeRate_B,v_TodayCloseFeeRate_S,v_HistoryCloseFeeRate_B,v_HistoryCloseFeeRate_S,v_ForceCloseFeeAlgr,v_ForceCloseFeeRate_B,v_ForceCloseFeeRate_S,v_YesterBalancePrice,v_AddedTaxFactor,v_GageMode,v_CloseAlgr,v_TradeDate,v_FirmID);
      else
          v_ret := FN_T_CloseTrade(p_A_OrderNo_Other,p_M_TradeNo_Other,p_Price_Other,p_Quantity_Other,p_M_TradeNo_Opp_Other,v_CommodityID_opp,v_FirmID_Other,v_TraderID_opp,v_bs_flag_opp,v_status_opp,v_orderQty_opp,v_orderTradeQty_opp,v_CustomerID_opp,v_OrderType_opp,v_closeMode_opp,v_specPrice_opp,v_timeFlag_opp,v_CloseFlag_opp,v_contractFactor,v_MarginPriceType,v_marginAlgr,v_marginRate_b,v_marginRate_s,v_marginAssure_b,v_marginAssure_s,v_feeAlgr,v_feeRate_b,v_feeRate_s,v_TodayCloseFeeRate_B,v_TodayCloseFeeRate_S,v_HistoryCloseFeeRate_B,v_HistoryCloseFeeRate_S,v_ForceCloseFeeAlgr,v_ForceCloseFeeRate_B,v_ForceCloseFeeRate_S,v_YesterBalancePrice,v_AddedTaxFactor,v_GageMode,v_CloseAlgr,v_TradeDate,v_FirmID);
      end if;
    end if;
    --更新双方成交成功后分别计算双方的浮亏，由浮亏计算线程去轮询计算
    if(v_ret = 1) then
        commit;
      return v_ret;
    end if;
  end if;
  rollback;--双方没有成功要回滚
    return v_ret;
exception
    when OTHERS then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_UpdateTrade',v_errorcode,v_errormsg);
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_T_WITHDRAW
prompt ===============================
prompt
create or replace function FN_T_Withdraw(
    p_WithdrawerID       varchar2,  --撤单员ID
    p_A_OrderNo_W   number,             --被撤单委托单号
    p_WithdrawType  number,              --撤单类型 1:委托撤单；4：闭市时自动撤单
    p_Quantity      number              --撤单成功数量
) return number
/****
 * 撤单
 * 1、如果是自动撤单则撤单员和撤单数量为null
 * 返回值
 * 1 成功
 * 2 已处理过
 * -100 其它错误
****/
as
    v_version varchar2(10):='1.0.0.1';
    v_a_orderno_w    number(15);
    v_status         number(2);
    v_CommodityID varchar2(16);
    v_FirmID     varchar2(32);
    v_CustomerID     varchar2(40);
    v_bs_flag        number(2);
    v_ordertype      number(2);
    v_quantity       number(10);
    v_price          number(15,2);
    v_tradeqty       number(10);
    v_frozenfunds    number(15,2);
    v_unfrozenfunds  number(15,2);
    v_closeMode      number(2);
    v_specPrice      number(15,2);
    v_timeFlag       number(1);
    v_to_unfrozenF   number(15,2);
    v_Margin         number(15,2);   --应收保证金
    v_Fee            number(15,2);   --应收费用
    v_FrozenQty      number(10);
    v_quantity_wd    number(10);
    v_unCloseQty     number(10); --未撤单数量，用于中间计算
    v_tradedAmount   number(10):=0;  --成交数量
    v_id       number(15);
    v_F_FrozenFunds   number(15,2);   --交易商冻结资金
    v_contractFactor T_Commodity.contractfactor%type;
    v_MarginPriceType         number(1);     --计算成交保证金结算价类型 0:实时和闭市时都按开仓价；1:实时按昨结算价，闭市按当日结算价
    v_marginAlgr         number(2);
    v_marginRate_b         number(10,4);
    v_marginRate_s         number(10,4);
    v_feeAlgr       number(2);
    v_feeRate_b         number(15,9);
    v_feeRate_s         number(15,9);
    v_YesterBalancePrice    number(15,2);
    v_BillTradeType number(1); --zhengxuan 仓单交易类型
    v_errorcode number;
    v_errormsg  varchar2(200);
    --当日指定平仓冻结表游标,用来删除冻结的持仓
    cursor c_T_SpecFrozenHold(c_A_OrderNo number) is select ID,FrozenQty from T_SpecFrozenHold where A_OrderNo=c_A_OrderNo order by ID;
begin
    v_a_orderno_w := p_A_OrderNo_W;
    --获取被撤单信息
    select CommodityID, Firmid, bs_flag, ordertype, status, quantity, price, tradeqty, frozenfunds, unfrozenfunds,closeMode,CustomerID,BillTradeType
    into v_CommodityID, v_Firmid, v_bs_flag, v_ordertype, v_status, v_quantity, v_price, v_tradeqty, v_frozenfunds, v_unfrozenfunds,v_closeMode,v_CustomerID,v_BillTradeType
    from T_Orders
    where a_orderno = v_a_orderno_w for update;

    if(v_status in (3,5,6)) then
        rollback;
        return 2;  --已处理过
    end if;

    if(p_WithdrawType = 4) then --自动撤单
        v_quantity_wd := v_quantity - v_tradeqty;
    else
        v_quantity_wd := p_Quantity;
    end if;
    if(v_ordertype=1) then    --开仓
        if(v_quantity - v_tradeQty = v_quantity_wd) then
            v_to_unfrozenF := v_frozenfunds - v_unfrozenfunds;
        else
            --获取商品信息
            select contractfactor,MarginPriceType,marginalgr,marginrate_b,marginrate_s,feealgr,feerate_b,feerate_s,LastPrice
            into v_contractFactor,v_MarginPriceType,v_marginAlgr,v_marginRate_b,v_marginRate_s,v_feeAlgr,v_feeRate_b,v_feeRate_s,v_YesterBalancePrice
            from T_Commodity where CommodityID=v_CommodityID;
            if(v_MarginPriceType = 1) then
                v_price := v_YesterBalancePrice;
            end if;
            --获取特户的交易保证金，保证金算法
            begin
                select marginalgr,marginrate_b,marginrate_s
                into v_marginAlgr,v_marginRate_b,v_marginRate_s
                from T_A_FirmMargin
                where FirmID=v_FirmID and CommodityID=v_CommodityID;
            exception
                when NO_DATA_FOUND then
                    null;
            end;

            --获取交易商对应套餐手续费系数，手续费算法
            begin
                select feealgr,feerate_b,feerate_s
                into v_feeAlgr,v_feeRate_b,v_feeRate_s
                from T_A_Tariff
                where TariffID=(select TariffID from t_firm where FirmID=v_FirmID) and CommodityID=v_CommodityID;

            exception
                when NO_DATA_FOUND then
                    null;
            end;

            --获取特户的交易手续费，手续费算法
            begin
                select feealgr,feerate_b,feerate_s
                into v_feeAlgr,v_feeRate_b,v_feeRate_s
                from T_A_FirmFee
                where FirmID=v_FirmID and CommodityID=v_CommodityID;
            exception
                when NO_DATA_FOUND then
                    null;
            end;
            -- tangzy 20100612 撤销卖仓单委托，不计算保证金；
            --开始
            if(v_BillTradeType = 1) then
                 v_Margin := 0;
            else
                 v_Margin := FN_T_ComputeMarginByArgs(v_bs_flag,v_quantity_wd,v_price,v_contractFactor,v_marginAlgr,v_marginRate_b,v_marginRate_s);
            end if;
            --结束
            if(v_Margin < 0) then
                Raise_application_error(-20040, 'computeMargin error');
            end if;
            v_Fee := FN_T_ComputeFeeByArgs(v_bs_flag,v_quantity_wd,v_price,v_contractFactor,v_feeAlgr,v_feeRate_b,v_feeRate_s);
            if(v_Fee < 0) then
                Raise_application_error(-20030, 'computeFee error');
            end if;
            v_to_unfrozenF := v_Margin + v_Fee;

        end if;
        -- tangzy 20100612 撤销卖仓单委托 生效仓单抵顶表释放冻结数量;
        --开始
        if(v_BillTradeType = 1) then
             update T_ValidGageBill set Frozenqty=Frozenqty-v_quantity_wd where FirmID=v_FirmID
                    and CommodityID=v_CommodityID;
                    --BreedID=(select BreedID from t_commodity where CommodityID=v_CommodityID);
        end if;
        --结束
        update T_Orders set unfrozenfunds = unfrozenfunds + v_to_unfrozenF
        where A_orderNo = v_a_orderno_w;
        --更新冻结资金
            v_F_FrozenFunds := FN_F_UpdateFrozenFunds(v_FirmID,-v_to_unfrozenF,'15');
    elsif(v_ordertype=2) then    --平仓
        --zhengxuan 释放交易客户持仓合计表抵顶冻结数量；
        --开始
        if(v_BillTradeType = 2) then
           update T_CustomerHoldSum set GageFrozenQty = GageFrozenQty-v_quantity_wd
               where customerid = v_CustomerID and commodityid = v_CommodityID and bs_flag != v_bs_flag;
        else
           update T_CustomerHoldSum set frozenQty = frozenQty - v_quantity_wd
           where CustomerID = v_CustomerID
           and CommodityID = v_CommodityID
           and bs_flag != v_bs_flag;
        --指定平仓时要更新当日指定平仓冻结表中冻结的持仓，不能直接从此表中删除此委托号的记录，因为存在成交回报在撤单回报之后，会造成成交失败
           if(v_closeMode <> 1) then
                    v_unCloseQty := v_quantity_wd;
                  open c_T_SpecFrozenHold(v_a_orderno_w);
                    loop
                        fetch c_T_SpecFrozenHold into v_id,v_FrozenQty;
                        exit when c_T_SpecFrozenHold%notfound;
                        if(v_FrozenQty <= v_unCloseQty) then
                            v_tradedAmount:=v_FrozenQty;
                            delete from T_SpecFrozenHold where id=v_id;
                    else
                            v_tradedAmount:=v_unCloseQty;
                            update T_SpecFrozenHold set FrozenQty=FrozenQty-v_tradedAmount where id=v_id;
                    end if;
                    v_unCloseQty:=v_unCloseQty - v_tradedAmount;
                    exit when v_unCloseQty=0;
                       end loop;
                close c_T_SpecFrozenHold;
           end if;
        end if;
        --结束
    end if;

    --更新说明，1、对于委托撤单和本地撤单需要更新被撤委托的状态（5、6）和撤单类型（1、2），撤单委托的状态（7）和撤单类型（1、2）
    --        2、对于自动撤单需要更新被撤委托的状态（5、6）和撤单类型（3、4）
    if(p_WithdrawType = 4) then --自动撤单
          --更新委托状态
          if(v_tradeqty = 0) then
            v_status := 5; --全部撤单
          else
            v_status := 6; --部分成交后撤单
          end if;

    else
        --更新委托状态
        if(v_quantity = v_quantity_wd) then
            v_status := 5; --全部撤单
        elsif(v_quantity > v_quantity_wd) then
            v_status := 6; --部分成交后撤单
        else
            Raise_application_error(-20020, 'Parameter p_quantity > the order ''s available num');
        end if;

    end if;
      update T_Orders set status=v_status,WithdrawType=p_WithdrawType,WithdrawTime=sysdate,WithdrawerID=p_WithdrawerID,UpdateTime=systimestamp(3) where A_orderNo = v_a_orderno_w;
    commit;
    return 1;
exception
    when others then
    v_errorcode:=sqlcode;
    v_errormsg :=sqlerrm;
    rollback;
    insert into T_DBLog(err_date,name_proc,err_code,err_msg)
    values(sysdate,'FN_T_Withdraw',v_errorcode,v_errormsg);
    commit;
    return -100;
end;
/

prompt
prompt Creating function FN_V_CLOSEMARKET
prompt ==================================
prompt
create or replace function FN_V_CloseMarket(p_partitionID number) return number
/****
 * 2013-08-22 by liuyu
 * 闭市处理
****/
as
    v_sysdate     date;
    v_status      number(3);

    --当前商品
    type cue_curComm is ref cursor;
    v_curComm cue_curComm;
    v_tradepartition      number(3);
    v_code                varchar2(64);
    v_commodityid         varchar2(64);
    v_section             number(3);
    --v_lpflag              number(2);   --是否流拍（0：否；1：是）
    v_bargainType         number(2);   --是否成交（0：否；1：是）
    v_modifytime          date;
    v_F_FrozenFunds       number(15,2):=0;
begin
    --获取当前时间
    select sysdate,status into v_sysdate,v_status from v_syscurstatus where tradepartition = p_partitionID;
    if(v_status <> 5) then
        return 0;--系统状态不为闭市直接退出
    end if;

    --导入历史委托清当前委托
    insert into v_hissubmit
          (tradedate, id, tradepartition, code, price, amount, userid, traderId, submittime, OrderType, validamount, modifytime, FrozenMargin, FrozenFee, unFrozenMargin, unFrozenFee, WithdrawType)
    select v_sysdate, id, tradepartition, code, price, amount, userid, traderID, submittime, OrderType, validamount, modifytime, FrozenMargin, FrozenFee, unFrozenMargin, unFrozenFee, WithdrawType
      from v_cursubmit
     where tradePartition = p_partitionID;

    delete from v_cursubmit where tradePartition = p_partitionID;

    --清空当日行情
    --delete from v_tradequotation where tradePartition = p_partitionID;

    --成交表数据导入历史成交表、合同扩展表、清当前成交表
    insert into v_hisbargain
			  (tradeDate, contractID, tradePartition, section, submitID, code, commodityid, price, amount, userid, tradeTime, b_bail, s_bail, b_poundage, s_poundage, b_payments, s_payments, b_referPayment, s_referPayment, b_dedit, s_dedit, processingTime, remark)
		select sysdate, contractid, tradepartition, section, submitid, code, commodityid, price, amount, userid, tradetime, b_bail, s_bail, b_poundage, s_poundage, 0,          0,          0,              0,              0,       0,       sysdate,        null
      from v_bargain where tradePartition = p_partitionID;

   /* insert into V_ContractExtra (id, code, firmName, witnessmember)
      select contractid,commodityid,userid,SEQ_V_WITNESSMEMBER.Nextval from v_bargain where tradePartition = p_partitionID;*/

    delete from v_bargain where tradePartition = p_partitionID;

    --当前商品导历史
    open v_curComm for select tradepartition, code, commodityid, section, bargainType, modifytime from v_curcommodity where tradePartition = p_partitionID;
        loop
            fetch v_curComm into v_tradepartition, v_code, v_commodityid, v_section, v_bargainType, v_modifytime;
            exit when v_curComm%NOTFOUND;
                --导入历史商品表
                insert into v_hiscommodity
                    (tradedate, tradepartition,   code,   commodityid,   section,   bargainType,   modifytime)
                values
                    (v_sysdate, v_tradepartition, v_code, v_commodityid, v_section, v_bargainType, v_modifytime);
        end loop;

    --清当前商品
    delete from v_curcommodity where tradePartition = p_partitionID;

    --交易权限表导历史表、清当前表（已成交的商品）
    insert into v_hisTradeAuthority
           (tradeDate, Code, userCode, ModifTime)
      select sysdate, t.code, t.usercode, t.modiftime
        from v_TradeAuthority t, v_commodity c
       where t.Code = c.Code
         and c.status in (1,7);

    delete v_TradeAuthority where Code in (select code from v_commodity where status in (1,7));

    --清空自选商品表
    delete from V_CommoditySelf where partitionid = p_partitionID;

    --退挂单方冻结资金并删除冻结记录
    for withdraw in (select f.code,f.userID,f.FrozenMargin,f.FrozenFee from V_FundFrozen f,v_commodity c where f.code = c.code and c.Tradepartition = p_partitionID and c.Status<>1)
        loop
            v_F_FrozenFunds := FN_F_UpdateFrozenFunds(withdraw.userID,-withdraw.FrozenMargin-withdraw.FrozenFee,'21');
            delete V_FundFrozen where Code = withdraw.code;
        end loop;

    --更新当前系统状态表中闭市处理为已处理
    update v_sysCurStatus set isClose = 1 where tradePartition = p_partitionID;

    return 1;
exception
    when others then
    rollback;
    return -1;
end;
/

prompt
prompt Creating function FN_V_COMPUTEFEE
prompt =================================
prompt
create or replace function FN_V_ComputeFee(
    p_Code           varchar2,
    p_bs_flag        number,      --买卖标志（1：买；2：卖）
    p_quantity       number,
    p_price          number,
    p_userID         varchar2
) return number
/****
 * 计算手续费（竞价）
 * 返回值 成功返回手续费;-1 计算交易费用所需数据不全;-100 其它错误
****/
as
    v_feeRate_b         number(15,5);
    v_feeRate_s         number(15,5);
    v_feeAlgr           number(2);
    v_feeRate           number(15,5);
    v_fee               number(15,2) default 0;
    --v_commodityID       varchar2(64);
    v_BreedID           number(10,0);
    v_num               number(10);
begin
    --获取商品信息：交易手续费
    select FeeAlgr,B_fee,S_fee,BreedID into v_feeAlgr,v_feeRate_b,v_feeRate_s,v_BreedID from v_commodity where Code=p_Code;

    --------------------------特殊手续费------------------------------------
    --获取特殊手续费
    select count(*) into v_num from V_FirmSpecialFee where userCode = p_userID and BreedID = v_BreedID and bs_flag = p_bs_flag;
    if(v_num = 1) then
        select FeeAlgr,Fee into v_feeAlgr,v_feeRate from V_FirmSpecialFee where userCode = p_userID and BreedID = v_BreedID and bs_flag = p_bs_flag;
        if(p_bs_flag = 1) then
            v_feeRate_b := v_feeRate;
        else
            v_feeRate_s := v_feeRate;
        end if;
    end if;
    --------------------------特殊手续费 end------------------------------------

    if(v_feeAlgr=1) then  --百分比
    	if(p_bs_flag = 1) then  --买
        	v_fee:=p_quantity*p_price*v_feeRate_b;
        elsif(p_bs_flag = 2) then  --卖
        	v_fee:=p_quantity*p_price*v_feeRate_s;
        end if;
    elsif(v_feeAlgr=0) then  --绝对值
    	if(p_bs_flag = 1) then  --买
        	v_fee:=p_quantity*v_feeRate_b;
        elsif(p_bs_flag = 2) then  --卖
        	v_fee:=p_quantity*v_feeRate_s;
        end if;
    end if;
    if(v_fee is null) then
    	  rollback;
        return -1;
    end if;
    return v_fee;
exception
    when no_data_found then
    	rollback;
        return -1;
    when others then
    	rollback;
   		return -100;
end;
/

prompt
prompt Creating function FN_V_COMPUTEMARGIN
prompt ====================================
prompt
create or replace function FN_V_ComputeMargin(
    p_Code            varchar2,
    p_bs_flag         number,   --交易模式（1：买；2：卖）
    p_quantity        number,
    p_price           number,
    p_userID          varchar2
) return number
/****
 * 计算保证金（竞价）
 * 返回值 成功返回保证金;-1 计算所需数据不全;-100 其它错误
****/
as
	  v_version varchar2(10):='1.0.0.1';
    v_marginRate_b         number(15,4);
    v_marginRate_s         number(15,4);
    v_marginRate           number(15,4);
    --v_commodityID          varchar2(64);
    v_marginAlgr           number(2);
    v_margin               number(12,2) default 0;
    v_BreedID              number(10,0);
    v_num                  number(10);
begin
    --获取商品信息：交易保证金
    select MarginAlgr,B_security,S_security,BreedID into v_marginAlgr,v_marginRate_b,v_marginRate_s,v_BreedID from v_commodity where Code=p_Code;

    --------------------------特殊保证金------------------------------------
    --获取特殊保证金
    select count(*) into v_num from V_FirmSpecialMargin where userCode = p_userID and BreedID = v_BreedID and bs_flag = p_bs_flag;
    if(v_num = 1) then
        select MarginAlgr,Margin into v_marginAlgr,v_marginRate from V_FirmSpecialMargin where userCode = p_userID and BreedID = v_BreedID and bs_flag = p_bs_flag;
        if(p_bs_flag = 1) then
            v_marginRate_b := v_marginRate;
        else
            v_marginRate_s := v_marginRate;
        end if;
    end if;
    --------------------------特殊保证金 end------------------------------------

    if(v_marginAlgr=1) then  --百分比
    	if(p_bs_flag = 1) then  --买
		    if(v_marginRate_b = -1) then --  -1表示收全款
		    	v_margin:=p_quantity*p_price;
		    else
			    v_margin:=p_quantity*p_price*v_marginRate_b;
		    end if;
      elsif(p_bs_flag = 2) then  --卖
		    if(v_marginRate_s = -1) then --  -1表示收全款
		    	v_margin:=p_quantity*p_price;
		    else
			    v_margin:=p_quantity*p_price*v_marginRate_s;
		    end if;
      end if;
    elsif(v_marginAlgr=0) then  --绝对值
    	if(p_bs_flag = 1) then  --买
		    if(v_marginRate_b = -1) then --  -1表示收全款
		    	v_margin:=p_quantity*p_price;
		    else
			    v_margin:=p_quantity*v_marginRate_b;
		    end if;
      elsif(p_bs_flag = 2) then  --卖
		    if(v_marginRate_s = -1) then --  -1表示收全款
		    	v_margin:=p_quantity*p_price;
		    else
			    v_margin:=p_quantity*v_marginRate_s;
		    end if;
      end if;
    end if;

    if(v_margin is null) then
    	rollback;
      return -1;
    end if;
    return v_margin;
exception
    when no_data_found then
    	rollback;
      return -1;
    when others then
	    rollback;
    	return -100;
end;
/

prompt
prompt Creating function FN_V_FIRMADD
prompt ==============================
prompt
create or replace function FN_V_FirmAdd(p_FirmID varchar2)
return number
 /****
  *增加交易商
  *成功返回 1
  *****/
as
     v_cnt number(5);
begin
     select count(*) into v_cnt from v_tradeuser where usercode=p_firmid;
     if(v_cnt>0) then
           return -1; --交易商已存在
     end if;
     --插入交易商表，默认有竞价权限、无挂单权限
     insert into v_tradeuser(usercode,isEntry,limits)
     values(P_FIRMID,0,0);

     return 1;
end;
/

prompt
prompt Creating function FN_V_FIRMDEL
prompt ==============================
prompt
create or replace function FN_V_FirmDel(p_FirmID varchar2)
return number
 /****
  *注销交易商
  *成功返回 1
  *****/
as
     v_cnt number(5);
begin
    delete from v_tradeuser where usercode=p_FirmID;

    update v_hisbargain set userid=userid||'_D' where userid=p_FirmID;
    update v_hissubmit set userid=userid||'_D' where userid=p_FirmID;

    return 1;
end;
/

prompt
prompt Creating function FN_V_FIRMEXITCHECK
prompt ====================================
prompt
create or replace function FN_V_FirmExitCheck(p_FirmID varchar2)
return number
as
/**
 * 竞价 交易商退市
 **/
  v_cnt number(4);
begin
  select count(*) into v_cnt from v_tradeuser v where v.usercode=p_FirmID;
  if(v_cnt=0) then
    return -1;
  end if;
  --有合同未处理完
  select count(*) into v_cnt from v_hisbargain where userid=p_FirmID and status!=2;
  if(v_cnt!=0) then
    return -1;
  end if;

  return 1;
end;
/

prompt
prompt Creating function FN_V_ORDER
prompt ============================
prompt
create or replace function FN_V_Order(
    p_tradePartition     number,    --交易模块（1：竞买；2：竞卖）
    p_Code               varchar2,  --标的号
    p_Price              number,    --价格
    p_amount             number,    --数量
    p_traderId           varchar2,  --交易员
    p_userID             varchar2,  --交易用户(交易商)
    p_Margin             number,    --保证金
    p_Fee                number,    --手续费
    p_orderTime          timestamp  --委托时间
) return number
/****
 * 2012-03-21 by liuyu
 * 竞价委托
 * 返回值
 *	下委托成功返回委托单号
 *	-1  异常返回
 *	-2  资金不足返回
****/
as
    v_F_Funds         number(15,2):=0;      --应冻结资金
    v_A_Funds         number(15,2);         --可用资金
    v_F_FrozenFunds   number(15,2):=0;      --冻结资金
    v_A_OrderNo       number(15,0);         --委托号
    v_orderTime       timestamp;
    v_Overdraft       number(10,2):=0;      --交易商虚拟资金
begin
        -- 获取当前数据库时间
        select systimestamp(6) into v_orderTime from dual;

        --应冻结资金
        v_F_Funds := p_Margin + p_Fee;
        --2013-10-08获取虚拟资金
        select Overdraft into v_Overdraft from v_tradeUser where userCode = p_userID;
        --计算可用资金，并锁住财务资金
        v_A_Funds := FN_F_GetRealFunds(p_userID,1);
        if(v_A_Funds + v_Overdraft < v_F_Funds) then
            rollback;
            return -2;  --资金余额不足
        end if;

        --更新冻结资金
        v_F_FrozenFunds := FN_F_UpdateFrozenFunds(p_userID,v_F_Funds,'21');
        --插入委托表，并返回委托单号
        select SP_V_CURSUBMIT.nextval into v_A_OrderNo from dual;
        insert into v_curSubmit
          (ID,          tradePartition,   Code,   Price,   amount,   traderId,   userID,   submitTime,  OrderType, validAmount, modifytime,  FrozenMargin, FrozenFee, unFrozenMargin, unFrozenFee, WithdrawType)
        values
          (v_A_OrderNo, p_tradePartition, p_Code, p_Price, p_amount, p_traderId, p_userID, p_orderTime, 0,         p_amount,    v_orderTime, p_Margin,     p_Fee,     0,              0,           null);

        /*if(p_tradePartition=1) then
            update v_tradeUser set TradeQty = TradeQty + p_amount where userCode = p_userID;
        end if;

        if(p_withOrderNo > 0) then
            update v_curSubmit set modifytime = v_orderTime,ToItsType = 2 where ID = p_withOrderNo;
        end if;*/

        return v_A_OrderNo;
exception
    when others then
        rollback;
        return -1;
end;
/

prompt
prompt Creating function FN_V_WITHDRAW
prompt ===============================
prompt
create or replace function FN_V_Withdraw(
    p_A_OrderNo          number,             --被撤单委托单号
    p_WithdrawType       number,             --撤单类型 0：成交撤单；1：流拍撤单; 2:交易中撤单
    p_amount             number              --撤单数量
) return number
/****
 * 2012-03-21 by liuyu
 * 竞价撤单
 * 返回值
 * 1  成功
 * -1 失败
 * -2 撤单数量超过范围
****/
as
     v_FrozenMargin      number(15,2):=0;    --冻结保证金
     v_FrozenFee         number(15,2):=0;    --冻结手续费
     v_unFrozenMargin    number(15,2):=0;    --释放保证金
     v_unFrozenFee       number(15,2):=0;    --释放手续费
     v_OrderType         number(3):=3;       --委托状态（3：全部撤单；4：部分成交后撤单；5：部分撤单）
     v_Margin            number(15,2):=0;    --保证金
     v_Fee               number(15,2):=0;    --手续费
     v_userID            varchar2(32);
     v_tradePartition    number(3);          --交易板块（1：竞买；2：竞卖）
     v_amount            number(16,6):=0;    --委托数量
     v_validAmount       number(16,6):=0;    --有效成交数量
     v_orderTime         timestamp;
     v_F_FrozenFunds     number(15,2):=0;

begin
    -- 获取当前数据库时间
    select systimestamp(6) into v_orderTime from dual;
    --获取被撤单信息
    begin
        select FrozenMargin,FrozenFee,unFrozenMargin,unFrozenFee,userID,tradePartition,amount,validAmount
          into v_FrozenMargin,v_FrozenFee,v_unFrozenMargin,v_unFrozenFee,v_userID,v_tradePartition,v_amount,v_validAmount
         from v_curSubmit
        where ID = p_A_OrderNo for update;
    exception
        when NO_DATA_FOUND then
        select FrozenMargin,FrozenFee,unFrozenMargin,unFrozenFee,userID,tradePartition,amount,validAmount
          into v_FrozenMargin,v_FrozenFee,v_unFrozenMargin,v_unFrozenFee,v_userID,v_tradePartition,v_amount,v_validAmount
         from v_hisSubmit
        where ID = p_A_OrderNo;
    end;

    if(p_WithdrawType=0) then --成交撤单
         v_Margin := v_FrozenMargin - v_unFrozenMargin;
         v_Fee := v_FrozenFee - v_unFrozenFee;
         if(p_amount < v_validAmount) then
             v_OrderType := 4; --部分成交后撤单
         elsif(p_amount = v_validAmount) then
             v_OrderType := 3;--全部撤单
         end if;
    elsif(p_WithdrawType=1) then --流拍撤单
         v_Margin := v_FrozenMargin;
         v_Fee := v_FrozenFee;
         v_OrderType := 3;--全部撤单
    elsif(p_WithdrawType=2) then --委托撤单
         if(p_amount < v_validAmount) then--部分撤单
             v_Margin := p_amount/v_amount*v_FrozenMargin;
             v_Fee := p_amount/v_amount*v_FrozenFee;
             v_OrderType := 5;--部分撤单
         elsif(p_amount = v_validAmount) then--全部撤单
             v_Margin := v_FrozenMargin - v_unFrozenMargin;
             v_Fee := v_FrozenFee - v_unFrozenFee;
             v_OrderType := 3;--全部撤单
         else
             return -2;
         end if;
    end if;

    --更新委托表
    update v_curSubmit set modifytime = v_orderTime,
                           OrderType = v_OrderType,
                           unFrozenMargin = unFrozenMargin + v_Margin,
                           unFrozenFee = unFrozenFee + v_Fee,
                           validAmount = validAmount - p_amount,
                           WithdrawType = p_WithdrawType
    where ID = p_A_OrderNo;
    --更新冻结资金
    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(v_userID,-v_Margin-v_Fee,'21');

    return 1;
exception
    when others then
    rollback;
    return -1;
end;
/

prompt
prompt Creating function FN_V_TRADEBUY
prompt ===============================
prompt
create or replace function FN_V_TradeBuy(p_Code varchar2) return number
/****
 * 2013-12-16 by liuyu
 * 竞买成交
 * 返回值
 * 1  成功
 * -1 失败
****/
as
    v_num         number(10,0);
    v_FlowAmount  number(16,6):=0;           --流拍数量
    v_amountSum   number(16,6):=0;           --委托数量
    v_Balance     number(15,2);
    v_Amount      number(16,6):=0;           --商品数量
    v_commodityID varchar2(64);
    v_beginPrice  number(15,2):=0;           --起拍价
    v_alertPrice  number(15,2):=0;           --报警价
    v_Qty         number(16,6):=0;           --成交数量
    v_section     number(3);                 --所属交易节
    v_tradeFlag   number(3):=1;              --成交标志（1：全部成交；2：部分成交）
    v_userID      varchar2(32);              --交易用户
    v_bailSum     number(12,2):=0;           --挂单方总保证金
    v_poundageSum number(12,2):=0;           --挂单方总手续费
    v_b_bail      number(12,2):=0;           --买方保证金
    v_s_bail      number(12,2):=0;           --卖方保证金
    v_b_poundage  number(12,2):=0;           --买方手续费
    v_s_poundage  number(12,2):=0;           --卖方手续费
    v_F_FrozenFunds     number(15,2):=0;
    v_Withdraw    number(10);
    v_withdrawQty number(16,6):=0;           --撤单数量
    v_A_TradeNo   number(10);
    v_orderTime       timestamp;
    v_FlowAmountAlgr   number(2);            --流拍数量计算方式（0：百分比；1：绝对值）
    v_Status           number(3);
begin
    -- 获取当前数据库时间
    select systimestamp(6) into v_orderTime from dual;
    --验证该标的是否已成交，如果已经存在该标的的成交，直接跳出函数
    select Status into v_Status from v_commodity where Code = p_Code;
    if(v_Status<>2) then
        return 1;
    end if;

    --验证是否流拍
    --1. 获取商品信息
    select commodityID,   FlowAmount,   FlowAmountAlgr,   Amount,   userID
      into v_commodityID, v_FlowAmount, v_FlowAmountAlgr, v_Amount, v_userID
    from v_commodity where Code = p_Code;
    --2. 汇总委托表中数量
    select nvl(sum(amount),0) into v_amountSum from v_curSubmit where Code = p_Code;
    --3. 获取所属交易节
    select section into v_section from v_curCommodity where Code = p_Code;

    --释放挂单方冻结资金并删除挂单冻结记录
    select FrozenMargin,FrozenFee into v_bailSum,v_poundageSum from V_FundFrozen where Code = p_Code;
    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(v_userID,-v_bailSum-v_poundageSum,'21');
    delete V_FundFrozen where Code = p_Code;

    --计算流拍数量
    if(v_FlowAmountAlgr=1) then--按百分比计算
        v_FlowAmount := v_Amount*v_FlowAmount;
    end if;
    --如果委托数量小于流拍数量 则流拍
    if(v_amountSum<v_FlowAmount) then--流拍
        --循环调用撤单函数
        for withdraw in (select ID,amount from v_curSubmit where Code = p_Code)
          loop
              v_Balance := FN_V_Withdraw(withdraw.ID,1,withdraw.amount);
          end loop;
        --更新当前交易商表
        update v_curCommodity set bargainType = 3, modifyTime = sysdate where Code = p_Code;
        --更新商品表状态
        update v_commodity set Status=8 where Code = p_Code;
    else
        --按照价格优先、数量优先、时间优先的顺序排序(过滤已撤单)
        for trade in (select ID,Price,amount,validAmount,userID,FrozenMargin,FrozenFee,unFrozenMargin,unFrozenFee from v_curSubmit where Code = p_Code and OrderType in (0,5) order by Price desc,amount desc,submitTime)
          loop
              if(v_Amount>0) then
                  if(v_Amount < trade.amount) then --部分成交
                      v_tradeFlag := 2;
                      v_Qty := trade.validAmount;   --成交数量
                      v_withdrawQty := trade.validAmount - v_Amount;
                  else         --全部成交
                      v_Qty := trade.amount;
                      v_tradeFlag := 1;
                  end if;

                  --计算保证金和手续费
                  if(v_Amount < trade.validAmount) then
                      v_b_bail :=  FN_V_ComputeMargin(p_Code,1,v_Qty,trade.Price,trade.userID);
                      v_b_poundage := FN_V_ComputeFee(p_Code,1,v_Qty,trade.Price,trade.userID);
                  else
                      v_b_bail :=  trade.FrozenMargin - trade.unFrozenMargin;
                      v_b_poundage := trade.FrozenFee - trade.unFrozenFee;
                  end if;

                  --计算卖方保证金手续费
                  v_s_bail :=  FN_V_ComputeMargin(p_Code,2,v_Qty,trade.Price,v_userID);
                  v_s_poundage := FN_V_ComputeFee(p_Code,2,v_Qty,trade.Price,v_userID);


                  --获取成交号
                  select SP_V_BARGAIN.nextval into v_A_TradeNo from dual;
                  --写成交
                  insert into v_bargain
                     (contractID,  tradePartition, Section,   submitID, Code,   commodityID,   Price,       Amount, userID,       TradeTime,   b_bail,   s_bail,   b_poundage,   s_poundage)
                  values
                     (v_A_TradeNo, 1,              v_section, trade.ID, p_Code, v_commodityID, trade.Price, v_Qty,  trade.userID, sysdate,   v_b_bail, v_s_bail, v_b_poundage, v_s_poundage);

                  --改委托
                  update v_curSubmit set OrderType=v_tradeFlag,
                                         modifytime=v_orderTime,
                                         unFrozenMargin=unFrozenMargin+v_b_bail,
                                         unFrozenFee=unFrozenFee+v_b_poundage
                                     where id = trade.ID;
                  --释放买方冻结资金
                  v_F_FrozenFunds := FN_F_UpdateFrozenFunds(trade.userID,-v_b_bail-v_b_poundage,'21');
                  --收双方保证金、手续费（写流水）
                  --卖方
                  v_Balance := FN_F_UpdateFundsFull(v_userID,'21002',v_s_bail,v_A_TradeNo,v_commodityID,null,null);
                  v_Balance := FN_F_UpdateFundsFull(v_userID,'21001',v_s_poundage,v_A_TradeNo,v_commodityID,null,null);
                  --买方
                  v_Balance := FN_F_UpdateFundsFull(trade.userID,'21002',v_b_bail,v_A_TradeNo,v_commodityID,null,null);
                  v_Balance := FN_F_UpdateFundsFull(trade.userID,'21001',v_b_poundage,v_A_TradeNo,v_commodityID,null,null);
                  --如果部分成交需要成交后撤单
                  if(v_tradeFlag=2 and v_withdrawQty >0) then
                      v_Withdraw := FN_V_Withdraw(trade.ID,0,v_withdrawQty);
                  end if;

                  --成交后递减商品数量
                  v_Amount := v_Amount - v_Qty;
              else
                  --如果配对成交后有多余的委托单需要做撤单处理
                  v_Withdraw := FN_V_Withdraw(trade.ID,0,trade.amount);
              end if;

          end loop;

        --更新当前交易商品表
        update v_curCommodity set bargainType = 1, modifyTime =sysdate where Code = p_Code;
        --更新商品表状态
        update v_commodity set Status=1 where Code = p_Code;
    end if;
    return 1;
exception
    when others then
    rollback;
    return -1;
end;
/

prompt
prompt Creating function FN_V_TRADESELL
prompt ================================
prompt
create or replace function FN_V_TradeSell(p_Code varchar2) return number
/****
 * 2013-12-16 by liuyu
 * 竞卖成交
 * 返回值
 * 1  成功
 * -1 失败
****/
as
    v_num         number(10,0);
    v_FlowAmount  number(16,6):=0;           --流拍数量
    v_amountSum   number(16,6):=0;           --委托数量
    v_Balance     number(15,2);
    v_Amount      number(16,6):=0;           --商品数量
    v_commodityID varchar2(64);
    v_beginPrice  number(15,2):=0;           --起拍价
    v_alertPrice  number(15,2):=0;           --报警价
    v_Qty         number(16,6):=0;           --成交数量
    v_section     number(3);                 --所属交易节
    v_tradeFlag   number(3):=1;              --成交标志（1：全部成交；2：部分成交）
    v_userID      varchar2(32);              --交易用户
    v_bailSum     number(12,2):=0;           --挂单方总保证金
    v_poundageSum number(12,2):=0;           --挂单方总手续费
    v_b_bail      number(12,2):=0;           --买方保证金
    v_s_bail      number(12,2):=0;           --卖方保证金
    v_b_poundage  number(12,2):=0;           --买方手续费
    v_s_poundage  number(12,2):=0;           --卖方手续费
    v_F_FrozenFunds     number(15,2):=0;
    v_Withdraw    number(10);
    v_withdrawQty number(16,6):=0;           --撤单数量
    v_A_TradeNo   number(10);
    v_orderTime       timestamp;
    v_FlowAmountAlgr   number(2);            --流拍数量计算方式（0：百分比；1：绝对值）
    v_Status           number(3);
begin
    -- 获取当前数据库时间
    select systimestamp(6) into v_orderTime from dual;
    --1. 验证该标的是否已成交，如果已经存在该标的的成交，直接跳出函数
    select Status into v_Status from v_commodity where Code = p_Code;
    if(v_Status<>2) then
        return 1;
    end if;

    --获取商品信息
    select commodityID,   FlowAmount,   FlowAmountAlgr,   Amount,   userID
      into v_commodityID, v_FlowAmount, v_FlowAmountAlgr, v_Amount, v_userID
    from v_commodity where Code = p_Code;
    --汇总委托表中数量
    select nvl(sum(amount),0) into v_amountSum from v_curSubmit where Code = p_Code;
    --获取所属交易节
    select section into v_section from v_curCommodity where Code = p_Code;

    --2. 释放挂单方冻结资金并删除挂单冻结记录
    select FrozenMargin,FrozenFee into v_bailSum,v_poundageSum from V_FundFrozen where Code = p_Code;
    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(v_userID,-v_bailSum-v_poundageSum,'21');
    delete V_FundFrozen where Code = p_Code;

    --计算流拍数量
    if(v_FlowAmountAlgr=1) then--按百分比计算
        v_FlowAmount := v_Amount*v_FlowAmount;
    end if;
    --3. 如果委托数量小于流拍数量 则流拍
    if(v_amountSum<v_FlowAmount) then--流拍
        --循环调用撤单函数
        for withdraw in (select ID,amount from v_curSubmit where Code = p_Code)
          loop
              v_Balance := FN_V_Withdraw(withdraw.ID,1,withdraw.amount);
          end loop;
        --更新当前交易商表
        update v_curCommodity set bargainType = 3, modifyTime = sysdate where Code = p_Code;
        --更新商品表状态
        update v_commodity set Status=8 where Code = p_Code;
    else

        --4. 按照价格优先、数量优先、时间优先的顺序排序(过滤已撤单)
        for trade in (select ID,Price,amount,validAmount,userID,FrozenMargin,FrozenFee,unFrozenMargin,unFrozenFee from v_curSubmit where Code = p_Code and OrderType in (0,5) order by Price,amount desc,submitTime)
            loop
                if(v_Amount>0) then
                    if(v_Amount<trade.amount) then --部分成交
                        v_tradeFlag := 2;
                        v_Qty := trade.validAmount;   --成交数量
                        v_withdrawQty := trade.validAmount - v_Amount;
                    else         --全部成交
                        v_Qty := trade.amount;
                        v_tradeFlag := 1;
                    end if;

                    --计算保证金和手续费
                    if(v_Amount < trade.validAmount) then
                        v_s_bail :=  FN_V_ComputeMargin(p_Code,2,v_Qty,trade.Price,trade.userID);
                        v_s_poundage := FN_V_ComputeFee(p_Code,2,v_Qty,trade.Price,trade.userID);
                    else
                        v_s_bail :=  trade.FrozenMargin - trade.unFrozenMargin;
                        v_s_poundage := trade.FrozenFee - trade.unFrozenFee;
                    end if;

                    --计算买方保证金手续费
                    v_b_bail :=  FN_V_ComputeMargin(p_Code,1,v_Qty,trade.Price,v_userID);
                    v_b_poundage := FN_V_ComputeFee(p_Code,1,v_Qty,trade.Price,v_userID);

                    --获取成交号
                    select SP_V_BARGAIN.nextval into v_A_TradeNo from dual;
                    --写成交
                    insert into v_bargain
                       (contractID,  tradePartition, submitID, Code,   commodityID,   Price,       Amount, userID,       TradeTime, Section,   b_bail,   s_bail,   b_poundage,   s_poundage)
                    values
                       (v_A_TradeNo, 2,              trade.ID, p_Code, v_commodityID, trade.Price, v_Qty,  trade.userID, sysdate,   v_section, v_b_bail, v_s_bail, v_b_poundage, v_s_poundage);

                    --改委托
                    update v_curSubmit set OrderType=v_tradeFlag,
                                           modifytime=v_orderTime,
                                           unFrozenMargin=unFrozenMargin+v_s_bail,
                                           unFrozenFee=unFrozenFee+v_s_poundage
                                       where id = trade.ID;
                    --释放卖方冻结资金
                    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(trade.userID,-v_s_bail-v_s_poundage,'21');
                    --收双方保证金、手续费（写流水）
                    --买方
                    v_Balance := FN_F_UpdateFundsFull(v_userID,'21002',v_b_bail,v_A_TradeNo,v_commodityID,null,null);
                    v_Balance := FN_F_UpdateFundsFull(v_userID,'21001',v_b_poundage,v_A_TradeNo,v_commodityID,null,null);
                    --卖方
                    v_Balance := FN_F_UpdateFundsFull(trade.userID,'21002',v_s_bail,v_A_TradeNo,v_commodityID,null,null);
                    v_Balance := FN_F_UpdateFundsFull(trade.userID,'21001',v_s_poundage,v_A_TradeNo,v_commodityID,null,null);
                    --如果部分成交需要成交后撤单
                    if(v_tradeFlag=2 and v_withdrawQty>0) then
                        v_Withdraw := FN_V_Withdraw(trade.ID,0,v_withdrawQty);
                    end if;

                    --成交后递减商品数量
                    v_Amount := v_Amount - v_Qty;
                else
                    --如果配对成交后有多余的委托单需要做撤单处理
                    v_Withdraw := FN_V_Withdraw(trade.ID,0,trade.amount);
                end if;
            end loop;

        --更新当前交易商品表
        update v_curCommodity set bargainType = 1, modifyTime =sysdate where Code = p_Code;
        --更新商品表状态
        update v_commodity set Status=1 where Code = p_Code;
    end if;
    return 1;
exception
    when others then
    rollback;
    return -1;
end;
/

prompt
prompt Creating function FN_V_TRADETENDER
prompt ==================================
prompt
create or replace function FN_V_TradeTender(p_Code varchar2) return number
/****
 * 2013-12-16 by liuyu
 * 招标成交（交易节结束时调用）
 * 返回值
 * 1  成功
 * -1 失败
****/
as
    v_num         number(10,0);
    v_Balance     number(15,2);
    v_Amount      number(16,6):=0;           --商品数量
    v_commodityID varchar2(64);
    v_beginPrice  number(15,2):=0;           --起拍价
    v_alertPrice  number(15,2):=0;           --报警价
    v_Qty         number(16,6):=0;           --成交数量
    v_userID      varchar2(32);              --交易用户
    v_bs_flag     number(2);                 --买卖方向（1：买；2：卖）

    type c_v_curSubmit is ref cursor;
	  v_trade c_v_curSubmit;
    v_sql varchar2(500);
    v_where varchar2(50);

    v_oradeby       varchar2(16):='';

    v_id            number(12);
    v_Price         number(12,2);
    v_orderamount   number(16,6);
    v_validAmount   number(16,6);
    v_orderuserID   varchar2(64);
    v_FrozenMargin  number(15,2):=0;
    v_FrozenFee     number(15,2):=0;
    v_unFrozenMargin  number(15,2):=0;
    v_unFrozenFee   number(15,2):=0;
begin
    --1. 验证该标的是否已经产生成交，如果已经存在该标的的成交，直接跳出函数
    select count(*) into v_num from v_curSubmitTenderPlan where Code = p_Code;
    if(v_num>0) then
        return 1;
    end if;

    --2. 获取商品信息
    select commodityID,   Amount,   beginPrice,   alertPrice,   userID,   bs_flag
      into v_commodityID, v_Amount, v_beginPrice, v_alertPrice, v_userID, v_bs_flag
    from v_commodity where Code = p_Code;

    --3.将委托表符合价格区间的委托导入到招标委托表中
    if(v_bs_flag = 1) then
        insert into v_curSubmitTender
              (id, tradepartition, code, price, amount, userid, traderId, submittime, OrderType, validamount, modifytime, FrozenMargin, FrozenFee, unFrozenMargin, unFrozenFee, WithdrawType)
        select id, tradepartition, code, price, amount, userid, traderID, submittime, OrderType, validamount, modifytime, FrozenMargin, FrozenFee, unFrozenMargin, unFrozenFee, WithdrawType
          from v_cursubmit
         where code = p_Code and Price <= v_beginPrice and Price >= v_alertPrice;
    else
        insert into v_curSubmitTender
              (id, tradepartition, code, price, amount, userid, traderId, submittime, OrderType, validamount, modifytime, FrozenMargin, FrozenFee, unFrozenMargin, unFrozenFee, WithdrawType)
        select id, tradepartition, code, price, amount, userid, traderID, submittime, OrderType, validamount, modifytime, FrozenMargin, FrozenFee, unFrozenMargin, unFrozenFee, WithdrawType
          from v_cursubmit
         where code = p_Code and Price >= v_beginPrice and Price <= v_alertPrice;
    end if;


    --4.按照价格优先、数量优先、时间优先的顺序排序(过滤不符合价格区间的委托)
    v_where := ' and Price <= '||v_beginPrice||' and Price >= '||v_alertPrice;
    if(v_bs_flag = 2) then
        v_oradeby := ' desc ';
        v_where := ' and Price >= '||v_beginPrice||' and Price <= '||v_alertPrice;
    end if;
    v_sql := 'select ID,Price,amount,validAmount,userID,FrozenMargin,FrozenFee,unFrozenMargin,unFrozenFee from v_curSubmit where Code = '''||p_Code||''' and OrderType in (0,5) '||v_where||' order by Price'||v_oradeby||',amount desc,submitTime';
    open v_trade for v_sql;
        loop
            fetch v_trade into v_id,v_Price,v_orderamount,v_validAmount,v_orderuserID,v_FrozenMargin,v_FrozenFee,v_unFrozenMargin,v_unFrozenFee;
            exit when v_trade%NOTFOUND;
                if(v_Amount>0) then
                    if(v_Amount<v_orderamount) then --部分成交
                        v_Qty := v_Amount;
                    else         --全部成交
                        v_Qty := v_orderamount;
                    end if;

                    --将默认成交记录导入招标计划委托表
                    insert into v_curSubmitTenderPlan
                          (id, tradepartition, code, price, amount, ConfirmAmount, userid, traderId, submittime, OrderType, validamount, modifytime, FrozenMargin, FrozenFee, unFrozenMargin, unFrozenFee, WithdrawType)
                    select id, tradepartition, code, price, amount, v_Qty,         userid, traderID, submittime, OrderType, validamount, modifytime, FrozenMargin, FrozenFee, unFrozenMargin, unFrozenFee, WithdrawType
                      from v_cursubmit
                     where id = v_id;

                    --成交后递减商品数量
                    v_Amount := v_Amount - v_Qty;
                end if;

        end loop;
        close v_trade;

    --5. 将不符合价格区间的委托进行撤单
    if(v_bs_flag = 1) then
        for otherwithdraw in (select ID,amount from v_curSubmit where Code = p_Code and (Price > v_beginPrice or Price < v_alertPrice))
            loop
                v_Balance := FN_V_Withdraw(otherwithdraw.ID,0,otherwithdraw.amount);
            end loop;
    else
        for otherwithdraw in (select ID,amount from v_curSubmit where Code = p_Code and (Price > v_alertPrice or Price < v_beginPrice ))
            loop
                v_Balance := FN_V_Withdraw(otherwithdraw.ID,0,otherwithdraw.amount);
            end loop;
    end if;


    --6. 更新当前交易商品表
    update v_curCommodity set bargainType = 1, modifyTime =sysdate where Code = p_Code;
    --7. 更新商品表状态
    update v_commodity set Status=1,TenderTradeConfirm = 0 where Code = p_Code;

    return 1;
exception
    when others then
    rollback;
    return -1;
end;
/

prompt
prompt Creating function FN_V_TRADETENDERAUDIT
prompt =======================================
prompt
create or replace function FN_V_TradeTenderAudit(p_Code varchar2) return number
/****
 * 2013-12-16 by liuyu
 * 招标成交确认
 * 返回值
 * 1  成功
 * -1 失败
 * -2 确认数量大于商品数量
****/
as
    v_Balance     number(15,2);
    v_Amount      number(16,6):=0;           --商品数量
    v_commodityID varchar2(64);
    v_beginPrice  number(15,2):=0;           --起拍价
    v_alertPrice  number(15,2):=0;           --报警价
    v_Qty         number(16,6):=0;           --成交数量
    v_section     number(3);                 --所属交易节
    v_tradeFlag   number(3):=1;              --成交标志（1：全部成交；2：部分成交）
    v_userID      varchar2(32);              --交易用户
    v_bailSum     number(12,2):=0;           --挂单方总保证金
    v_poundageSum number(12,2):=0;           --挂单方总手续费
    v_b_bail      number(12,2):=0;           --买方保证金
    v_s_bail      number(12,2):=0;           --卖方保证金
    v_b_poundage  number(12,2):=0;           --买方手续费
    v_s_poundage  number(12,2):=0;           --卖方手续费
    v_c_bail      number(12,2):=0;           --投标方保证金
    v_m_bail      number(12,2):=0;           --挂标方保证金
    v_c_poundage  number(12,2):=0;           --投标方手续费
    v_m_poundage  number(12,2):=0;           --挂标方手续费
    v_F_FrozenFunds     number(15,2):=0;
    v_Withdraw    number(10);
    v_withdrawQty number(16,6):=0;           --撤单数量
    v_A_TradeNo   number(10);
    v_orderTime       timestamp;
    v_TenderTradeConfirm  number(2);         --招标成交确认（0：未确认；1：已确认）
    v_ConfirmAmount       number(16,6):=0;   --确认成交数量汇总
    v_bs_flag             number(2);         --商品买卖方向
    v_bs_flag_c           number(2);         --投标方买卖方向
    v_num                 number(3);
begin
    --获取当前数据库时间
    select systimestamp(6) into v_orderTime from dual;

    --1. 验证该标的是否已经确认成交，如果该标的已经确认成交，直接跳出函数
    select TenderTradeConfirm into v_TenderTradeConfirm from v_commodity where Code = p_Code;
    if(v_TenderTradeConfirm=1) then
        return 1;
    end if;

    --获取商品信息
    select commodityID,   Amount,   beginPrice,   alertPrice,   userID,   bs_flag
      into v_commodityID, v_Amount, v_beginPrice, v_alertPrice, v_userID, v_bs_flag
    from v_commodity where Code = p_Code;

    --2. 验证商品数量是否满足成交数量，不满足直接退出
    select nvl(sum(ConfirmAmount),0) into v_ConfirmAmount from v_curSubmitTenderPlan where code = p_Code;
    if(v_ConfirmAmount > v_Amount) then
         return -2;
    end if;

    --获取所属交易节
    select count(*) into v_num from v_curCommodity where Code = p_Code;
    if(v_num = 1) then
        select section into v_section from v_curCommodity where Code = p_Code;
    else
        select max(nvl(section,0)) into v_section from v_hisCommodity where Code = p_Code;
    end if;
    --select section into v_section from (select section from v_curCommodity where Code = p_Code union select section from v_hisCommodity where Code = p_Code);

    --3. 释放挂单方冻结资金并删除挂单冻结记录
    select FrozenMargin,FrozenFee into v_bailSum,v_poundageSum from V_FundFrozen where Code = p_Code;
    v_F_FrozenFunds := FN_F_UpdateFrozenFunds(v_userID,-v_bailSum-v_poundageSum,'21');
    delete V_FundFrozen where Code = p_Code;

    --根据商品买卖方向确定委托买卖方向
    if(v_bs_flag=1) then
       v_bs_flag_c := 2;
    else
       v_bs_flag_c := 1;
    end if;

    --4. 按照价格优先、数量优先、时间优先的顺序排序(过滤不符合价格区间的委托)
    for trade in (select ID,Price,amount,ConfirmAmount,validAmount,userID,FrozenMargin,FrozenFee,unFrozenMargin,unFrozenFee from v_curSubmitTenderPlan where Code = p_Code)
        loop
            if(trade.ConfirmAmount<trade.amount) then --部分成交
                v_tradeFlag := 2;
                --v_Qty := trade.ConfirmAmount;   --成交数量
                v_withdrawQty := trade.amount - trade.ConfirmAmount;
            else         --全部成交
                --v_Qty := trade.amount;
                v_tradeFlag := 1;
            end if;

            --成交数量
            v_Qty := trade.ConfirmAmount;

            --计算投标方保证金和手续费
            if(trade.ConfirmAmount<trade.amount) then
                v_c_bail :=  FN_V_ComputeMargin(p_Code,v_bs_flag_c,v_Qty,trade.Price,trade.userID);
                v_c_poundage := FN_V_ComputeFee(p_Code,v_bs_flag_c,v_Qty,trade.Price,trade.userID);
            else
                v_c_bail :=  trade.FrozenMargin - trade.unFrozenMargin;
                v_c_poundage := trade.FrozenFee - trade.unFrozenFee;
            end if;

            --计算挂单方保证金手续费
            v_m_bail :=  FN_V_ComputeMargin(p_Code,v_bs_flag,v_Qty,trade.Price,v_userID);
            v_m_poundage := FN_V_ComputeFee(p_Code,v_bs_flag,v_Qty,trade.Price,v_userID);

            if(v_bs_flag=1) then --如果挂标方为买方
                v_b_bail := v_m_bail;
                v_s_bail := v_c_bail;
                v_b_poundage := v_m_poundage;
                v_s_poundage := v_c_poundage;
            else
                v_b_bail := v_c_bail;
                v_s_bail := v_m_bail;
                v_b_poundage := v_c_poundage;
                v_s_poundage := v_m_poundage;
            end if;

            --获取成交号
            select SP_V_BARGAIN.nextval into v_A_TradeNo from dual;
            --写成交
            insert into v_bargain
               (contractID,  tradePartition, submitID, Code,   commodityID,   Price,       Amount, userID,       TradeTime, Section,   b_bail,   s_bail,   b_poundage,   s_poundage)
            values
               (v_A_TradeNo, 3,              trade.ID, p_Code, v_commodityID, trade.Price, v_Qty,  trade.userID, sysdate,   v_section, v_b_bail, v_s_bail, v_b_poundage, v_s_poundage);

            --改委托(当前表和历史表都有可能有数据)
            --1） 当前表
            update v_curSubmit set OrderType=v_tradeFlag,
                                   modifytime=v_orderTime,
                                   unFrozenMargin=unFrozenMargin+v_s_bail,
                                   unFrozenFee=unFrozenFee+v_s_poundage
                               where id = trade.ID;
            --2） 历史表
            update v_hisSubmit set OrderType=v_tradeFlag,
                                   modifytime=v_orderTime,
                                   unFrozenMargin=unFrozenMargin+v_s_bail,
                                   unFrozenFee=unFrozenFee+v_s_poundage
                               where id = trade.ID;

            --释放卖方冻结资金
            v_F_FrozenFunds := FN_F_UpdateFrozenFunds(trade.userID,-v_c_bail-v_c_poundage,'21');
            --收双方保证金、手续费（写流水）
            --挂单方
            v_Balance := FN_F_UpdateFundsFull(v_userID,'21002',v_m_bail,v_A_TradeNo,v_commodityID,null,null);
            v_Balance := FN_F_UpdateFundsFull(v_userID,'21001',v_m_poundage,v_A_TradeNo,v_commodityID,null,null);
            --投标方
            v_Balance := FN_F_UpdateFundsFull(trade.userID,'21002',v_c_bail,v_A_TradeNo,v_commodityID,null,null);
            v_Balance := FN_F_UpdateFundsFull(trade.userID,'21001',v_c_poundage,v_A_TradeNo,v_commodityID,null,null);
            --如果部分成交需要成交后撤单
            if(v_tradeFlag=2 and v_withdrawQty>0) then
                v_Withdraw := FN_V_Withdraw(trade.ID,0,v_withdrawQty);
            end if;

            --成交后递减商品数量
            v_Amount := v_Amount - v_Qty;
        end loop;


    --5. 将未中标委托进行撤单
    for otherwithdraw in (select ID,amount from v_curSubmitTender where Code = p_Code and id not in (select id from v_curSubmitTenderPlan where Code = p_Code))
        loop
            v_Balance := FN_V_Withdraw(otherwithdraw.ID,0,otherwithdraw.amount);
        end loop;

    --6. 清空招标委托表
    delete v_curSubmitTender where Code = p_Code;

    --更新当前交易商品表
    --update v_curCommodity set bargainType = 1, modifyTime =sysdate where Code = p_Code;
    --7. 更新商品表状态
    update v_commodity set TenderTradeConfirm = 1 where Code = p_Code;

    return 1;
exception
    when others then
    rollback;
    return -1;
end;
/

prompt
prompt Creating function SYMBOL_MD5
prompt ============================
prompt
create or replace function symbol_md5(passwd IN VARCHAR2) return varchar2 is
  retval varchar2(32);
begin
  
   retval := utl_raw.cast_to_raw(DBMS_OBFUSCATION_TOOLKIT.MD5(INPUT_STRING => passwd)) ;
   RETURN retval;

end symbol_md5;
/

prompt
prompt Creating procedure SP_COMMON_MOVEHISTORY
prompt ========================================
prompt
create or replace procedure SP_COMMON_MoveHistory(p_EndDate Date) as
/**
 * 转历史
 **/
begin
  --日志转历史
  insert into c_globallog_all_h(id,operator,operatetime,operatetype,operateip,operatortype,mark,operatecontent,currentvalue,operateresult,LogType)
  select id, operator, operatetime, operatetype, operateip, operatortype, mark, operatecontent, currentvalue, operateresult, LogType
    from c_globallog_all t where t.operatetime <= p_EndDate;
  delete from c_globallog_all t where t.operatetime <= p_EndDate;
end;
/

prompt
prompt Creating procedure SP_F_COMPUTEFIRMRIGHTS_OLD
prompt =============================================
prompt
create or replace procedure SP_F_ComputeFirmRights_old(
  p_beginDate date
)
/****
 * 计算交易商权益
****/
as
  v_lastDate     date;           -- 上一个结算日
  v_cnt          number(4);      --数字变量
  v_sumFirmFee   number(15, 2);  -- 交易商手续费合计
  v_sumFL        number(15, 2);  -- 交易商订货盈亏合计
  v_sumBalance   number(15, 2);  -- 交易商权益计算费用合计
begin

   -- 更新银行清算权益计算费用

        -- 删除银行清算权益计算费用表的当日数据
        delete from F_FirmRightsComputeFunds where b_date = p_beginDate;

        -- 取得银行清算权益计算费用表的上一个结算日
        select max(b_Date) into v_lastDate from F_FirmRightsComputeFunds;

        if(v_lastDate is null) then
          v_lastDate := to_date('2000-01-01','yyyy-MM-dd');
        end if;

       -- 将交易商当前资金表的交易商和银行清算总账费用配置表中费用类型是权益计算费用的总账代码链表
       -- 插入银行清算权益计算费用表作为当日的初始数据
       insert into F_FirmRightsComputeFunds(B_date, Firmid, Code)
         select p_beginDate,f.firmid, bc.ledgercode
         from f_firmfunds f,F_BankClearLedgerConfig bc
         where bc.feetype = 1;

        for firmRights in (select b_date, firmId, code from F_FirmRightsComputeFunds where b_date = p_beginDate)
        loop
            -- 更新银行清算权益计算费用表的上日余额
            update F_FirmRightsComputeFunds f
            set lastBalance = nvl((select balance
                 from F_FirmRightsComputeFunds where b_date = v_lastDate and firmId = firmRights.firmId and code = firmRights.code ), 0)
            where b_date = firmRights.b_date and firmId = firmRights.firmId and code = firmRights.code;

            -- 更新银行清算权益计算费用表的当日余额
            update F_FirmRightsComputeFunds f
            set balance = nvl((select bc.fieldsign*c.value as amount
                               from f_clientledger c, f_bankclearledgerconfig bc
                               where c.b_date = firmRights.b_date and c.firmId = firmRights.firmId and c.code = firmRights.code and c.code = bc.ledgercode ), 0)
            where b_date = firmRights.b_date and firmId = firmRights.firmId and code = firmRights.code;

            -- 更新银行清算权益计算费用表的当日余额为：当日余额 + 上日余额
            --（这样就可以不用到交易系统中去取这些资金项）
            update F_FirmRightsComputeFunds f
            set balance = balance + lastBalance
            where b_date = firmRights.b_date and firmId = firmRights.firmId and code = firmRights.code;

        end loop;


   -- 更新交易商清算资金

     -- 删除交易商清算资金表的当日数据
     delete from F_FirmClearFunds where b_date = p_beginDate;

     -- 将交易商当前资金表的余额插入交易商清算资金表
     insert into F_FirmClearFunds(B_date, Firmid, Balance)
     select p_beginDate, f.firmid, f.balance from f_firmfunds f;

     for firmClearFunds in (select b_date, firmId from F_FirmClearFunds where b_date = p_beginDate)
     loop
         -- 计算交易商手续费
         select nvl(sum(value), 0) sumFirmFee into v_sumFirmFee
         from F_ClientLedger c
         where b_date = firmClearFunds.b_date and firmId = firmClearFunds.firmId
         and c.code in (select LedgerCode from F_BankClearLedgerConfig where FeeType = 0);

           -- 更新交易商清算资金表的交易商手续费
           update F_FirmClearFunds
           set firmFee = v_sumFirmFee
           where b_date = firmClearFunds.b_date and firmId = firmClearFunds.firmId;

         -- 计算市场手续费

         -- 计算交易商权益冻结资金

            -- 统计银行清算权益计算费用的当日余额
            select nvl(sum(Balance), 0) sumBalance into v_sumBalance from F_FirmRightsComputeFunds where b_date = firmClearFunds.b_date and firmId = firmClearFunds.firmId;

            -- 判断是否启用订单系统
            select count(*) into v_cnt from c_trademodule where moduleId = 15 and isbalancecheck = 'Y';
            if(v_cnt > 0) then

               -- 统计订单持仓盈亏
               select nvl(sum(FloatingLoss), 0) sumFL into v_sumFL from T_H_FirmHoldSum t where t.cleardate = firmClearFunds.b_date and t.firmid = firmClearFunds.firmId;

               update F_FirmClearFunds
               set RightsFrozenFunds = v_sumBalance + v_sumFL
               where b_date = firmClearFunds.b_date and firmId = firmClearFunds.firmId;

            else
               update F_FirmClearFunds
               set RightsFrozenFunds = v_sumBalance
               where b_date = firmClearFunds.b_date and firmId = firmClearFunds.firmId;

            end if;

         -- 计算交易商权益
         update F_FirmClearFunds
         set Rights = Balance + RightsFrozenFunds
         where b_date = firmClearFunds.b_date and firmId = firmClearFunds.firmId;

     end loop;

end;
/

prompt
prompt Creating procedure SP_F_EXTRACTVOUCHERREDO
prompt ==========================================
prompt
create or replace procedure SP_F_ExtractVoucherRedo(p_beginDate date)
as
  v_num number(10);
begin
  insert into f_fundflow
    (fundflowid, firmid, oprcode, contractno, commodityid, amount, balance, appendamount, voucherno, createtime, b_date)
  select fundflowid, firmid, oprcode, contractno, commodityid, amount, balance, appendamount, voucherno, createtime, b_date
  from f_h_fundflow where b_date>=p_beginDate;

  delete from f_h_fundflow where b_date>=p_beginDate;

  update (select f.* from f_fundflow f,f_voucher v where f.voucherno=v.voucherno and v.inputuser='system') a
  set a.voucherno=null;

  delete from f_voucher where inputuser='system' and b_date>=p_beginDate;

  v_num:=FN_F_ExtractVoucher();

  if(v_num>0) then
    v_num:= fn_f_balance(p_beginDate);
  end if;
end;
/

prompt
prompt Creating procedure SP_F_SYNCHCOMMODITY
prompt ======================================
prompt
create or replace procedure SP_F_SynchCommodity(p_CommodityID varchar2) as
  v_cnt number;
begin
  select count(*) into v_cnt from f_account where code='200215'||p_CommodityID;
  if(v_cnt=0) then
    insert into f_account(Code,Name,accountLevel,dCFlag)
    select '200215'||p_CommodityID,name||p_CommodityID,3,'C' from f_account where code='200215';
  end if;

  select count(*) into v_cnt from f_account where code='209915'||p_CommodityID;
  if(v_cnt=0) then
    insert into f_account(Code,Name,accountLevel,dCFlag)
    select '209915'||p_CommodityID,name||p_CommodityID,3,'C' from f_account where code='209915';
  end if;

   select count(*) into v_cnt from f_account where code='100515'||p_CommodityID;
   if(v_cnt=0) then
    insert into f_account(Code,Name,accountLevel,dCFlag)
    select '100515'||p_CommodityID,name||p_CommodityID,3,'C' from f_account where code='100515';
  end if;

  select count(*) into v_cnt from f_account where code = '200515'||p_CommodityID;
  if(v_cnt=0) then
    insert into f_account(Code,Name,accountLevel,dCFlag)
    select '200515'||p_CommodityID,name||p_CommodityID,3,'C' from f_account where code='200515';
  end if;

  select count(*) into v_cnt from f_account where code = '200415'||p_CommodityID;
  if(v_cnt=0) then
    insert into f_account(Code,Name,accountLevel,dCFlag)
    select '200415'||p_CommodityID,name||p_CommodityID,3,'C' from f_account where code='200415';
  end if;

end;
/

prompt
prompt Creating procedure SP_M_MODULE
prompt ==============================
prompt
create or replace procedure SP_m_module
(
    p_FirmID   varchar2 --交易商代码
) as
begin
  insert into m_tradermodule
          (MODULEID, traderid, ENABLED)
        values
          (21, p_FirmID, 'Y');
end;
/

prompt
prompt Creating procedure SP_TM_MOVEHISTORY
prompt ====================================
prompt
create or replace procedure SP_TM_MoveHistory(p_EndDate Date) as
/**
 * 转历史
 **/
begin

  --监控数据转历史
  insert into tm_trademonitor_h(id, moduleid, type, num, datetime, categoryType)
  select t.id,t.moduleid,t.type,t.num,t.datetime,t.categorytype from tm_trademonitor  t where t.datetime<=p_EndDate;
  delete from tm_trademonitor t where t.datetime<=p_EndDate;

end;
/

prompt
prompt Creating procedure SP_V_FIRMADD
prompt ===============================
prompt
CREATE OR REPLACE PROCEDURE SP_V_FirmAdd( P_FIRMID in VARCHAR2)
 /****
  *增加交易商
  *
  *****/
as
     v_cnt number(5);
begin
    select count(*) into v_cnt from v_tradeuser where usercode=p_firmid;
    if(v_cnt>0) then
           return;
    end if;
 --插入交易商表，默认有竞价权限、无挂单权限
 insert into v_tradeuser(usercode,isEntry,limits)
 values(P_FIRMID,0,0);
end;
/

prompt
prompt Creating procedure SP_V_FIRMDEL
prompt ===============================
prompt
create or replace procedure SP_V_FirmDel(p_FirmID varchar2) as
/**
 * 竞价删除交易商科目
 **/
begin
  delete from v_tradeuser where usercode=p_firmid;

  update v_hisbargain set userid=userid||'_D' where userid=p_FirmID;
  --update v_hismoney set firmid=firmid||'_D' where firmid=p_FirmID;
  update v_hissubmit set userid=userid||'_D' where userid=p_FirmID;
end;
/

prompt
prompt Creating procedure SP_W_MOVEHISTORY
prompt ===================================
prompt
create or replace procedure SP_W_MoveHistory(p_EndDate Date) as
/**
 * 转历史
 **/
begin
  --日志转历史
  insert into W_GLOBALLOG_ALL_H (ID,OPERATOR,warehouseID,OPERATETIME,OPERATETYPE,OPERATEIP,OPERATORTYPE,MARK,OPERATECONTENT,CURRENTVALUE,OPERATERESULT,LogType) select ID,OPERATOR,warehouseID,OPERATETIME,OPERATETYPE,OPERATEIP,OPERATORTYPE,MARK,OPERATECONTENT,CURRENTVALUE,OPERATERESULT,LogType from W_GLOBALLOG_ALL g where g.OPERATETIME<=p_EndDate;
  delete from W_GLOBALLOG_ALL g where g.OPERATETIME<=p_EndDate;
end;
/

prompt
prompt Creating package body DATE_VIEW_PARAM
prompt =====================================
prompt
create or replace package body date_view_param is
  startValue varchar2(16);
  endValue varchar2(16);
  function set_start(startdate varchar2) return varchar2 is
    begin
      startValue:=startdate;
      return startValue;
    end;
  function get_start return varchar2 is
    begin
      return nvl(startValue,'1900-01-01');
    end;
  function set_end(enddate varchar2) return varchar2 is
    begin
      endValue:=enddate;
      return endValue;
    end;
  function get_end return varchar2 is
    begin
      return nvl(endValue,'9900-01-01');
    end;
  end date_view_param;
/


spool off
