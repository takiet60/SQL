create database QLGiaoVu;
go
use QLGiaoVu;
set dateformat DMY;
go
create table HOCVIEN
(
	MAHV		char(5)PRIMARY KEY,
	HO		varchar(40),
	TEN		varchar(10),
	NGSINH	smalldatetime,
	GIOITINH	varchar(3),
	NOISINH	varchar(40),
	MALOP	char(3)
);
go
CREATE TABLE LOP
(
	MALOP	char(3)PRIMARY KEY,
	TENLOP	varchar(40),
	TRGLOP	char(5)FOREIGN KEY REFERENCES HOCVIEN(MAHV),
	SISO		tinyint,
	MAGVCN	char(4)
);
go
CREATE TABLE KHOA
(
	MAKHOA	varchar(4) PRIMARY KEY,
	TENKHOA	varchar(40),
	NGTLAP	smalldatetime,
	TRGKHOA	char(4)
);
go
CREATE TABLE MONHOC
(
	MAMH		varchar(10)PRIMARY KEY,
	TENMH	varchar(40),
	TCLT		tinyint,
	TCTH		tinyint,
	MAKHOA	varchar(4)FOREIGN KEY REFERENCES KHOA(MAKHOA)
);
go
CREATE TABLE DIEUKIEN
(
	MAMH			varchar(10)FOREIGN KEY REFERENCES MONHOC(MAMH),
	MAMH_TRUOC	varchar(10)FOREIGN KEY REFERENCES MONHOC(MAMH),
	CONSTRAINT PK_DIEUKIEN PRIMARY KEY (MAMH,MAMH_TRUOC)
);
go
CREATE TABLE GIAOVIEN
(
	MAGV		char(4)PRIMARY KEY,
	HOTEN	varchar(40),
	HOCVI	varchar(10),
	HOCHAM	varchar(10),
	GIOITINH	varchar(3),
	NGSINH	smalldatetime,
	NGVL		smalldatetime,
	HESO		numeric(4,2),
	MUCLUONG	money,
	MAKHOA	varchar(4)FOREIGN KEY REFERENCES KHOA(MAKHOA)
);
go
CREATE TABLE GIANGDAY
(
	MALOP	char(3)FOREIGN KEY REFERENCES LOP(MALOP),
	MAMH		varchar(10)FOREIGN KEY REFERENCES MONHOC(MAMH),
	MAGV		char(4)FOREIGN KEY REFERENCES GIAOVIEN(MAGV),
	HOCKY	tinyint,
	NAM		smallint,
	TUNGAY	smalldatetime,
	DENNGAY	smalldatetime,
	CONSTRAINT PK_GIANGDAY PRIMARY KEY (MALOP,MAMH)
);
go
CREATE TABLE KETQUATHI
(
	MAHV		char(5)FOREIGN KEY REFERENCES HOCVIEN(MAHV),
	MAMH		varchar(10)FOREIGN KEY REFERENCES MONHOC(MAMH),
	LANTHI	tinyint,
	NGTHI	smalldatetime,
	DIEM		numeric(4,2),
	KQUA		varchar(10),
	CONSTRAINT PK_KETQUATHI PRIMARY KEY (MAHV,MAMH,LANTHI)
);
go
alter table HOCVIEN add constraint FK_HV_LOP FOREIGN KEY(MALOP) REFERENCES LOP(MALOP);


---Khoa
insert into KHOA values('KHMT','Khoa hoc may tinh','7/6/2005','GV01')
insert into KHOA values('HTTT','He thong thong tin','7/6/2005','GV02')
insert into KHOA values('CNPM','Cong nghe phan mem','7/6/2005','GV04')
insert into KHOA values('MTT','Mang va truyen thong','20/10/2005','GV03')
insert into KHOA values('KTMT','Ky thuat may tinh','20/12/2005','')

--Giao vien

