create database QuanLySanXuat
go

use QuanLySanXuat
go

set dateformat dmy
go

create table SANPHAM(
	MASP varchar(10) not null,
	TENSP nvarchar(100) null,
	DVT nvarchar(20) null,
	DONGIA int not null
	constraint prim_sp Primary Key(MASP)
)
go

create table PHANXUONG(
	MAPX varchar(10) not null,
	TENPX nvarchar(50) null
	constraint prim_px Primary Key(MAPX)
)
go

create table PX_SP(
	MAPX varchar(10) not null,
	MASP varchar(10) not null,
	DINHMUC1 int not null
	constraint prim_ps Primary Key(MAPX, MASP)
)
go

create table CN_SP(
	MACN varchar(10) not null,
	MASP varchar(10) not null,
	DINHMUC2 int not null
	constraint prim_cs Primary Key(MACN, MASP)
)
go

create table CONGNHAN(
	MACN varchar(15) not null,
	HOCN nvarchar(40) null,
	TENCN nvarchar(30) not null,
	GIOITINH nvarchar(30) not null,
	NAMSINH int not null,
	QUEQUAN nvarchar(50) null,
	NGAYNV date not null,
	LCB int not null,
	SOCMND varchar(20) null,
	MAPX varchar(10) not null
	constraint prim_cn Primary Key(MACN)
)
go

create table SANXUAT(
	NGAYSX date not null,
	MACN varchar(15) not null,
	MASP varchar(10) not null,
	SOLUONG int not null
	constraint prim_sx Primary Key(NGAYSX, MACN, MASP)
)
go

create table VANG(
	NGAY date not null,
	MACN varchar(15) not null,
	LOAIVANG varchar(2) not null
	constraint prim_v Primary Key(NGAY, MACN)
)
go

/* 2. Lập bảng tầm ảnh hưởng của các RBTV sau, sau đó tạo các Trigger cần thiết để kiểm tra
các RBTV sau:
2.1. Ngày ghi nhận kết quả sản xuất của công nhân phải sau ngày nhận việc của công
nhân đó. */

create trigger trg_cau2_1 on SANXUAT 
for insert, update as
begin
	declare @ngayNhanKQ date
	declare @ngayVaoLam date
	select @ngayNhanKQ = NGAYSX from inserted
	select @ngayVaoLam = cn.NGAYNV from inserted i join CONGNHAN cn on
								i.MACN = cn.MACN
	if(DATEDIFF(DAY, @ngayVaoLam, @ngayNhanKQ) < 0)
		begin
			raiserror('Ngay nhan ket qua san xuat phai sau ngay nhan viec cua cong nhan do', 10, 1)
			rollback
		end
end
go

/* 2.2. Công nhân chỉ được phân công những sản phẩm mà phân xưởng của công nhân đó
có đảm nhận.  */
create trigger trg_cau2_2 on CN_SP
for insert, update as
begin
	if  exists (select * from inserted i join CONGNHAN cn
								on i.MACN = cn.MACN join PX_SP ps
								on cn.MAPX = ps.MAPX
					where ps.MASP = i.MASP)
	begin
		raiserror('Cong nhan chi duoc phan cong nhung san pham ma phan xuong cua cong nhan do co dam nhan', 10, 1)
		rollback
	end
end
go

/* 2.3. Một phân xưởng không được phụ trách nhiều hơn 5 sản phẩm */
create trigger trg_cau2_3 on PX_SP
 for insert, update as
 begin
	declare @count int
	select @count = COUNT(*) from inserted i join PX_SP ps
							on i.MAPX = ps.MAPX
						group by ps.MAPX
	if(@count > 5)
	begin
		raiserror('Phan xuong khong duoc phu trach nhieu hon 5 san pham', 10, 1)
		rollback
	end
 end
 go
 
 /* 2.4. Một công nhân không được phân công nhiều hơn 2 sản phẩm */
 create trigger trg_cau2_4 on CN_SP
 for insert, update as
 begin
	declare @count int
	select @count = COUNT(*) from inserted i join CN_SP cs
						on i.MACN = cs.MACN
						group by cs.MACN
	if(@count > 2)
		begin
			raiserror('1 cong nhan khong duoc phan cong nhieu hon 2 san pham', 10, 1)
		rollback
		end
 end
 go
 
 /* 3.1. Lấy danh sách công nhân với các thông tin: MACN, HOCN, TENCN, GIOITINH,
TENPX, MAPX */
create view v_cau3_1 as
select cn.MACN, cn.HOCN, cn.TENCN, cn.GIOITINH, px.MAPX, px.TENPX
 from CONGNHAN cn join PHANXUONG px
						on cn.MAPX = px.MAPX
