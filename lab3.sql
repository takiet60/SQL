use Quanlygiaovu
go
set dateformat dmy
go

/* 1. Học viên thi một môn tối đa 3 lần. */
alter Trigger trg_max_exam 
 on Ketquathi
  for insert, update
   as
   begin
	declare @num_exam int
	select @num_exam = LANTHI from inserted
	if(@num_exam > 3)
	begin
	 raiserror('Khong duoc thi qua ba lan', 10, 1)
	 rollback transaction
	end
   end
go

select * from KETQUATHI

insert into KETQUATHI(MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) values
 ('K000', 'CSDL', 1, '27/6/2007', 8.7, 'Dat')
 
go

/* 2. Học kỳ chỉ có giá trị từ 1 đến 3. */
alter Trigger trg_term_lessThan_3
 on GiangDay
 for insert, update
 as
 begin
  declare @count int
  select @count = COUNT(*) from inserted
   where HOCKY between 1 and 3
   if(@count > 0)
   begin
    raiserror('hoc ky co gia tri tu 1 den 3', 10, 1)
	rollback
   end
 end

go
insert into GIANGDAY values
 ('K100', 'MMT', 'GV15', 4, 2006, '20/6/2006', '20/1/2007')
 
go

/* 3. Học vị của giáo viên chỉ có thể là “CN”, “KS”, “Ths”, ”TS”, ”PTS”. */
alter Trigger trg_degree_teachers
 on GiaoVien
 for insert, update
 as
 begin
  declare @count int
  select @count = COUNT(*) from inserted
   where HOCVI = 'CN' or HOCVI = 'KS'or HOCVI = 'Ths' or HOCVI = 'TS' or HOCVI = 'PTS'
   if(@count > 0)
   begin
    raiserror('Giao vien chi co the la ', 10, 1)
	rollback
   end
 end
go


/* 4. Lớp trưởng của một lớp phải là học viên của lớp đó. */
alter Trigger trg_member_in_class
 on Lop
 for insert, update
 as
 begin
   if exists (select *
			 from inserted i join HOCVIEN hv on i.TRGLOP = hv.MAHV
			 where hv.MAHV not in (select hv.MAHV
								  from inserted i join HOCVIEN hv on i.MALOP = hv.MALOP))
   begin
    raiserror('lop truong la thanh vien cua lop!', 10, 1)
	rollback
   end
 end
go

/* 5. Trưởng khoa phải là giáo viên thuộc khoa và có học vị “TS” hoặc “PTS”. */
alter trigger trg_dean
on KHOA
for insert, update
as
begin
 if exists (select * from inserted i join GIAOVIEN gv on i.MAKHOA = gv.MAKHOA
					where gv.HOCVI not in('TS', 'PTS') 
					or i.TRGKHOA not in (select gv.MAGV
										from GIAOVIEN gv join inserted i
										on gv.MAKHOA = i.MAKHOA))
   begin
    raiserror('Giao vien thuoc khoa', 10, 1)
	rollback
   end
end
go

/* 6. Học viên ít nhất là 18 tuổi. */
alter trigger trg_age_more_than18 on HOCVIEN
for insert, update
as
begin
 declare @age int
 select @age = YEAR(GETDATE()) - YEAR(NGSINH)  from HOCVIEN
 if(@age < 18)
  begin
   raiserror('Hoc vien it nhat la 18 tuoi', 10, 1)
   rollback
  end
end
go

select YEAR(GETDATE()) - YEAR(NGSINH)  from HOCVIEN
go

/* 7. Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc
(DENNGAY). */
alter trigger trg_cau7 on GIANGDAY
for insert, update
as
begin
 declare @startDay smalldatetime
 declare @endDay smalldatetime
 declare @dayDiff int
 select @startDay = TUNGAY from inserted
 select @endDay = DENNGAY from inserted
 set @dayDiff = DATEDIFF(DAY, @startDay, @endDay)
 if(@dayDiff < 0)
  begin
   raiserror('ngay bat dau phai nho hon ngay ket thuc!', 10, 1)
   rollback
  end
end
go

select DATEDIFF(day, TUNGAY, DENNGAY) from GIANGDAY
go

/* 8. Giáo viên khi vào làm ít nhất là 22 tuổi. */
alter trigger trg_cau8 on GIAOVIEN
for insert, update
as
begin
 declare @ageTeacher int
 declare @yearOfBirth int
 select @yearOfBirth = YEAR(NGSINH) from inserted
 select @ageTeacher = YEAR(GETDATE()) - @yearOfBirth
 if(@ageTeacher < 22)
  begin
   raiserror('Giao vien phai nho hon 22 tuoi', 10, 1)
   rollback
  end