insert into GIAOVIEN values('GV01','Ho Thanh Son','PTS','GS','Nam','2/5/1950','11/1/2004',5.00,2250000,'KHMT')
insert into GIAOVIEN values('GV02','Tran Tam Thanh','TS','PGS','Nam','17/12/1965','20/4/2004',4.50,2025000,'HTTT')
insert into GIAOVIEN values('GV03','Do Nghiem Phung','TS','GS','Nu','1/8/1950','23/9/2004',4.00,1800000,'CNPM')
insert into GIAOVIEN values('GV04','Tran Nam Son','TS','PGS','Nam','22/2/1961','12/1/2005',4.50,2025000,'KTMT')
insert into GIAOVIEN values('GV05','Mai Thanh Danh','ThS','GV','Nam','12/3/1958','12/1/2005',3.00,1350000,'HTTT')
insert into GIAOVIEN values('GV06','Tran Doan Hung','TS','GV','Nam','11/3/1953','12/1/2005',4.50,2025000,'KHMT')
insert into GIAOVIEN values('GV07','Nguyen Minh Tien','ThS','GV','Nam','23/11/1971','1/3/2005',4.00,1800000,'KHMT')
insert into GIAOVIEN values('GV08','Le Thi Tran','KS','','Nu','26/3/1974','1/3/2005',1.69,760500,'KHMT')
insert into GIAOVIEN values('GV09','Nguyen To Lan','ThS','GV','Nu','31/12/1966','1/3/2005',4.00,1800000,'HTTT')
insert into GIAOVIEN values('GV10','Le Tran Anh Loan','KS','','Nu','17/7/1972','1/3/2005',1.86,837000,'CNPM')
insert into GIAOVIEN values('GV11','Ho Thanh Tung','CN','GV','Nam','12/1/1980','15/5/2005',2.67,1201500,'MTT')
insert into GIAOVIEN values('GV12','Tran Van Anh','CN','','Nu','29/3/1981','15/5/2005',1.69,760500,'CNPM')
insert into GIAOVIEN values('GV13','Nguyen Linh Dan','CN','','Nu','23/5/1980','15/5/2005',1.69,760500,'KTMT')
insert into GIAOVIEN values('GV14','Truong Minh Chau','ThS','GV','Nu','30/11/1976','15/5/2005',3.00,1350000,'MTT')
insert into GIAOVIEN values('GV15','Le Ha Thanh','ThS','GV','Nam','4/5/1978','15/5/2005',3.00,1350000,'KHMT')


--Mon hoc
insert into MONHOC values('THDC','Tin hoc dai cuong',4,1,'KHMT')
insert into MONHOC values('CTRR','Cau truc roi rac',5,0,'KHMT')
insert into MONHOC values('CSDL','Co so du lieu',3,1,'HTTT')
insert into MONHOC values('CTDLGT','Cau truc du lieu va giai thuat',3,1,'KHMT')
insert into MONHOC values('PTTKTT','Phan tich thiet ke thuat toan',3,0,'KHMT')
insert into MONHOC values('DHMT','Do hoa may tinh',3,1,'KHMT')
insert into MONHOC values('KTMT','Kien truc may tinh',3,0,'KTMT')
insert into MONHOC values('TKCSDL','Thiet ke co so du lieu',3,1,'HTTT')
insert into MONHOC values('PTTKHTTT','Phan tich thiet ke he thong thong tin',4,1,'HTTT')
insert into MONHOC values('HDH','He dieu hanh',4,0,'KTMT')
insert into MONHOC values('NMCNPM','Nhap mon cong nghe phan mem',3,0,'CNPM')
insert into MONHOC values('LTCFW','Lap trinh C for win',3,1,'CNPM')
insert into MONHOC values('LTHDT','Lap trinh huong doi tuong',3,1,'CNPM')

--Lop
insert into LOP values('K11','Lop 1 khoa 1',NULL,11,'GV07');
insert into LOP values('K12','Lop 2 khoa 1',NULL,12,'GV09');
insert into LOP values('K13','Lop 3 khoa 1',NULL,12,'GV14');