go

/* 3.2. Cho biết sự phân công sản xuất của từng công nhân trong phân xưởng PX1 (mã phân
xưởng). Kết quả gồm các thông tin: Mã công nhân, họ và tên, mã sp, tensp, định mức */
create view v_cau3_2 as
select cn.MACN, cn.HOCN, cn.TENCN, sp.MASP, sp.TENSP, cs.DINHMUC2
	from CONGNHAN cn join CN_SP cs on cn.MACN = cs.MACN
				join SANPHAM sp on cs.MASP = sp.MASP
				join PX_SP ps on sp.MASP = ps.MASP
		where ps.MAPX = 'PX1'
go

/* 3.3. Cho biết tổng số lượng mỗi loại sản phẩm mà mỗi công nhân làm được trong tháng 2
năm 2020. */
create view v_cau3_3 as
select cn.MACN, sx.MASP, SUM(sx.SOLUONG)TONGSOLUONG
	from CONGNHAN cn join SANXUAT sx on cn.MACN = sx.MACN
		where MONTH(sx.NGAYSX) = 2 and YEAR(sx.NGAYSX) = 2020
			group by cn.MACN, sx.MASP
go

/* 3.4. Cho biết tổng số lượng mỗi loại sản phẩm mà mỗi công nhân làm được trong từng
tháng, so sánh với định mức được giao cho công nhân. Kết quả gồm các thông tin:
MACN, HOCN, TENCN, TENX, MASP, TENSP, TONG_SOLG_SX, DINHMUC2,
SO_VUOT_DM, KETQUA. Trong đó:
SO_VUOT_DM: Là số lượng SP sản xuất vượt định mức (<0 nếu chưa đạt định
mức) KETQUA là ‘Đạt’ nếu SO_VUOT_DM>=0, “Không đạt’ nếu SO_VUOT_DM<0. */



create view v_cau3_4 as
select cn.MACN, cn.HOCN, cn.TENCN, sp.MASP, sp.TENSP ,SUM(sx.SOLUONG) as TONG_SOLG_SX, cs.DINHMUC2,
 (SUM(sx.SOLUONG) - cs.DINHMUC2) as SO_VUOT_DM,
 case 
	when (SUM(sx.SOLUONG) - cs.DINHMUC2) >= 0 then 'Dat'
	when (SUM(sx.SOLUONG) - cs.DINHMUC2) < 0 then 'Khong Dat'
 end as KETQUA
	from CONGNHAN cn join CN_SP cs on cn.MACN = cs.MACN
					join SANPHAM sp on sp.MASP = cs.MASP
					join SANXUAT sx on sx.MASP = cs.MASP
		group by MONTH(sx.NGAYSX), YEAR(sx.NGAYSX), cn.MACN, cn.HOCN, cn.TENCN, sp.MASP, sp.TENSP, cs.DINHMUC2
go

/* 3.5. Cho biết kết quả chấm công tháng 4 năm 2020 của từng công nhân với các thông tin:
MAPX, TENPX, MACN, HOCN, TENCN, Tổng_số_ngày_vắng_KP,

Tổng_số_ngày_vắng_CP, Tổng_số_ngày_làm_việc. Biết rằng: Số ngày làm việc = 24-
0.5 * Số ngày vắng loại 1⁄2 - số ngày vắng không phép – số ngày vắng có phép. */
create view v_cau3_5 as
select px.MAPX, px.TENPX, cn.MACN, cn.HOCN, cn.TENCN, 
count(case
	when v.LOAIVANG = 'KP' then 1 else 0
end) as TONG_SO_NGAY_VANG_KP,
COUNT(case
	when v.LOAIVANG = 'CP' then 1 else 0
end) as TONG_SO_NGAY_VANG_CP,
(24 * 0.5 * count(case
	when v.LOAIVANG = 'KP' then 1 else 0
end) - COUNT(case
	when v.LOAIVANG = 'CP' then 1 else 0
end) ) as SO_NGAY_LAM_VIEC
	from CONGNHAN cn right join PHANXUONG px on cn.MAPX = px.MAPX
					right join VANG v on cn.MACN = v.MACN
		group by px.MAPX, px.TENPX, cn.MACN, cn.HOCN, cn.TENCN
