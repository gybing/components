package gnnt.MEBS.integrated.front.model;

import gnnt.MEBS.common.front.model.StandardModel;
import gnnt.MEBS.common.front.model.StandardModel.PrimaryInfo;
import gnnt.MEBS.common.front.model.translate.ClassDiscription;
import java.util.Date;

public class Notice
  extends StandardModel
{
  private static final long serialVersionUID = -6797527237302581869L;
  @ClassDiscription(name="公告ID", description="")
  private Long noticeId;
  @ClassDiscription(name="公告标题", description="")
  private String title;
  @ClassDiscription(name="公告内容", description="")
  private String content;
  @ClassDiscription(name="创建时间", description="")
  private Date createTime;
  @ClassDiscription(name="管理员ID", description="")
  private String userId;
  
  public Long getNoticeId()
  {
    return this.noticeId;
  }
  
  public void setNoticeId(Long paramLong)
  {
    this.noticeId = paramLong;
  }
  
  public String getTitle()
  {
    return this.title;
  }
  
  public void setTitle(String paramString)
  {
    this.title = paramString;
  }
  
  public String getContent()
  {
    return this.content;
  }
  
  public void setContent(String paramString)
  {
    this.content = paramString;
  }
  
  public Date getCreateTime()
  {
    return this.createTime;
  }
  
  public void setCreateTime(Date paramDate)
  {
    this.createTime = paramDate;
  }
  
  public String getUserId()
  {
    return this.userId;
  }
  
  public void setUserId(String paramString)
  {
    this.userId = paramString;
  }
  
  public StandardModel.PrimaryInfo fetchPKey()
  {
    return new StandardModel.PrimaryInfo("noticeId", this.noticeId);
  }
}