--Hoc vien
insert into HOCVIEN values('K1101','Nguyen Van','A','27/1/1986','Nam','TpHCM','K11')
insert into HOCVIEN values('K1102','Tran Ngoc','Han','14/3/1986','Nu','Kien Giang','K11')
insert into HOCVIEN values('K1103','Ha Duy','Lap','18/4/1986','Nam','Nghe An','K11')
insert into HOCVIEN values('K1104','Tran Ngoc','Linh','30/3/1986','Nu','Tay Ninh','K11')
insert into HOCVIEN values('K1105','Tran Minh','Long','27/2/1986','Nam','TpHCM','K11')
insert into HOCVIEN values('K1106','Le Nhat','Minh','24/1/1986','Nam','TpHCM','K11')
insert into HOCVIEN values('K1107','Nguyen Nhu','Nhut','27/1/1986','Nam','Ha Noi','K11')
insert into HOCVIEN values('K1108','Nguyen Manh','Tam','27/2/1986','Nam','Kien Giang','K11')
insert into HOCVIEN values('K1109','Phan Thi Thanh','Tam','27/1/1986','Nu','Vinh Long','K11')
insert into HOCVIEN values('K1110','Le Hoai','Thuong','5/2/1986','Nu','Can Tho','K11')
insert into HOCVIEN values('K1111','Le Ha','Vinh','25/12/1986','Nam','Vinh Long','K11')
insert into HOCVIEN values('K1201','Nguyen Van','B','11/2/1986','Nam','TpHCM','K12')
insert into HOCVIEN values('K1202','Nguyen Thi Kim','Duyen','18/1/1986','Nu','TpHCM','K12')
insert into HOCVIEN values('K1203','Tran Thi Kim','Duyen','17/9/1986','Nu','TpHCM','K12')
insert into HOCVIEN values('K1204','Truong My','Hanh','19/5/1986','Nu','Dong Nai','K12')
insert into HOCVIEN values('K1205','Nguyen Thanh','Nam','17/4/1986','Nam','TpHCM','K12')
insert into HOCVIEN values('K1206','Nguyen Thi Truc','Thanh','4/3/1986','Nu','Kien Giang','K12')
insert into HOCVIEN values('K1207','Tran Thi Bich','Thuy','8/2/1986','Nu','Nghe An','K12')
insert into HOCVIEN values('K1208','Huynh Thi Kim','Trieu','8/4/1986','Nu','Tay Ninh','K12')
insert into HOCVIEN values('K1209','Pham Thanh','Trieu','23/2/1986','Nam','TpHCM','K12')
insert into HOCVIEN values('K1210','Ngo Thanh','Tuan','14/2/1986','Nam','TpHCM','K12')
insert into HOCVIEN values('K1211','Do Thi','Xuan','9/3/1986','Nu','Ha Noi','K12')
insert into HOCVIEN values('K1212','Le Thi Phi','Yen','12/3/1986','Nu','TpHCM','K12')
insert into HOCVIEN values('K1301','Nguyen Thi Kim','Cuc','9/6/1986','Nu','Kien Giang','K13')
insert into HOCVIEN values('K1302','Truong Thi My','Hien','18/3/1986','Nu','Nghe An','K13')
insert into HOCVIEN values('K1303','Le Duc','Hien','21/3/1986','Nam','Tay Ninh','K13')
insert into HOCVIEN values('K1304','Le Quang','Hien','18/4/1986','Nam','TpHCM','K13')
insert into HOCVIEN values('K1305','Le Thi','Huong','27/3/1986','Nu','TpHCM','K13')
insert into HOCVIEN values('K1306','Nguyen Thai','Huu','30/3/1986','Nam','Ha Noi','K13')
insert into HOCVIEN values('K1307','Tran Minh','Man','28/5/1986','Nam','TpHCM','K13')
insert into HOCVIEN values('K1308','Nguyen Hieu','Nghia','8/4/1986','Nam','Kien Giang','K13')
insert into HOCVIEN values('K1309','Nguyen Trung','Nghia','18/1/1987','Nam','Nghe An','K13')
insert into HOCVIEN values('K1310','Tran Thi Hong','Tham','22/4/1986','Nu','Tay Ninh','K13')
insert into HOCVIEN values('K1311','Tran Minh','Thuc','4/4/1986','Nam','TpHCM','K13')
insert into HOCVIEN values('K1312','Nguyen Thi Kim','Yen','7/9/1986','Nu','TpHCM','K13')
--
/*insert into LOP values('K11','Lop 1 khoa 1','K1108',11,'GV07')
insert into LOP values('K12','Lop 2 khoa 1','K1205',12,'GV09')
insert into LOP values('K13','Lop 3 khoa 1','K1305',12,'GV14')*/
--
GO

UPDATE LOP
SET TRGLOP ='K1305'
WHERE MALOP='K13'; 
GO
UPDATE LOP
SET TRGLOP ='K1205'
WHERE MALOP='K12'; 
GO
UPDATE LOP
SET TRGLOP ='K1105'
WHERE MALOP='K11'; 