go


/* 3.6. Cho biết số lượng công nhân trong mỗi phân xưởng. Kết quả gồm các thông tin: Mã
PX, Tên phân xưởng, số lượng công nhân nam, số lượng công nhân nữ, tổng số công
nhân. */
create view v_cau3_6 as
select px.MAPX, px.TENPX,
COUNT(
case
	when cn.GIOITINH = 'nam' then 1 else 0
end) as SL_CONG_NHAN_NAM,
COUNT(
case 
	when cn.GIOITINH = 'nu' then 1 else 0
end) as SL_CONG_NHAN_NU,
COUNT(cn.MACN) as TONGSOCONGNHAN
	from PHANXUONG px right join CONGNHAN cn on px.MAPX = cn.MAPX
		group by px.MAPX, px.TENPX
go

/* 3.7. Cho biết tổng số lượng mỗi loại sản phẩm sản xuất được trong từng tháng/năm với
các thông tin: Năm, Tháng, Mã sp, tên sp, Tổng số lượng */
create view v_cau3_7 as 
select YEAR(sx.NGAYSX) as NAM, MONTH(sx.NGAYSX) as THANG,  sp.TENSP, SUM(sx.SOLUONG) TONGSOLUONG
	from SANPHAM sp right join SANXUAT sx on sp.MASP = sx.MASP
		group by YEAR(sx.NGAYSX), MONTH(sx.NGAYSX), sp.MASP, sp.TENSP
go

/* 4. Viết lệnh tạo các thủ tục (stored procedure) chèn dòng mới vào các Table với giá trị
được cho vào bởi các tham số của thủ tục sau khi kiểm tra các ràng buộc toàn vẹn còn
lại (chưa khai báo constrain khi tạo table). */

-------- San Pham ----------
create proc proc_store_sp @masp varchar(10), @tensp nvarchar(100), @dvt nvarchar(20), @dongia int as
if(@masp = ''  and @dongia = '')
	begin
		raiserror('Masp va dongia khong duoc de trong', 10, 1)
		rollback
	end
else if(@masp = '')
	begin 
		raiserror('Masp khong duoc de trong', 10, 1)
		rollback
	end
else if(@dongia = '')
	begin 
		raiserror('Don gia khong duoc de trong', 10, 1)
		rollback
	end
else if(@dongia < 0)
	begin 
		raiserror('Don gia khong duoc < 0', 10, 1)
		rollback
	end
else 
	begin
		insert into SANPHAM(MASP, TENSP, DVT, DONGIA) values
		(@masp, @tensp, @dvt, @dongia)
	end
go

exec proc_store_sp @masp = '', @tensp = 'Hello', @dvt = 'vnd', @dongia = 100000
select * from SANPHAM
go

---- Phân xưởng --------
create proc proc_store_px @mapx varchar(10), @tenpx nvarchar(50) as
if(@mapx = '' )
	begin
		raiserror('Mapx khong duoc de trong', 10, 1)
		rollback
	end
else 
	begin
		insert into PHANXUONG(MAPX, TENPX) values
		(@mapx, @tenpx)
	end
go

-------- PX_SP -------
create proc proc_store_ps @mapx varchar(10), @masp varchar(10), @dinhmuc1 int as
if(@mapx = '' and @masp = '' and @dinhmuc1 = '')
	begin
		raiserror('Mapx, masp, dinhmuc 1 khong duoc de trong', 10, 1)
		rollback
	end
else if(@mapx = '' and @masp = '')
	begin
		raiserror('Mapx, masp khong duoc de trong', 10, 1)
		rollback
	end
else if(@mapx = '' and @dinhmuc1 = '')
	begin
		raiserror('Mapx, dinhmuc1 khong duoc de trong', 10, 1)
		rollback
	end
else if(@mapx = '')
	begin
		raiserror('Mapx khong duoc de trong', 10, 1)
		rollback
	end
else if(@masp = '')
	begin
		raiserror('Masp khong duoc de trong', 10, 1)
		rollback
	end
else if(@dinhmuc1 = '')
	begin
		raiserror('dinhmuc1 khong duoc de trong', 10, 1)
		rollback
	end
