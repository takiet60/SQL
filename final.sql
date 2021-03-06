create database QuanLySanXuat1
go
use QuanLySanXuat1
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
CREATE TRIGGER trg_1
ON SANXUAT
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @ngaynv DATE
	DECLARE @ngaysx DATE
	SELECT @ngaynv = cn.NGAYNV FROM inserted i RIGHT JOIN CONGNHAN cn ON i.MACN = cn.MACN
	SELECT @ngaysx = NGAYSX FROM inserted 
	if(DATEDIFF(day, @ngaynv, @ngaysx) < 0)
		BEGIN
			RAISERROR('Ngay san xuat phai sau ngay nhan vao', 10, 1)
			ROLLBACK
		END
END

GO
INSERT INTO PHANXUONG VALUES('PX1', 'Phan xuong 1')
INSERT INTO PHANXUONG VALUES('PX2', 'Phan xuong 2')
INSERT INTO PHANXUONG VALUES('PX3', 'Phan xuong 3')
GO

INSERT INTO CONGNHAN(MACN, HOCN, TENCN, GIOITINH, NAMSINH, QUEQUAN, NGAYNV, LCB, SOCMND, MAPX) 
VALUES('CN001', 'Ta Anh', 'Kiet', 'Nam', '2000', 'Binh Dinh', '20/10/2010', '10000000', '281229484', 'PX1');
GO

SELECT * FROM CONGNHAN
GO
INSERT INTO SANPHAM VALUES('SP001', 'San pham 1', 'vnd', '10000');
INSERT INTO SANPHAM VALUES('SP002', 'San pham 2', 'vnd', '20000');
INSERT INTO SANPHAM VALUES('SP003', 'San pham 3', 'vnd', '30000');
INSERT INTO SANPHAM VALUES('SP004', 'San pham 4', 'vnd', '40000');
INSERT INTO SANPHAM VALUES('SP005', 'San pham 5', 'vnd', '50000');
INSERT INTO SANPHAM VALUES('SP006', 'San pham 6', 'vnd', '60000');
INSERT INTO SANPHAM VALUES('SP007', 'San pham 7', 'vnd', '70000');
GO

INSERT INTO SANXUAT VALUES('20/9/2010', 'CN001', 'SP001', 10);
GO

/* 2.2. Công nhân chỉ được phân công những sản phẩm mà phân xưởng của công nhân đó
có đảm nhận.  */
INSERT INTO PX_SP VALUES('PX001', 'SP001', 100);
INSERT INTO PX_SP VALUES('PX002', 'SP002', 100);
INSERT INTO PX_SP VALUES('PX003', 'SP003', 100);
INSERT INTO PX_SP VALUES('PX001', 'SP004', 100);
INSERT INTO PX_SP VALUES('PX001', 'SP005', 100);
INSERT INTO PX_SP VALUES('PX001', 'SP006', 100);
INSERT INTO PX_SP VALUES('PX001', 'SP007', 100);
GO

ALTER TRIGGER trg_2 
ON CN_SP
FOR INSERT, UPDATE
AS
BEGIN
	if not exists (select * from inserted i join CONGNHAN cn
								on i.MACN = cn.MACN join PX_SP ps
								on cn.MAPX = ps.MAPX
					where ps.MASP = i.MASP)
		BEGIN
			RAISERROR('Cong nhan chi duoc nhan nhung san pham ma phan xuong cua cong nhan do phu trach', 10, 1)
			ROLLBACK
		END
END
GO

INSERT INTO CN_SP VALUES('CN001', 'SP003', 10)
GO
/* 2.3. Một phân xưởng không được phụ trách nhiều hơn 5 sản phẩm */
CREATE TRIGGER trg_3 
ON PX_SP
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @count INT
	SELECT @count = COUNT(*) FROM inserted i JOIN PX_SP ps ON i.MAPX = ps.MAPX
	IF(@count > 5)
		BEGIN
			RAISERROR('Mot phan xuong khong duoc nhan qua 5 san pham', 10, 1)
			ROLLBACK
		END
END
GO
SELECT * FROM PX_SP
INSERT INTO PX_SP VALUES('PX001', 'SP002', 100);
GO
 /* 2.4. Một công nhân không được phân công nhiều hơn 2 sản phẩm */
 CREATE TRIGGER trg_4
 ON CN_SP
 FOR INSERT, UPDATE
 AS
 BEGIN
	DECLARE @count INT
	SELECT @count = COUNT(*) FROM inserted i JOIN CN_SP cs ON i.MACN = cs.MACN
	IF(@count > 1)
		BEGIN
			RAISERROR('Mot cong nhan khong duoc phan cong nhieu hon 2 san pham', 10, 1)
			ROLLBACK
		END
 END
 GO
 
 INSERT INTO CN_SP VALUES('CN001', 'SP004', 10)
 
 SELECT * FROM PX_SP
 
 SELECT * FROM CN_SP
 GO
  /* 3.1. Lấy danh sách công nhân với các thông tin: MACN, HOCN, TENCN, GIOITINH,
TENPX, MAPX */
CREATE VIEW v_1
AS
SELECT cn.MACN, cn.HOCN, cn.TENCN, cn.GIOITINH, px.TENPX, px.MAPX
FROM CONGNHAN cn JOIN PHANXUONG px ON cn.MAPX = px.MAPX
GO
SELECT * FROM v_1
GO
/* 3.2. Cho biết sự phân công sản xuất của từng công nhân trong phân xưởng PX1 (mã phân
xưởng). Kết quả gồm các thông tin: Mã công nhân, họ và tên, mã sp, tensp, định mức */
CREATE VIEW v_2
AS
SELECT cn.MACN, cn.HOCN, cn.TENCN, sp.MASP, sp.TENSP, cs.DINHMUC2
FROM CONGNHAN cn JOIN CN_SP cs ON cn.MACN = cs.MACN
				JOIN SANPHAM sp ON cs.MASP = sp.MASP
