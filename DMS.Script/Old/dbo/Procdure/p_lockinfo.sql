DROP proc [dbo].[p_lockinfo]
GO



/*--��������

 �鿴��ǰ����,����������,�����Զ�ɱ��������

 ��Ϊ���������,�����������������,ֻ�ܲ鿴��������
 ��Ȼ,�����ͨ����������,������û������,��ֻ�鿴��������

 ��л: caiyunxia,jiangopen ��λ�ṩ�Ĳο���Ϣ

--�޽� 2004.4--*/

/*--����ʾ��

 exec p_lockinfo
--*/
create proc [dbo].[p_lockinfo]
@kill_lock_spid bit=1,  --�Ƿ�ɱ�������Ľ���,1 ɱ��, 0 ����ʾ
@show_spid_if_nolock bit=1 --���û�������Ľ���,�Ƿ���ʾ����������Ϣ,1 ��ʾ,0 ����ʾ
as
declare @count int,@s nvarchar(1000),@i int
select id=identity(int,1,1),��־,
 ����ID=spid,�߳�ID=kpid,�����ID=blocked,���ݿ�ID=dbid,
 ���ݿ���=db_name(dbid),�û�ID=uid,�û���=loginame,�ۼ�CPUʱ��=cpu,
 ��½ʱ��=login_time,��������=open_tran, ����״̬=status,
 ����վ��=hostname,Ӧ�ó�����=program_name,����վ����ID=hostprocess,
 ����=nt_domain,������ַ=net_address
into #t from(
 select ��־='�����Ľ���',
  spid,kpid,a.blocked,dbid,uid,loginame,cpu,login_time,open_tran,
  status,hostname,program_name,hostprocess,nt_domain,net_address,
  s1=a.spid,s2=0
 from master..sysprocesses a join (
  select blocked from master..sysprocesses group by blocked
  )b on a.spid=b.blocked where a.blocked=0
 union all
 select '|_����Ʒ_>',
  spid,kpid,blocked,dbid,uid,loginame,cpu,login_time,open_tran,
  status,hostname,program_name,hostprocess,nt_domain,net_address,
  s1=blocked,s2=1
 from master..sysprocesses a where blocked<>0
)a order by s1,s2

select @count=@@rowcount,@i=1

if @count=0 and @show_spid_if_nolock=1
begin
 insert #t
 select ��־='�����Ľ���',
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
  declare @spid varchar(10),@��־ varchar(10)
  while @i<=@count
  begin
   select @spid=����ID,@��־=��־ from #t where id=@i
   insert #t1 exec('dbcc inputbuffer('+@spid+')')
   if @��־='�����Ľ���' exec('kill '+@spid)
   set @i=@i+1
  end
 end
 else
  while @i<=@count
  begin
   select @s='dbcc inputbuffer('+cast(����ID as varchar)+')' from #t where id=@i
   insert #t1 exec(@s)
   set @i=@i+1
  end
 select a.*,���̵�SQL���=b.EventInfo
 from #t a join #t1 b on a.id=b.id
end


GO