else if(@dinhmuc1 < 0)
	begin
		raiserror('dinhmuc1 khong duoc nho hon 0', 10, 1)
		rollback
	end
else 
	begin
		insert into PX_SP(MAPX, MASP, DINHMUC1) values
		(@mapx, @masp, @dinhmuc1)
	end
go

------- CN-SP ---------
create proc proc_store_ns @macn varchar(10), @masp varchar(10), @dinhmuc2 int as
if(@macn = '' and @masp = '' and @dinhmuc2 = '')
	begin
		raiserror('Macn, masp, dinhmuc 2 khong duoc de trong', 10, 1)
		rollback
	end
else if(@macn = '' and @masp = '')
	begin
		raiserror('Mapx, masp khong duoc de trong', 10, 1)
		rollback
	end
else if(@macn = '' and @dinhmuc2 = '')
	begin
		raiserror('Mapx, dinhmuc1 khong duoc de trong', 10, 1)
		rollback
	end
else if(@macn = '')
	begin
		raiserror('Mapx khong duoc de trong', 10, 1)
		rollback
	end
else if(@masp = '')
	begin
		raiserror('Masp khong duoc de trong', 10, 1)
		rollback
	end
else if(@dinhmuc2 = '')
	begin
		raiserror('dinhmuc1 khong duoc de trong', 10, 1)
		rollback
	end
else if(@dinhmuc2 < 0)
	begin
		raiserror('dinhmuc1 khong duoc nho hon 0', 10, 1)
		rollback
	end
else 
	begin
		insert into PX_SP(MAPX, MASP, DINHMUC1) values
		(@macn, @masp, @dinhmuc2)
	end
go

-------------- Công Nhân ----------------
create proc proc_store_cn @macn varchar(15), @hocn nvarchar(40), @tencn nvarchar(30),
@gioitinh nvarchar(30), @namsinh int, @quequan nvarchar(50), @ngaynv date, @lcb int,
@socmnd varchar(20), @mapx varchar(10) as
if(@macn = '')
begin
		raiserror('macn khong duoc de trong', 10, 1)
		rollback
	end
else if(@tencn = '')
	begin
		raiserror('ten cong nhan khong duoc de trong', 10, 1)
		rollback
	end
else if(@gioitinh = '')
	begin
		raiserror('gioi tinh khong duoc de trong', 10, 1)
		rollback
	end
else if(@namsinh = '')
	begin
		raiserror('nam sinh khong duoc de trong', 10, 1)
		rollback
	end
else if(YEAR(@ngaynv) - @namsinh >= 18)
	begin
		raiserror('Cong nhan khong du 18 tuoi khong duoc de trong', 10, 1)
		rollback
	end
else if(@ngaynv = '')
	begin
		raiserror('Ngay nhan viec khong duoc de trong', 10, 1)
		rollback
	end
else if(@lcb = '')
	begin
		raiserror('Luong co ban khong duoc de trong', 10, 1)
		rollback
	end
else if(@lcb < 0)
	begin
		raiserror('Luong co ban khong duoc nho hon 0', 10, 1)
		rollback
	end
else if(@mapx = '')
	begin
		raiserror('mapx khong duoc de trong', 10, 1)
		rollback
	end
else 
	begin
		insert into CONGNHAN values
		(@macn, @hocn, @tencn, @gioitinh, @namsinh, @quequan, @ngaynv, @lcb, @socmnd, @mapx)
	end
go

-------- San xuat ------------
create proc proc_store_sx @ngaysx date, @macn varchar(15), @masp varchar(10), @soluong int as
if(@ngaysx = '')
	begin
		raiserror('ngay san xuat khong duoc de trong', 10, 1)
		rollback
	end
else if(@macn = '' )
	begin
		raiserror('Macn khong duoc de trong', 10, 1)
		rollback
	end
else if(@masp = '')
	begin
		raiserror('Masp khong duoc de trong', 10, 1)
		rollback
	end
else 
	begin
		insert into SANXUAT values
		(@ngaysx, @macn, @masp, @soluong)
	end
go

----------- Vang --------------
create proc proc_store_v @ngay date, @macn varchar(15), @loaivang varchar(2) as
if(@ngay = '')
	begin
		raiserror('ngay khong duoc de trong', 10, 1)
		rollback
	end
else if(@macn = '' )
	begin
		raiserror('Macn khong duoc de trong', 10, 1)
		rollback
	end