--Giang day
insert into GIANGDAY values('K11','THDC','GV07',1,2006,'2/1/2006','12/5/2006')
insert into GIANGDAY values('K12','THDC','GV06',1,2006,'2/1/2006','12/5/2006')
insert into GIANGDAY values('K13','THDC','GV15',1,2006,'2/1/2006','12/5/2006')
insert into GIANGDAY values('K11','CTRR','GV02',1,2006,'9/1/2006','17/5/2006')
insert into GIANGDAY values('K12','CTRR','GV02',1,2006,'9/1/2006','17/5/2006')
insert into GIANGDAY values('K13','CTRR','GV08',1,2006,'9/1/2006','17/5/2006')
insert into GIANGDAY values('K11','CSDL','GV05',2,2006,'1/6/2006','15/7/2006')
insert into GIANGDAY values('K12','CSDL','GV09',2,2006,'1/6/2006','15/7/2006')
insert into GIANGDAY values('K13','CTDLGT','GV15',2,2006,'1/6/2006','15/7/2006')
insert into GIANGDAY values('K13','CSDL','GV05',3,2006,'1/8/2006','15/12/2006')
insert into GIANGDAY values('K13','DHMT','GV07',3,2006,'1/8/2006','15/12/2006')
insert into GIANGDAY values('K11','CTDLGT','GV15',3,2006,'1/8/2006','15/12/2006')
insert into GIANGDAY values('K12','CTDLGT','GV15',3,2006,'1/8/2006','15/12/2006')
insert into GIANGDAY values('K11','HDH','GV04',1,2007,'2/1/2007','18/2/2007')
insert into GIANGDAY values('K12','HDH','GV04',1,2007,'2/1/2007','20/3/2007')
insert into GIANGDAY values('K11','DHMT','GV07',1,2007,'18/2/2007','20/3/2007')


--Dieu kien
insert into DIEUKIEN values('CSDL','CTRR')
insert into DIEUKIEN values('CSDL','CTDLGT')
insert into DIEUKIEN values('CTDLGT','THDC')
insert into DIEUKIEN values('PTTKTT','THDC')
insert into DIEUKIEN values('PTTKTT','CTDLGT')
insert into DIEUKIEN values('DHMT','THDC')
insert into DIEUKIEN values('LTHDT','THDC')
insert into DIEUKIEN values('PTTKHTTT','CSDL')


--Ket qua thi

