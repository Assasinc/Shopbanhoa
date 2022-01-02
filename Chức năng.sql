use QuanLyBanHang

go
create proc KiemTraDangNhap
@username varchar(20),
@password varchar(20)
as
begin
	if exists (select * from Acc where account = @username and pw = @password)
		select 1 as code
	else if exists (select * from Acc where account = @username and pw != @password)
		select 2 as code
	else select 0 as code
end
go
create proc TimKiemTheoTen
@ten nvarchar(30)
as
begin
	select h.*
	from Hoa h 
	where h.tenhoa like @ten
end

go
create proc TimKiemTheoLoaiHoa
@loaihoa nvarchar(20)
as
begin
select h.*,lh.tenloai
from Hoa h join
     LoaiHoa lh on
	 (h.maloaihoa = lh.maloaihoa)
where lh.tenloai = @loaihoa
end

go

create proc TimKiemTheoMauHoa
@mauhoa nvarchar(10)
as
begin
select h.*
from Hoa h
where h.mausac = @mauhoa
end

go

create proc XemDonHang
@madh int
as
begin
select * from DonHang where DonHang.madh = @madh
end

go
create function soluongban(@mahoa int)
returns int
as
begin
	Declare @soluong int 
	set @soluong = (select sum(ct.soluong)
					from ChiTietDonHang ct
					where ct.mahoa = @mahoa)
	return @soluong 
end

go

create proc XemMatHangBanChay
as
begin
	select h.tenhoa, h.dongia, dbo.soluongban(h.mahoa) as soluong
	from Hoa h
	order by soluong DESC
end

go
create proc XemMatHangTheoGiaGiamDan
as
begin
	select h.tenhoa,h.mausac,h.dongia
	from Hoa h
	order by h.dongia DESC
go


--xem doanh thu của tháng X
create proc XemDoanhThu
@idcuahang int
as
begin
	select nv.idcuahang, Sum(nv.doanhso) as DoanhThu from NhanVien nv
	where nv.idcuahang = @idcuahang
end

go
create proc XemDoanhThuTheoThang
@thang int
as
begin
	select Sum(ct.soluong*ct.dongia) as DoanhThu
	from DonHang dh join
		 ChiTietDonHang ct on
		 (dh.madh = ct.madh)
	where month(dh.ngaygiao) = @thang and dh.tinhtrang = 'Da Giao'
end

go
create proc XemDoanhThuTheoNam
@nam int
as
begin
	select Sum(ct.soluong*ct.dongia) as DoanhThu
	from DonHang dh join
		 ChiTietDonHang ct on
		 (dh.madh = ct.madh)
	where year(dh.ngaygiao) = @nam and dh.tinhtrang = 'Da Giao'
end
go

create proc SoSanhDoanhThuTheoThang
@thang1 int, @thang2 int
as 
begin
	select Sum(ct.soluong*ct.dongia) as DoanhThu
	from DonHang dh join
		 ChiTietDonHang ct on
		 (dh.madh = ct.madh)
	where month(dh.ngaygiao) = @thang1 and dh.tinhtrang = 'Da Giao'

	select Sum(ct.soluong*ct.dongia) as DoanhThu
	from DonHang dh join
		 ChiTietDonHang ct on
		 (dh.madh = ct.madh)
	where month(dh.ngaygiao) = @thang2 and dh.tinhtrang = 'Da Giao'
end

go

create proc SoSanhDoanhThuTheoNam
@nam1 int, @nam2 int
as 
begin
	select Sum(ct.soluong*ct.dongia) as DoanhThu
	from DonHang dh join
		 ChiTietDonHang ct on
		 (dh.madh = ct.madh)
	where year(dh.ngaygiao) = @nam1 and dh.tinhtrang = 'Da Giao'

	select Sum(ct.soluong*ct.dongia) as DoanhThu
	from DonHang dh join
		 ChiTietDonHang ct on
		 (dh.madh = ct.madh)
	where year(dh.ngaygiao) = @nam2 and dh.tinhtrang = 'Da Giao'
end

go

--xem so luong ton kho
create proc XemSoLuongTonKho 
@mahoa int
as
begin
	select t.mahoa, Sum(t.soluongtonkho) as SoLuongTonKho
	from tonkho t
	where t.mahoa = @mahoa
end

go

--Phân Quyền
go
exec sp_addrole 'khachhang'
exec sp_addrole 'nhanvien'
exec sp_addrole 'quanly'
go
create view ThongTinKH
as select kh.account, a.pw, kh.hoten, kh.diachi, kh.sdt, kh.email
from KhachHang kh join Acc a on (kh.account =a.account)
where a.account = CURRENT_USER

go 
grant select,update on ThongTinKH to khachhang
grant select on DonHang to khachhang
grant select,add,update,delete on ChiTietDonHang to khachhang
grant select on Hoa to khachhang
grant select on LoaiHoa to khachhang
go
grant select,update on NhanVien to nhanvien
grant select,add on diemdanh to nhanvien
grant select, update on DonHang to nhanvien
go
grant select,update on QuanLy to quanly
grant select on lichsuluong to quanly
grant ALL on NhanVien to quanly
grant ALL on Hoa to quanly
grant ALL on LoaiHoa to quanly
grant select,update on cuahang to quanly
grant select on lichsugiasanpham to quanly
grant ALL on tonkho to quanly
go
--Đăng ký tài khoản
create procedure CreateLoginAndUser
@login varchar(100),
@password varchar(100),
@db varchar(100)
as
begin
declare @safe_login varchar(200)
declare @safe_password varchar(200)
declare @safe_db varchar(200)
set @safe_login = replace(@login,'''', '''''')
set @safe_password = replace(@password,'''', '''''')
set @safe_db = replace(@db,'''', '''''')

declare @sql nvarchar(max)
set @sql = 'use ' + @safe_db + ';' +
           'create login ' + @safe_login + 
               ' with password = ''' + @safe_password + '''; ' +
           'create user ' + @safe_login + ' from login ' + @safe_login + ';'
exec (@sql)
end

go

create proc DangKyTaiKhoan
@id int, @account varchar(20), @pass varchar(20), @hoten nvarchar(50), @diachi nvarchar(50),
@sdt char(10), @email varchar(20)
as
begin
	EXEC CreateLoginAndUser @account,@pass,'QuanLyBanHang'
	EXEC sp_addrolemember 'khachhang', @account
	Insert into KhachHang values (@id, @account, @hoten, @diachi, @sdt, @email)
end