end
go

/* 9. Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch
nhau không quá 3. */
alter trigger trg_cau9 on MONHOC
for update, insert
as
begin
	declare @tclt int
	declare @tcth int
	select @tclt = TCLT from inserted
	select @tcth = TCTH from inserted
	if((@tclt - @tcth) > 3 or (@tcth - @tclt) > 3)
	 begin
	  raiserror('tclt va tcth ko chenh lech qua 3', 10, 1)
	  rollback
	 end
end
go


/* 10. Học viên chỉ được thi một môn học nào đó khi lớp của học viên đã học xong
môn học này. */
alter trigger trg_cau10 on KETQUATHI
for update, insert
as
begin
	declare @endTime smalldatetime
	declare @ngThi smalldatetime
	select @endTime = gd.DENNGAY from GIANGDAY gd join MONHOC mh on gd.MAMH = mh.MAMH
												join inserted i on i.MAMH = mh.MAMH
	select @ngThi = NGTHI from inserted
	if(DATEDIFF(day, @endTime, @ngThi) < 0)
	begin
		raiserror('Chi duoc thi khi da hoc xong', 10, 1)
		rollback
	end
end
go

/* 11. Mỗi học kỳ của một năm học, một lớp chỉ được học tối đa 3 môn. */
alter trigger trg_cau11 on GIANGDAY
for update, insert
as
begin
	declare @soMonHoc int
	select @soMonHoc = COUNT(*) from GIANGDAY gd join inserted i 
						on gd.MALOP = i.MALOP group by gd.HOCKY, gd.MALOP
	if(@soMonHoc > 4)
	begin
		raiserror('Moi hoc ky, mot lop toi da 3 mon', 10, 1)
		rollback
	end
end
go

select count(MAMH) from GIANGDAY
	group by HOCKY, MALOP
go

select * from GIANGDAY
go

/* 12. Sỉ số của một lớp bằng với số lượng học viên thuộc lớp đó. */
alter trigger trg_cau12 on LOP
for insert, update
as
begin
	declare @siso_new int
	declare @siso_old int
	select @siso_old = COUNT(hv.MALOP) from HOCVIEN hv join inserted i
							on hv.MALOP = i.MALOP
							group by hv.MALOP
	select @siso_new = SISO from inserted
	if(@siso_new != @siso_old)
	begin
		raiserror('Si so phai bang so luong hoc vien cua lop do', 10, 1)
		rollback
	end
end
go

select MALOP, COUNT(MALOP) from HOCVIEN
	group by MALOP
go

/* 13. Trong quan hệ DIEUKIEN giá trị của thuộc tính MAMH và MAMH_TRUOC
trong cùng một bộ không được giống nhau (“A”,”A”) và cũng không tồn tại hai
bộ (“A”,”B”) và (“B”,”A”). */
alter trigger trg_cau13 on DIEUKIEN
for update, insert
as
begin
	if exists (select * from inserted
				where MAMH = MAMH_TRUOC)
		begin
			raiserror('Trung nhau', 10, 1)
			rollback
		end
	if exists (select * from DIEUKIEN dk join inserted i
						on dk.MAMH = i.MAMH_TRUOC
						where dk.MAMH_TRUOC = i.MAMH)
		begin
			raiserror('Trung nhau', 10, 1)
			rollback
		end				
end
go
insert DIEUKIEN values ('CTRR', 'CSDL')

select * from DIEUKIEN dk1 join DIEUKIEN dk2 on dk1.MAMH = dk2.MAMH_TRUOC
		where dk1.MAMH_TRUOC = dk2.MAMH
select * from DIEUKIEN
go

/* 14. Các giáo viên có cùng học vị, học hàm, hệ số lương thì mức lương bằng nhau. */
alter trigger trg_cau14 on GIAOVIEN
for update, insert
as
begin
	if exists (select * from GIAOVIEN gv join inserted i 
						on gv.HOCHAM = i.HOCHAM
						where gv.HOCVI = i.HOCVI and gv.HESO <> i.HESO)
	begin
		raiserror('Cung hoc vi phai co cung muc luong bang nhau!', 10, 1)
		rollback
	end	
end
go

