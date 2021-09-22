DROP proc [dbo].[p_lockinfo]
GO



/*--处理死锁

 查看当前进程,或死锁进程,并能自动杀掉死进程

 因为是针对死的,所以如果有死锁进程,只能查看死锁进程
 当然,你可以通过参数控制,不管有没有死锁,都只查看死锁进程

 感谢: caiyunxia,jiangopen 两位提供的参考信息

--邹建 2004.4--*/

/*--调用示例

 exec p_lockinfo
--*/
create proc [dbo].[p_lockinfo]
@kill_lock_spid bit=1,  --是否杀掉死锁的进程,1 杀掉, 0 仅显示
@show_spid_if_nolock bit=1 --如果没有死锁的进程,是否显示正常进程信息,1 显示,0 不显示
as
declare @count int,@s nvarchar(1000),@i int
select id=identity(int,1,1),标志,
 进程ID=spid,线程ID=kpid,块进程ID=blocked,数据库ID=dbid,
 数据库名=db_name(dbid),用户ID=uid,用户名=loginame,累计CPU时间=cpu,
 登陆时间=login_time,打开事务数=open_tran, 进程状态=status,
 工作站名=hostname,应用程序名=program_name,工作站进程ID=hostprocess,
 域名=nt_domain,网卡地址=net_address
into #t from(
 select 标志='死锁的进程',
  spid,kpid,a.blocked,dbid,uid,loginame,cpu,login_time,open_tran,
  status,hostname,program_name,hostprocess,nt_domain,net_address,
  s1=a.spid,s2=0
 from master..sysprocesses a join (
  select blocked from master..sysprocesses group by blocked
  )b on a.spid=b.blocked where a.blocked=0
 union all
 select '|_牺牲品_>',
  spid,kpid,blocked,dbid,uid,loginame,cpu,login_time,open_tran,
  status,hostname,program_name,hostprocess,nt_domain,net_address,
  s1=blocked,s2=1
 from master..sysprocesses a where blocked<>0
)a order by s1,s2

select @count=@@rowcount,@i=1

if @count=0 and @show_spid_if_nolock=1
begin
 insert #t
 select 标志='正常的进程',
  spid,kpid,blocked,dbid,db_name(dbid),uid,loginame,cpu,login_time,
  open_tran,status,hostname,program_name,hostprocess,nt_domain,net_address
 from master..sysprocesses
 set @count=@@rowcount
end

if @count>0
begin
 create table #t1(id int identity(1,1),a nvarchar(30),b Int,EventInfo nvarchar(255))
 if @kill_lock_spid=1
 begin
  declare @spid varchar(10),@标志 varchar(10)
  while @i<=@count
  begin
   select @spid=进程ID,@标志=标志 from #t where id=@i
   insert #t1 exec('dbcc inputbuffer('+@spid+')')
   if @标志='死锁的进程' exec('kill '+@spid)
   set @i=@i+1
  end
 end
 else
  while @i<=@count
  begin
   select @s='dbcc inputbuffer('+cast(进程ID as varchar)+')' from #t where id=@i
   insert #t1 exec(@s)
   set @i=@i+1
  end
 select a.*,进程的SQL语句=b.EventInfo
 from #t a join #t1 b on a.id=b.id
end


GO


