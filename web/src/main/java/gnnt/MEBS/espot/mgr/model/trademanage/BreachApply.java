package gnnt.MEBS.espot.mgr.model.trademanage;

import gnnt.MEBS.common.mgr.model.StandardModel;
import gnnt.MEBS.common.mgr.model.StandardModel.PrimaryInfo;
import gnnt.MEBS.common.mgr.model.translate.ClassDiscription;
import gnnt.MEBS.espot.mgr.model.firmmanage.MFirm;
import java.util.Date;

public class BreachApply
  extends StandardModel
{
  private static final long serialVersionUID = 1L;
  @ClassDiscription(name="申请ID", description="")
  private Long breachApplyId;
  @ClassDiscription(name="合同号", description="")
  private Long tradeNo;
  @ClassDiscription(name="申请方交易商", description="对应交易商代码")
  private MFirm firm;
  @ClassDiscription(name="申请时间", description="")
  private Date applyTime;
  @ClassDiscription(name="处理时间", description="")
  private Date processTime;
  @ClassDiscription(name="状态", description="状态 0：未处理 1：已撤销 2：违约方满足条件撤销 3：违约处理")
  private Integer status;
  @ClassDiscription(name="延期时间", description="")
  private Long delayTime;
  
  public Long getDelayTime()
  {
    return this.delayTime;
  }
  
  public void setDelayTime(Long paramLong)
  {
    this.delayTime = paramLong;
  }
  
  public Long getBreachApplyId()
  {
    return this.breachApplyId;
  }
  
  public void setBreachApplyId(Long paramLong)
  {
    this.breachApplyId = paramLong;
  }
  
  public Long getTradeNo()
  {
    return this.tradeNo;
  }
  
  public void setTradeNo(Long paramLong)
  {
    this.tradeNo = paramLong;
  }
  
  public MFirm getFirm()
  {
    return this.firm;
  }
  
  public void setFirm(MFirm paramMFirm)
  {
    this.firm = paramMFirm;
  }
  
  public Date getApplyTime()
  {
    return this.applyTime;
  }
  
  public void setApplyTime(Date paramDate)
  {
    this.applyTime = paramDate;
  }
  
  public Date getProcessTime()
  {
    return this.processTime;
  }
  
  public void setProcessTime(Date paramDate)
  {
    this.processTime = paramDate;
  }
  
  public Integer getStatus()
  {
    return this.status;
  }
  
  public void setStatus(Integer paramInteger)
  {
    this.status = paramInteger;
  }
  
  public StandardModel.PrimaryInfo fetchPKey()
  {
    return new StandardModel.PrimaryInfo("breachApplyId", this.breachApplyId);
  }
}