select * from GIAOVIEN gv1 join GIAOVIEN gv2 on gv1.HOCHAM = gv2.HOCHAM
	where gv1.HOCVI = gv2.HOCVI
go

/* 15. Học viên chỉ được thi lại (lần thi >1) khi điểm của lần thi trước đó dưới 5. */
alter trigger trg_cau15 on KETQUATHI
for update, insert
as
begin
	if exists (select * from KETQUATHI kq1 join inserted i 
						on kq1.MAMH = i.MAMH
					where kq1.MAHV = i.MAHV and kq1.DIEM > 5)
		begin
			raiserror('Chi dc thi lai khi diem truoc do < 5', 10, 1)
			rollback
		end
end
go
select kq1.LANTHI, kq1.DIEM from KETQUATHI kq1 join KETQUATHI kq2 on kq1.MAMH = kq2.MAMH
	where kq1.MAHV = kq2.MAHV and kq1.DIEM > 5
go

/* 16. Ngày thi của lần thi sau phải lớn hơn ngày thi của lần thi trước (cùng học viên,
cùng môn học). */
alter trigger trg_cau16 on KETQUATHI
for update, insert
as
begin
	if exists (select * from KETQUATHI kq1 join inserted i 
						on kq1.MAMH = i.MAMH
					where kq1.MAHV = i.MAHV and kq1.NGTHI > i.NGTHI)
		begin
			raiserror('Ngay thi cua lan thi sau phai lon hon ngay thi lan thi truoc!', 10, 1)
			rollback
		end
end
go

/* 17. Học viên chỉ được thi những môn mà lớp của học viên đó đã học xong. */
alter trigger trg_cau17 on KETQUATHI
for insert, update
as
begin
	declare @ngayketthuc smalldatetime
	declare @ngaythi smalldatetime
	select @ngayketthuc = (select gd.DENNGAY from GIANGDAY gd join inserted i
											on gd.MAMH = i.MAMH)
	select @ngaythi = NGTHI from inserted
	if(DATEDIFF(day, @ngayketthuc, @ngaythi) < 0)
		begin
			raiserror('Hoc vien chi duoc thi nhung mon da hoc xong', 10, 1)
			rollback
		end
end
go
select gd.MAMH, gd.DENNGAY, kq.NGTHI from GIANGDAY gd join MONHOC mh on gd.MAMH = mh.MAMH
							join KETQUATHI kq on gd.MAMH = kq.MAMH
go

/* 18. Khi phân công giảng dạy một môn học, phải xét đến thứ tự trước sau giữa các
môn học (sau khi học xong những môn học phải học trước mới được học
những môn liền sau). */

create trigger trg_cau18 on GIANGDAY
for insert, update
as
begin
	declare @ngayketthucmontruoc smalldatetime
	declare @ngaykethucmonsau smalldatetime
	select @ngayketthucmontruoc = (select i.DENNGAY from DIEUKIEN dk join inserted i
											on dk.MAMH = i.MAMH)
	select @ngaykethucmonsau = (select i.DENNGAY from DIEUKIEN dk join inserted i 
											on dk.MAMH_TRUOC = i.MAMH)	
	if(DATEDIFF(day, @ngayketthucmontruoc, @ngaykethucmonsau) < 0)
		begin
			raiserror('Can not insert or update!', 10, 1)
			rollback
		end
end
go


insert into GIANGDAY values('K20','PTTKTT','GV07',1,2006,'2/1/2006','12/5/2006')
select * from GIANGDAY
select * from DIEUKIEN
select dk.MAMH_TRUOC, gd.DENNGAY from GIANGDAY gd join DIEUKIEN dk on dk.MAMH = gd.MAMH 
go

/* 19. Giáo viên chỉ được phân công dạy những môn thuộc khoa giáo viên đó phụ
trách. */
create trigger trg_19 on GIANGDAY
for update, insert
as
begin
	if exists (select * from inserted i join GIAOVIEN gv on i.MAGV = gv.MAGV
										join MONHOC mh on mh.MAMH = i.MAMH
										join KHOA k on k.MAKHOA = mh.MAKHOA
							where i.MAMH <> mh.MAMH)
		begin
			raiserror('Can not insert or update!', 10, 1)
			rollback
		end
end
go

select gv.MAGV, k.MAKHOA, mh.MAMH from GIAOVIEN gv join GIANGDAY gd on gv.MAGV = gd.MAGV
						  join MONHOC mh on gd.MAMH = mh.MAMH
						  join KHOA k on mh.MAKHOA = k.MAKHOA