insert into KETQUATHI values('K1101','CSDL',1,'20/7/2006',10.00,'Dat')
insert into KETQUATHI values('K1101','CTDLGT',1,'28/12/2006',9.00,'Dat')
insert into KETQUATHI values('K1101','THDC',1,'20/5/2006',9.00,'Dat')
insert into KETQUATHI values('K1101','CTRR',1,'13/5/2006',9.50,'Dat')
insert into KETQUATHI values('K1102','CSDL',1,'20/7/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1102','CSDL',2,'27/7/2006',4.25,'Khong Dat')
insert into KETQUATHI values('K1102','CSDL',3,'10/8/2006',4.50,'Khong Dat')
insert into KETQUATHI values('K1102','CTDLGT',1,'28/12/2006',4.50,'Khong Dat')
insert into KETQUATHI values('K1102','CTDLGT',2,'5/1/2007',4.00,'Khong Dat')
insert into KETQUATHI values('K1102','CTDLGT',3,'15/1/2007',6.00,'Dat')
insert into KETQUATHI values('K1102','THDC',1,'20/5/2006',5.00,'Dat')
insert into KETQUATHI values('K1102','CTRR',1,'13/5/2006',7.00,'Dat')
insert into KETQUATHI values('K1103','CSDL',1,'20/7/2006',3.50,'Khong Dat')
insert into KETQUATHI values('K1103','CSDL',2,'27/7/2006',8.25,'Dat')
insert into KETQUATHI values('K1103','CTDLGT',1,'28/12/2006',7.00,'Dat')
insert into KETQUATHI values('K1103','THDC',1,'20/5/2006',8.00,'Dat')
insert into KETQUATHI values('K1103','CTRR',1,'13/5/2006',6.50,'Dat')
insert into KETQUATHI values('K1104','CSDL',1,'20/7/2006',3.75,'Khong Dat')
insert into KETQUATHI values('K1104','CTDLGT',1,'28/12/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1104','THDC',1,'20/5/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1104','CTRR',1,'13/5/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1104','CTRR',2,'20/5/2006',3.50,'Khong Dat')
insert into KETQUATHI values('K1104','CTRR',3,'30/6/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1201','CSDL',1,'20/7/2006',6.00,'Dat')
insert into KETQUATHI values('K1201','CTDLGT',1,'28/12/2006',5.00,'Dat')
insert into KETQUATHI values('K1201','THDC',1,'20/5/2006',8.50,'Dat')
insert into KETQUATHI values('K1201','CTRR',1,'13/5/2006',9.00,'Dat')
insert into KETQUATHI values('K1202','CSDL',1,'20/7/2006',8.00,'Dat')
insert into KETQUATHI values('K1202','CTDLGT',1,'28/12/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1202','CTDLGT',2,'5/1/2007',5.00,'Dat')
insert into KETQUATHI values('K1202','THDC',1,'20/5/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1202','THDC',2,'27/5/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1202','CTRR',1,'13/5/2006',3.00,'Khong Dat')
insert into KETQUATHI values('K1202','CTRR',2,'20/5/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1202','CTRR',3,'30/6/2006',6.25,'Dat')
insert into KETQUATHI values('K1203','CSDL',1,'20/7/2006',9.25,'Dat')
insert into KETQUATHI values('K1203','CTDLGT',1,'28/12/2006',9.50,'Dat')
insert into KETQUATHI values('K1203','THDC',1,'20/5/2006',10.00,'Dat')
insert into KETQUATHI values('K1203','CTRR',1,'13/5/2006',10.00,'Dat')
insert into KETQUATHI values('K1204','CSDL',1,'20/7/2006',8.50,'Dat')
insert into KETQUATHI values('K1204','CTDLGT',1,'28/12/2006',6.75,'Dat')
insert into KETQUATHI values('K1204','THDC',1,'20/5/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1204','CTRR',1,'13/5/2006',6.00,'Dat')
insert into KETQUATHI values('K1301','CSDL',1,'20/12/2006',4.25,'Khong Dat')
insert into KETQUATHI values('K1301','CTDLGT',1,'25/7/2006',8.00,'Dat')
insert into KETQUATHI values('K1301','THDC',1,'20/5/2006',7.75,'Dat')
insert into KETQUATHI values('K1301','CTRR',1,'13/5/2006',8.00,'Dat')
insert into KETQUATHI values('K1302','CSDL',1,'20/12/2006',6.75,'Dat')
insert into KETQUATHI values('K1302','CTDLGT',1,'25/7/2006',5.00,'Dat')
insert into KETQUATHI values('K1302','THDC',1,'20/5/2006',8.00,'Dat')
insert into KETQUATHI values('K1302','CTRR',1,'13/5/2006',8.50,'Dat')
insert into KETQUATHI values('K1303','CSDL',1,'20/12/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1303','CTDLGT',1,'25/7/2006',4.50,'Khong Dat')
insert into KETQUATHI values('K1303','CTDLGT',2,'7/8/2006',4.00,'Khong Dat')
insert into KETQUATHI values('K1303','CTDLGT',3,'15/8/2006',4.25,'Khong Dat')
insert into KETQUATHI values('K1303','THDC',1,'20/5/2006',4.50,'Khong Dat')
insert into KETQUATHI values('K1303','CTRR',1,'13/5/2006',3.25,'Khong Dat')
insert into KETQUATHI values('K1303','CTRR',2,'20/5/2006',5.00,'Dat')
insert into KETQUATHI values('K1304','CSDL',1,'20/12/2006',7.75,'Dat')
insert into KETQUATHI values('K1304','CTDLGT',1,'25/7/2006',9.75,'Dat')
insert into KETQUATHI values('K1304','THDC',1,'20/5/2006',5.50,'Dat')
insert into KETQUATHI values('K1304','CTRR',1,'13/5/2006',5.00,'Dat')
insert into KETQUATHI values('K1305','CSDL',1,'20/12/2006',9.25,'Dat')
insert into KETQUATHI values('K1305','CTDLGT',1,'25/7/2006',10.00,'Dat')
insert into KETQUATHI values('K1305','THDC',1,'20/5/2006',8.00,'Dat')
insert into KETQUATHI values('K1305','CTRR',1,'13/5/2006',10.00,'Dat')--batch /* Khai báo biến @n kiểu số nguyênGán giá trị 7 cho biến @nCho biết thông tin Project có budget lớn hơn giá trị @n */

declare @i as int;
 set @i = 0;
 while @i < 10
  begin
	set @i = @i + 1
	if(@i % 2 = 0) continue;
    else print @i;
end