GO
SELECT * FROM v_2
GO
/* 3.3. Cho biết tổng số lượng mỗi loại sản phẩm mà mỗi công nhân làm được trong tháng 2
năm 2020. */
ALTER VIEW v_3
AS
SELECT MACN, MASP, SUM(SOLUONG) TONGSOLUONG
FROM SANXUAT
WHERE MONTH(NGAYSX) = 2
GROUP BY MACN, MASP
GO
SELECT * FROM v_3
GO
SELECT * FROM SANXUAT
INSERT INTO SANXUAT VALUES ('1/2/2020', 'CN001', 'SP002', 100)
INSERT INTO SANXUAT VALUES ('2/2/2020', 'CN001', 'SP002', 100) 
INSERT INTO SANXUAT VALUES ('3/2/2020', 'CN001', 'SP002', 100)
GO
/* 3.4. Cho biết tổng số lượng mỗi loại sản phẩm mà mỗi công nhân làm được trong từng
tháng, so sánh với định mức được giao cho công nhân. Kết quả gồm các thông tin:
MACN, HOCN, TENCN, TENX, MASP, TENSP, TONG_SOLG_SX, DINHMUC2,
SO_VUOT_DM, KETQUA. Trong đó:
SO_VUOT_DM: Là số lượng SP sản xuất vượt định mức (<0 nếu chưa đạt định
mức) KETQUA là ‘Đạt’ nếu SO_VUOT_DM>=0, “Không đạt’ nếu SO_VUOT_DM<0. */
ALTER VIEW v_4
AS
SELECT cn.MACN, cn.HOCN, cn.TENCN,  sp.MASP, sp.TENSP, SUM(sx.SOLUONG) AS TONG_SOLG_SX, cs.DINHMUC2,
(SUM(sx.SOLUONG) - cs.DINHMUC2) SO_VUOT_DM,
CASE
	WHEN (SUM(sx.SOLUONG) - cs.DINHMUC2) > 0 THEN 'Dat'
	WHEN (SUM(sx.SOLUONG) - cs.DINHMUC2) <= 0 THEN 'Khong Dat'
END AS KETQUA
FROM CONGNHAN cn JOIN SANXUAT sx ON cn.MACN = sx.MACN
				JOIN CN_SP cs ON cn.MACN = cs.MACN
				JOIN SANPHAM sp ON sp.MASP = sx.MASP
GROUP BY cn.MACN, cn.HOCN, cn.TENCN,  sp.MASP, sp.TENSP, MONTH(sx.NGAYSX), cs.DINHMUC2
GO
SELECT * FROM v_4
GO
SELECT * FROM SANXUAT
GO
/* 3.5. Cho biết kết quả chấm công tháng 4 năm 2020 của từng công nhân với các thông tin:
MAPX, TENPX, MACN, HOCN, TENCN, Tổng_số_ngày_vắng_KP,

Tổng_số_ngày_vắng_CP, Tổng_số_ngày_làm_việc. Biết rằng: Số ngày làm việc = 24-
0.5 * Số ngày vắng loại 1⁄2 - số ngày vắng không phép – số ngày vắng có phép. */
CREATE VIEW v_5
AS
SELECT px.MAPX, px.TENPX, cn.MACN, cn.HOCN, cn.TENCN,
COUNT(
CASE 
WHEN v.LOAIVANG = 'CP' THEN 1 ELSE 0
END) AS TONG_SO_NGAY_VANG_CP,
COUNT(
CASE 
WHEN v.LOAIVANG = 'KP' THEN 1 ELSE 0
END) AS TONG_SO_NGAY_VANG_KP,
(24 - 0.5*COUNT(
CASE 
WHEN v.LOAIVANG = 'CP' THEN 1 ELSE 0
END) - COUNT(
CASE 
WHEN v.LOAIVANG = 'KP' THEN 1 ELSE 0
END)) AS SO_NGAY_LAM_VIEC
FROM CONGNHAN cn JOIN PHANXUONG px ON cn.MAPX = px.MAPX
				JOIN VANG v ON cn.MACN = v.MACN
				JOIN SANXUAT sx on v.MACN = sx.MACN
WHERE MONTH(sx.NGAYSX) = 4 AND YEAR(sx.NGAYSX) = 2020
GROUP BY px.MAPX, px.TENPX, cn.MACN, cn.HOCN, cn.TENCN
GO
SELECT * FROM v_5