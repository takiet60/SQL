create database BanHang
go

drop database BanHang

use BanHang
go

set dateformat dmy
go

create table LoaiKH(
	MaLoai varchar(10) not null,
	TenLoai nvarchar(100) not null
	constraint prim_l_kh Primary Key(MaLoai)
)

create table KhachHang(
	MaKH varchar(10) not null,
	MaLoai_KH varchar(10) not null,
	HoVaTen nvarchar(50) not null,
	Email varchar(50) not null,
	SDT varchar(15) not null,
	DiaChi nvarchar(100) not null,
	GioiTinh varchar(5) null,
	ThoiGianTao date not null,
	MaGioiThieu varchar(20),
	MaNgGioiThieu varchar(20)
	constraint prim_kh Primary Key (MaKH)
)

create table DonHang(
	MaDH varchar(10) not null,
	MaSP varchar(10) not null,
	MAKH varchar(10) not null,
	TongTien int not null,
	PhuongTHucThanhToan nvarchar(30) not null,
	MaGiamGIa varchar(20) null,
	TienSauGiamGia int not null,
	TinhTrang nvarchar(20) not null
	constraint prim_dh Primary Key (MaDH)
)

create table LoaiSP(
	MaLoai varchar(10) not null,
	TenLoai nvarchar(100) not null
	constraint prim_l_sp Primary Key (MaLoai)
)

create table SanPham(
	MaSP varchar(10) not null,
	TenSP nvarchar(50) not null,
	MaLoai varchar(10) not null,
	GiaNhap int not null,
	GiaBan int not null,
	URL_Hinh nvarchar(200) not null,
	MoTa nvarchar(500) not null,
	TinhTrang nvarchar(30) not null
	constraint prim_sp Primary Key (MaSP)
)

create table PhieuGiaoHang(
	MaVC varchar(10) not null,
	MaKH varchar(10) not null,
	MaDH varchar(10) not null,
	LoiNhan nvarchar(100) null,
	NgayTao date not null,
	NgayGiao date not null,
	NgayNhan date not null,
	TienVanChuyen int not null,
	TinhTrang varchar(20) not null
	constraint prim_pgh Primary Key (MAVC)
)



create table CTDH(
	MaDH varchar(20) not null,
	MaSP varchar(20) not null,
	SoLuong int not null,
	MaGiamGia varchar(10) null
	constraint prim_ctdh Primary Key (MaDH, MaSP)
)

create table CTGH(
	MaVC varchar(10) not null,
	MaKH varchar(10) not null,
	MaSP varchar(10) not null,
	SoLuong int not null
	constraint prim_ctgh Primary Key (MaVC, MaKH, MaSP, SoLuong)
)

create table DanhGia(
	MaKH varchar(10) not null,
	MaSP varchar(10) not null,
	Sao int not null,
	BinhLuan nvarchar(100) null
	constraint prim_dg Primary Key(MaKH, MaSP)
)

create table KhoHang(
	MaLuuTru varchar(10) not null,
	MaSP varchar(10) not null,
	SoLuongNhap int not null,
	NgayNhap date not null,
	SoLuongTon int not null
	constraint prim_khohang Primary Key(MaLuuTru)
)
go

alter table KhachHang add constraint foreign_loai_kh Foreign Key(MaLoai_KH) references LoaiKH(MaLoai);

alter table CTDH add constraint foreign_ctdh_madh Foreign Key(MaDH) references DonHang(MaDH)

alter table CTDH alter column MaDH varchar(10)

alter 