/* Viết đoạn chương trình in danh sách các số lẻ nhỏ hơn 100 */
go
declare @i as int = 0;
 while @i < 100
  begin 
   set @i = @i + 1
   if(@i % 2 = 0) continue;
   else print @i;
  end
go

/* Viết đoạn chương trình in danh sách các số lẻ nhỏ hơn 100 */

go
declare @i as int = 0;
 while @i < 100
  begin
  
  end
go

/* Sử dụng cấu trúc vòng lập While, nhập 10 mẫu tin vào bảng employee với nội dung:Emp_no tăng từ 1 đến 10Emp_fname  là ‘nv1’,’nv2’,…,’nv10’Emp_lname là ‘Nguyen’Dept_no là ‘d3’ */create database dbmnlab2use dbmnlab2CREATE TABLE employee  (emp_no INTEGER NOT NULL, 
                        emp_fname CHAR(20) NOT NULL,
                        emp_lname CHAR(20) NOT NULL,
                        dept_no CHAR(4) NULL)godeclare @i as int = 0;declare @n as int = 10;while @i < 10 begin  set @i = @i + 1  set @n = @n + 1  insert into employee values  (@n, 'nv' + cast(@i as nvarchar), 'Nguyen', 'd3') endgo select * from employee--- Procedure/* 1. Tạo thủ tục KQ_MH, cho biết kết quả thi môn học (MH) của học viên (SV).
 Thông tin gồm: Mã học viên, tên học viên, mã môn học, tên môn học, lần thi, ngày thi,
điểm, kết quả
 Thủ tục nhận 2 tham số đầu vào là mã môn học (MH) và mã học viên (SV) */

create proc KQ_MH @mh nvarchar(20), @sv nvarchar(50) as
 select hv.MAHV, hv.HO, hv.TEN, mh.MAMH, mh.TENMH, kq.LANTHI, kq.NGTHI, kq.DIEM, kq.KQUA
  from HOCVIEN hv join KETQUATHI kq on hv.MAHV = kq.MAHV
				  join MONHOC mh on mh.MAMH = kq.MAMH
   where hv.MAHV = @sv and mh.MAMH = @mh
				  
exec KQ_MH @mh = 'CSDL', @sv = 'K1101'

/* 2. Tạo thủ tục GV_MH, cho biết danh sách các môn học giáo viên (GV) đã dạy trong năm (NH).
 Thông tin gồm: Mã GV, tên gv, mã môn học, tên môn học, số tín chỉ lý thuyết, số tín chỉ
thực hành
 Thủ tục nhận 2 tham số đầu vào là mã giáo viên (GV) và năm học (NH) */

create proc GV_MH @gv nvarchar(20), @nh int as
 select gv.MAGV, gv.HOTEN, mh.MAMH, mh.TCLT, mh.TCTH
  from GIAOVIEN gv join GIANGDAY gd on gv.MAGV = gd.MAGV
				   join MONHOC mh on mh.MAMH = gd.MAMH
   where gv.MAGV = @gv and gd.NAM = @nh
   
exec GV_MH @gv = 'GV05', @nh = 2006

/* 3. Tạo thủ tục MH_TRUOC cho biết danh sách môn học tiên quyết của môn học (MH).
 Thông tin gồm: mã môn học tiên quyết, tên môn học tiên quyết.
 Thủ tục nhận 1 tham số đầu vào là mã môn học (MH). */

create proc MH_TRUOC @mh nvarchar(10) as
 select MAMH, TENMH
  from MONHOC
   where MAMH in (select dk.MAMH_TRUOC 
				   from MONHOC mh join DIEUKIEN dk on mh.MAMH = DK.MAMH
					where mh.MAMH = @mh)
					
exec MH_TRUOC @mh = 'CSDL'

/* 4. Tạo thủ tục TOP_N liệt kê danh sách n học viên có điểm thi cao nhất.
 Thông tin gồm: Mã học viên, tên học viên, mã môn học, ngày thi, lần thi, điểm
 Thủ tục nhận 1 tham số đầu vào là n. */

create proc TOP_N @n int as
 select top (@n) hv.MAHV, hv.HO, hv.TEN, mh.MAMH, kq.NGTHI, kq.LANTHI, kq.DIEM
  from HOCVIEN hv join KETQUATHI kq on hv.MAHV = kq.MAHV
				  join MONHOC mh on mh.MAMH = kq.MAMH
   order by kq.DIEM desc 
 
exec TOP_N @n = 5