else if(@loaivang = '')
	begin
		raiserror('Masp khong duoc de trong', 10, 1)
		rollback
	end
else if(@loaivang != 'CP' or @loaivang != 'KP')
	begin
		raiserror('Khong nhap dung loai vang khong duoc de trong', 10, 1)
		rollback
	end
else 
	begin
		insert into VANG values
		(@ngay, @macn, @loaivang)
	end
go
/* 5.1 Trả về kết quả thống kê số lượng công nhân trong từng phân xưởng với các thông tin:
MAPX, TENPX, Tongsocongnhan,So_cong_nhan_nu, So_cong_nhan_nam */
create function f_tk_slcn()
returns table
as
	return (select px.MAPX, px.TENPX,
COUNT(
case
	when cn.GIOITINH = 'nam' then 1 else 0
end) as SL_CONG_NHAN_NAM,
COUNT(
case 
	when cn.GIOITINH = 'nu' then 1 else 0
end) as SL_CONG_NHAN_NU,
COUNT(cn.MACN) as TONGSOCONGNHAN
	from PHANXUONG px right join CONGNHAN cn on px.MAPX = cn.MAPX
		group by px.MAPX, px.TENPX)
go

SELECT * FROM  f_tk_slcn()


/* 5.2. Nhận vào tham số là mã số của một phân xưởng, trả về danh sách công nhân thuộc
phân xưởng đó với các thông tin: MACN, HOCN, TENCN, QUEQUAN, NAMSINH,
NGAYNV, MASP, TENSP,DINHMUC, trong đó: MASP,TENSP, DINHMUC là mã số,
tên và định mức sản phẩm được phân công cho công nhân . Kết quả sắp tăng dần
theo tên, họ của công nhân. */
create function f_cau5_2(
	@mapx as varchar
	)
returns table
as
	return (select cn.MACN, cn.HOCN, cn.TENCN, cn.QUEQUAN, cn.NAMSINH, cn.NGAYNV,
	sp.MASP, sp.TENSP, cs.DINHMUC2
		from CN_SP cs right join CONGNHAN cn on cs.MACN = cn.MACN
					left join SANPHAM sp on cs.MASP = sp.MASP
					right join PX_SP ps on ps.MASP = sp.MASP
			where ps.MAPX = @mapx	
	)
go

/* 5.3. Nhận vào 3 tham số tương ứng với ngày đầu, ngày cuối và mã số của một công
nhân, trả về chi tiết kết quả sản xuất trong khoảng thời gian giữa 2 ngày của công
nhân đã cho với các thông tin: NGAYSX, MASP, TENSP, SOLUONG. Săp xếp kết
quả giảm dần theo ngày sản xuất */
create function f_cau5_3(
	@ngaydau as date,
	@ngaycuoi as date,
	@macn as varchar
)
returns table
as
	return(
		select sx.NGAYSX, sx.MASP, sp.TENSP, sx.SOLUONG
			from SANPHAM sp right join SANXUAT sx on sp.MASP = sx.MASP
				where sx.NGAYSX between @ngaydau and @ngaycuoi
				group by sx.NGAYSX, sx.MASP, sp.TENSP, sx.SOLUONG
	)
go
/* 5.4. Nhận vào 3 tham số là tháng, năm và mã số của một phân xưởng, trả về kết quả chấm
công trong tháng, năm của phân xưởng đã cho (nếu tham số mã phân xưởng không
đượccung cấp thì lấy tất cả các phân xưởng). Kết quả gồm các thông tin: MAPX, TENPX,
MACN, HOCN, TENCN, Tổng_số_ngày_vắng_KP, Tổng_số_ngày_vắng_CP,
Tổng_số_ngày_làm_việc. Biết rằng: Số ngày làm việc = 24-0.5 * Số buổi vắng loại 1⁄2-
số buổi vắng không phép – số buổi vắng có phép. */