/* 5. Tạo thủ tục THONGKE, cho biết tổng số giáo viên (TS) và mức lương bình quân (BQ) của khoa
(KH). 
 Trong đó mã khoa (KH) là tham số đầu vào, TS và BQ là tham số đầu ra */

create proc THONGKE @kh nvarchar(20) as
select COUNT(distinct MAGV)TONGGV, AVG(MUCLUONG)MUCLUONGTB
  from GIAOVIEN gv join KHOA k on gv.MAKHOA = k.MAKHOA
	where gv.MAKHOA = @kh

exec THONGKE @kh = 'KHMT'

/* 6. Viết thủ tục sp_bangdiem có tham số là mã học viên (SV), sử dụng kiểu dữ liệu cursor để in bảng
điểm của học viên như sau:
Bảng điểm
Mã số học viên: ...................
Tên học viên: .......................
--------------------------------------------------------------
: STT : Tên MH : Điểm :
----------------------------------------------------------------
Trong đó cột điểm là điểm cao nhất của môn học đó */

create proc sp_bangdiem as
 declare @mahv nvarchar(10),
		 @ho nvarchar(20),
		 @ten nvarchar(20),
		 @i int,
		 @mh nvarchar(50),
		 @diem int
 declare cursor_hv cursor for
						select hv.MAHV, hv.HO, hv.TEN, mh.TENMH, kq.DIEM
						 from HOCVIEN hv join KETQUATHI kq on hv.MAHV = kq.MAHV
										 join MONHOC mh on mh.MAMH = kq.MAMH
  open cursor_hv
   fetch next from cursor_hv into @mahv, @ho, @ten, @mh, @diem
    while @@FETCH_STATUS = 0
     begin
	  set @i = @i + 1
      print N'Bảng điểm'
      print (N'Mã số học viên: ' + @mahv)
      print (N'Tên học viên: ' + @ho + ' ' + @ten)
      print (N' Tên MH: ' + @mh + N' Điểm: ' + cast(@diem as nvarchar))
      print (' ')
      fetch next from cursor_hv into @mahv, @ho, @ten, @mh, @diem
      end
     close cursor_hv
     deallocate cursor_hv
     
exec sp_bangdiem

--- function

/* 1. Tạo hàm cho biết điểm trung bình (DTB) các môn thi của học viên (mã học viên là tham số của
hàm). */

create function func_avg(
	@hv nvarchar(10)
)
 returns table
 as
  return(
   select MAHV, (sum(DIEM) / count(distinct MAMH)) average
   from KETQUATHI 
    where MAHV = @hv
     group by MAHV
  )
    
select * from func_avg('K1101')

/* 2. Tạo hàm cho biết sỉ số học viên của lớp . */

create function siso(
	@ml nvarchar(10)
)
 returns table
 as
  return select SISO from LOP 
		 where MALOP = @ml 

select * from siso('K11')

/* 3. Tạo hàm cho biết số lượng môn học mà giáo viên đã dạy trong học kỳ (HK) của năm (NAM). Với
mã giáo viên, mã học kỳ (HK) và năm (NAM) là tham số */

create function soLuongMon(
	@gv nvarchar(10),
	@mhk int,
	@nam int
)
 returns table
 as
  return select COUNT(distinct gd.MAMH)SOLUONGMON
		  from GIAOVIEN gv join GIANGDAY gd on gv.MAGV = gd.MAGV
		   where gv.MAGV = @gv and gd.HOCKY = @mhk and gd.NAM = @nam
		   
select * from soLuongMon('GV05', 2, 2006)

/* 4. Tạo hàm cho biết danh sách giáo viên có hệ số lương cao nhất. */

create function heSoLuongCaoNhat()
 returns table
 as
  return select top 5 *
		  from GIAOVIEN
		   order by HESO desc
		   
select * from heSoLuongCaoNhat()

/* 5. Tạo hàm trả về kết quả là một bảng (Table) bằng hai cách: Inline Table-Valued Functions và
Multistatement Table-Valued. Thông tin gồm: MAKHOA, TENKHOA, LuongTB */

create function ketqua()
 returns table
 as
  return select mk.MAKHOA, mk.TENKHOA, AVG(gv.MUCLUONG) LuongTB
		  from GIAOVIEN gv join KHOA mk on gv.MAKHOA = mk.MAKHOA
		   group by mk.MAKHOA, mk.TENKHOA
		   
select * from ketqua()