create function f_cau5_4(
	@thang as int,
	@nam as int,
	@mapx as varchar
)
returns table
as
return(
	select px.MAPX, px.TENPX, cn.MACN, cn.HOCN, cn.TENCN, 
count(case
	when v.LOAIVANG = 'KP' then 1 else 0
end) as TONG_SO_NGAY_VANG_KP,
COUNT(case
	when v.LOAIVANG = 'CP' then 1 else 0
end) as TONG_SO_NGAY_VANG_CP,
(24 * 0.5 * count(case
	when v.LOAIVANG = 'KP' then 1 else 0
end) - COUNT(case
	when v.LOAIVANG = 'CP' then 1 else 0
end) ) as SO_NGAY_LAM_VIEC
	from CONGNHAN cn right join PHANXUONG px on cn.MAPX = px.MAPX
					right join VANG v on cn.MACN = v.MACN
		where px.MAPX = @mapx and Month(v.NGAY) = @thang and YEAR(v.NGAY) = @nam
		group by px.MAPX, px.TENPX, cn.MACN, cn.HOCN, cn.TENCN	
)
go

/* 5.5. Nhận vào 3 các tham số tương ứng với tháng, năm và mã số của một phân xưởng, trả
về tổng hợp kết quả sản xuất của phân xưởng trong tháng, năm đã cho với các thông tin:
MASP, TENSP, DVT, DINHMUC, TONG_SOLG_SX, VUOT, KETQUA. Trong đó:
DINHMUC: Là định mức sản phẩm được giao cho phân xưởng
TONG_SOLG_SX: Là tổng số lượng của sản phẩm đã sản xuất trong tháng, năm của
phân xưởng
VUOT: Tổng số lượng đã sx – Định mức
DAT: ‘Đạt’ nếu VUOT>=0, ngược lại kết quả ‘Chưa đạt’ */
create function f_cau5_5(
	@thang as int,
	@nam as int,
	@mapx as varchar
)
returns table
as
return(	
	select sp.MASP, sp.TENSP, sp.DVT, ps.DINHMUC1 ,SUM(sx.SOLUONG) as TONG_SOLG_SX,
 (SUM(sx.SOLUONG) - ps.DINHMUC1) as SO_VUOT_DM,
 case 
	when (SUM(sx.SOLUONG) - ps.DINHMUC1) >= 0 then 'Dat'
	when (SUM(sx.SOLUONG) - ps.DINHMUC1) < 0 then 'Khong Dat'
 end as KETQUA
	from SANPHAM sp join PX_SP ps on sp.MASP = ps.MASP
					left join SANXUAT sx on sp.MASP = sx.MASP
		where MONTH(sx.NGAYSX) = @thang and YEAR(sx.NGAYSX) = @nam and ps.MAPX = @mapx
		group by sp.MASP, sp.TENSP, sp.DVT, ps.DINHMUC1
)
go

/* 5.6. Nhận vào 2 tham số là năm và giới tính, trả về kết quả thống kê số lượng công
nhân thuộc giới tính và có có năm sinh sau năm đã cho. Kế quả gồm các thông tin:
MAPX, TENPX,SO_LG_CONGNHAN. */
create function f_cau5_6(
	@nam as int,
	@gioitinh as nvarchar
)
returns table
as
return(
	select px.MAPX, px.TENPX, 
	COUNT(
	case
		when cn.GIOITINH = @gioitinh then 1 else 0
		end) as SO_LG_CONGNHAN
		from CONGNHAN cn left join PHANXUONG px on cn.MAPX = px.MAPX
			where cn.NAMSINH = @nam
				group by px.MAPX, px.TENPX
)
go

/* 5.7. Nhận vào 3 tham số là tháng, năm và mã phân xưởng. trả về kết quả là tổng tiền
công phải trả cho phân xưởng trong tháng, năm đã cho (nếu không cung cấp mã
phân xưởng thì lấy tất cả các phân xưởng). Kết quả với các thông tin : MAPX,
TENPX, TONGTIENCONG, trong đó TONGTIENCONG = Tổng số lượng * đơn giả
của tất cả các sản phẩm phân xưởng sản xuất được trong tháng. */
create function cau5_7(
	@thang as int,
	@nam as int,
	@mapx as varchar
)
returns table
as
return(
	select ps.MAPX, px.TENPX, (SUM(sx.SOLUONG) * sp.DONGIA) as TONGTIENCONG
		from PHANXUONG px left join PX_SP ps on px.MAPX = ps.MAPX
							inner join SANPHAM sp on sp.MASP =  ps.MASP
							inner join SANXUAT sx on sx.MASP = ps.MASP
			where MONTH(sx.NGAYSX) = @thang and YEAR(sx.NGAYSX) = @nam and px.MAPX = @mapx
				group by ps.MAPX, px.TENPX, sp.DONGIA
)
go