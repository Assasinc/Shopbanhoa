CREATE DATABASE QuanLyBanHang
go
USE QuanLyBanHang

GO 


CREATE TABLE QuanLy(
	idquanly INT,
	account VARCHAR(20),
	hoten NVARCHAR(50),
	diachi NVARCHAR(50),
	sdt CHAR(10),
	email VARCHAR(20)
	PRIMARY KEY (idquanly)
)

CREATE TABLE NhanVien(
	idnhanvien INT,
	account VARCHAR(20),
	idcuahang int,
	hoten NVARCHAR(50),
	diachi NVARCHAR(50),
	sdt CHAR(10),
	email VARCHAR(20),
	luong Decimal(12,3),
	sodonhang smallint,
	doanhso Decimal(12,3),
	PRIMARY KEY (idnhanvien)
)

CREATE TABLE KhachHang(
	idkhachhang INT,
	account VARCHAR(20),
	hoten NVARCHAR(50),
	diachi NVARCHAR(50),
	sdt CHAR(10),
	email VARCHAR(20)
	PRIMARY KEY (idkhachhang)
)

create table cuahang(
	idcuahang int,
	diachi nvarchar(50),
	sdt char(10),
	idquanly INT,
	primary key (idcuahang)
)

create table tonkho(
	idcuahang int,
	mahoa int,
	soluongtonkho smallint,
	primary key (idcuahang, mahoa)
)
CREATE TABLE Hoa(
	mahoa INT,
	tenhoa NVARCHAR(50),
	maloaihoa int,
	mausac nvarchar(10),
	dongia Decimal(12,3),
	giamgia smallint,
	PRIMARY KEY (mahoa)
)

Create Table LoaiHoa(
	maloaihoa int,
	tenloai nvarchar(20),
	primary key (maloaihoa)
)
create TABLE DonHang(
	madh INT,
	idkhachhang INT,
	idnhanvien int,
	ngaygiao date,
	tongtien Decimal(12,3),
	tinhtrang VARCHAR(20),
	diachigiaohang nvarchar(70),
	PRIMARY KEY (madh)
)

CREATE TABLE ChiTietDonHang(
	madh INT,
	mahoa INT,
	soluong smallint,
	dongia Decimal(12,3),
	PRIMARY KEY (madh, mahoa)
)

CREATE TABLE Acc(
	account VARCHAR(20),
	pw VARCHAR(20),
	PRIMARY KEY (account)
)

create table lichsugiasanpham(
	mahoa int,
	gia Decimal(12,3),
	ngaydoi datetime,
	primary key (mahoa, ngaydoi)
)

create table lichsuluong(
	idnhanvien int,
	luong Decimal(12,3),
	ngaydoi datetime,
	primary key (idnhanvien, ngaydoi)
)
create table diemdanh(
	ngay date,
	idnhanvien int,
	diemdanh varchar(1),
	primary key (idnhanvien, ngay)
)

	
GO

ALTER TABLE [dbo].[ChiTietDonHang]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietDonHang_DonHang] FOREIGN KEY([madh])
REFERENCES [dbo].[DonHang] ([madh])

GO
ALTER TABLE [dbo].[ChiTietDonHang]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietDonHang_SanPham] FOREIGN KEY([mahoa])
REFERENCES [dbo].[Hoa] ([mahoa])

GO
ALTER TABLE [dbo].[diemdanh]  WITH CHECK ADD  CONSTRAINT [FK_diemdanh_NhanVien] FOREIGN KEY([idnhanvien])
REFERENCES [dbo].[NhanVien] ([idnhanvien])

GO
ALTER TABLE [dbo].[DonHang]  WITH CHECK ADD  CONSTRAINT [FK_DonHang_KhachHang] FOREIGN KEY([idkhachhang])
REFERENCES [dbo].[KhachHang] ([idkhachhang])

GO
ALTER TABLE [dbo].[DonHang]  WITH CHECK ADD  CONSTRAINT [FK_DonHang_KhachHang1] FOREIGN KEY([idkhachhang])
REFERENCES [dbo].[KhachHang] ([idkhachhang])

GO
ALTER TABLE [dbo].[DonHang]  WITH CHECK ADD  CONSTRAINT [FK_DonHang_NhanVien] FOREIGN KEY([idnhanvien])
REFERENCES [dbo].[NhanVien] ([idnhanvien])

GO
ALTER TABLE [dbo].[KhachHang]  WITH CHECK ADD  CONSTRAINT [FK_KhachHang_Acc] FOREIGN KEY([account])
REFERENCES [dbo].[Acc] ([account])

GO
ALTER TABLE [dbo].[lichsugiasanpham]  WITH CHECK ADD  CONSTRAINT [FK_lichsugiasanpham_Hoa] FOREIGN KEY([mahoa])
REFERENCES [dbo].[Hoa] ([mahoa])

GO
ALTER TABLE [dbo].[lichsuluong]  WITH CHECK ADD  CONSTRAINT [FK_lichsuluong_NhanVien] FOREIGN KEY([idnhanvien])
REFERENCES [dbo].[NhanVien] ([idnhanvien])

GO
ALTER TABLE [dbo].[NhanVien]  WITH CHECK ADD  CONSTRAINT [FK_NhanVien_Acc] FOREIGN KEY([account])
REFERENCES [dbo].[Acc] ([account])

GO
ALTER TABLE [dbo].[NhanVien]  WITH CHECK ADD  CONSTRAINT [FK_NhanVien_cuahang] FOREIGN KEY([idcuahang])
REFERENCES [dbo].[cuahang] ([idcuahang])
go
ALTER TABLE [dbo].[cuahang]  WITH CHECK ADD  CONSTRAINT [FK_cuahang_QuanLy] FOREIGN KEY([idquanly])
REFERENCES [dbo].[Quanly] ([idquanly])

GO
ALTER TABLE [dbo].[QuanLy]  WITH CHECK ADD  CONSTRAINT [FK_QuanLy_Acc] FOREIGN KEY([account])
REFERENCES [dbo].[Acc] ([account])

GO
ALTER TABLE [dbo].[tonkho]  WITH CHECK ADD  CONSTRAINT [FK_tonkho_cuahang] FOREIGN KEY([idcuahang])
REFERENCES [dbo].[cuahang] ([idcuahang])

GO
ALTER TABLE [dbo].[tonkho]  WITH CHECK ADD  CONSTRAINT [FK_tonkho_Hoa] FOREIGN KEY([mahoa])
REFERENCES [dbo].[Hoa] ([mahoa])
GO
ALTER TABLE [dbo].[Hoa]  WITH CHECK ADD  CONSTRAINT [FK_Hoa_LoaiHoa] FOREIGN KEY([maloaihoa])
REFERENCES [dbo].[LoaiHoa] ([maloaihoa])


go
--Tạo trigger
create trigger totalprice
on ChiTietDonHang
AFTER INSERT
AS 
BEGIN 
	UPDATE DonHang
	SET tongtien = dh.tongtien + i.soluong * h.dongia - i.soluong * h.dongia * h.giamgia/100
	FROM DonHang dh join inserted i on
		 (dh.madh = i.madh) join
		 Hoa h on
		 (i.mahoa = h.mahoa)
END


go

create trigger totalprice_delete
on ChiTietDonHang
AFTER delete
AS 
BEGIN 
	UPDATE DonHang
	SET tongtien = dh.tongtien - (d.soluong * d.dongia)
	FROM DonHang dh, deleted d
	WHERE dh.madh = d.madh
END
go

create trigger sodonhang_nhanvien
on DonHang
AFTER UPDATE
AS 
BEGIN 
	UPDATE NhanVien
	SET sodonhang = nv.sodonhang + 1
	FROM NhanVien nv, inserted i
	WHERE nv.idnhanvien = i.idnhanvien and i.tinhtrang = 'Da Giao'
END

go

create trigger doanhso_nhanvien
on DonHang
AFTER UPDATE
AS 
BEGIN 
	UPDATE NhanVien
	SET doanhso = nv.doanhso + i.tongtien
	FROM NhanVien nv, inserted i
	WHERE nv.idnhanvien = i.idnhanvien and i.tinhtrang = 'Da Giao'
END

go
create trigger lichsuluongnv
on NhanVien
for UPDATE
AS 
if update(luong)
BEGIN 
	INSERT INTO lichsuluong 
	select nv.idnhanvien,nv.luong,CURRENT_TIMESTAMP 
	from NhanVien nv 
	     join inserted i on 
		 nv.idnhanvien = i.idnhanvien
END

go
create trigger lichsugiahoa
on Hoa
for UPDATE
AS 
if update(dongia)
BEGIN 
	INSERT INTO lichsugiasanpham
	select h.mahoa,h.dongia,CURRENT_TIMESTAMP 
	from Hoa h 
	     join inserted i on 
		 h.mahoa = i.mahoa
END

go
create trigger capnhatgia
on ChiTietDonHang
for INSERT
AS 
BEGIN 
	UPDATE ChiTietDonHang set dongia = h.dongia - h.dongia*h.giamgia/100
	from Hoa h join inserted i on 
		 (h.mahoa = i.mahoa) join
		 ChiTietDonHang ct on
		 (ct.mahoa = i.mahoa)
END


go

create rule diemdanh_xv as  @list in ('x','v')
go
EXEC sp_bindrule 'diemdanh_xv', 'diemdanh.diemdanh'

go
INSERT dbo.Acc(account, pw) VALUES (N'quanly1', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'quanly2', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'quanly3', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'quanly4', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'quanly5', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'quanly6', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'quanly7', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'quanly8', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'quanly9', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'quanly10', 'EWIYZVFAOM67') 
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien1', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien2', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien3', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien4', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien5', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien6', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien7', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien8', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien9', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien10', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien11', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien12', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien13', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien14', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien15', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien16', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien17', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien18', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien19', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien20', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien21', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien22', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien23', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien24', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien25', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien26', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien27', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien28', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien29', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien30', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien31', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien32', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien33', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien34', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien35', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien36', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien37', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien38', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien39', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien40', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien41', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien42', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien43', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien44', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien45', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien46', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien47', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien48', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien49', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'nhanvien50', 'EWIYZVFAOM67')
INSERT dbo.Acc(account, pw) VALUES (N'user00', 'AG80')
INSERT dbo.Acc(account, pw) VALUES (N'user01', 'PJMIQKMWFNHWZRHGAOKR')
INSERT dbo.Acc(account, pw) VALUES (N'user02', 'LH31')
INSERT dbo.Acc(account, pw) VALUES (N'user03', 'TGEXGTSGQGVRAGKZXT72')
INSERT dbo.Acc(account, pw) VALUES (N'user04', 'NXOEPQDF08')
INSERT dbo.Acc(account, pw) VALUES (N'user05', 'AJJS83')
INSERT dbo.Acc(account, pw) VALUES (N'user06', 'UQFCBUITHMCKHTOONIPL')
INSERT dbo.Acc(account, pw) VALUES (N'user07', 'DUKK06')
INSERT dbo.Acc(account, pw) VALUES (N'user08', 'NXULDMSXQJFALACG00')
INSERT dbo.Acc(account, pw) VALUES (N'user09', 'WQ24')
INSERT dbo.Acc(account, pw) VALUES (N'user10', 'IYIKQUEE29')
INSERT dbo.Acc(account, pw) VALUES (N'user11', 'TX47')
INSERT dbo.Acc(account, pw) VALUES (N'user12', 'WAZYZG31')
INSERT dbo.Acc(account, pw) VALUES (N'user13', 'KXVPDE10')
INSERT dbo.Acc(account, pw) VALUES (N'user14', 'FC78')
INSERT dbo.Acc(account, pw) VALUES (N'user15', 'UMMQFYHI77')
INSERT dbo.Acc(account, pw) VALUES (N'user16', 'RR41')
INSERT dbo.Acc(account, pw) VALUES (N'user17', 'QJ85')
INSERT dbo.Acc(account, pw) VALUES (N'user18', 'FRHUFAMMVUTKXD44')
INSERT dbo.Acc(account, pw) VALUES (N'user19', 'PSODGFZQPAWMYEPJWFUF')
INSERT dbo.Acc(account, pw) VALUES (N'user20', 'XHONKK98')
INSERT dbo.Acc(account, pw) VALUES (N'user21', 'NNHD56')
INSERT dbo.Acc(account, pw) VALUES (N'user22', 'BAMP91')
INSERT dbo.Acc(account, pw) VALUES (N'user23', 'VVJW25')
INSERT dbo.Acc(account, pw) VALUES (N'user24', 'YDZXYXGE61')
INSERT dbo.Acc(account, pw) VALUES (N'user25', 'YFAPKKEN39')
INSERT dbo.Acc(account, pw) VALUES (N'user26', 'VDMLLS88')
INSERT dbo.Acc(account, pw) VALUES (N'user27', 'CGGLXFKZOP86')
INSERT dbo.Acc(account, pw) VALUES (N'user28', 'ILNX29')
INSERT dbo.Acc(account, pw) VALUES (N'user29', 'UDXPED28')
INSERT dbo.Acc(account, pw) VALUES (N'user30', 'CY76')
INSERT dbo.Acc(account, pw) VALUES (N'user31', 'FCPWIFJRTD51')
INSERT dbo.Acc(account, pw) VALUES (N'user32', 'LM25')
INSERT dbo.Acc(account, pw) VALUES (N'user33', 'XMCWGR30')
INSERT dbo.Acc(account, pw) VALUES (N'user34', 'PPKFJVRAWIQHLPOJNTHD')
INSERT dbo.Acc(account, pw) VALUES (N'user35', 'RMEYYDES91')
INSERT dbo.Acc(account, pw) VALUES (N'user36', 'MLHVAIXURLSGNZZT66')
INSERT dbo.Acc(account, pw) VALUES (N'user37', 'SD82')
INSERT dbo.Acc(account, pw) VALUES (N'user38', 'KS30')
INSERT dbo.Acc(account, pw) VALUES (N'user39', 'TLQEPPETDXFBQXMMTAGM')
INSERT dbo.Acc(account, pw) VALUES (N'user40', 'KXADKEIWIGVCXICPYROL')
INSERT dbo.Acc(account, pw) VALUES (N'user41', 'HMLAZVNXAKIUUEJP78')
INSERT dbo.Acc(account, pw) VALUES (N'user42', 'VMMFIKQUADOBUAPHYSVO')
INSERT dbo.Acc(account, pw) VALUES (N'user43', 'BEZRSAIRLQRL87')
INSERT dbo.Acc(account, pw) VALUES (N'user44', 'IMXHLWWLZJDN35')
INSERT dbo.Acc(account, pw) VALUES (N'user45', 'MWKYGIWAXKTETE91')
INSERT dbo.Acc(account, pw) VALUES (N'user46', 'FFLEVDLZ60')
INSERT dbo.Acc(account, pw) VALUES (N'user47', 'LVKNHE49')
INSERT dbo.Acc(account, pw) VALUES (N'user48', 'JQUEGLXJSTISHJTGCT76')
INSERT dbo.Acc(account, pw) VALUES (N'user49', 'EWIYZVFAOM67')
GO
INSERT dbo.QuanLy(idquanly, account, hoten, diachi, sdt, email) VALUES (1, 'quanly1', N'Phạm Thị Thanh Thùy', N'Oefelestraße 2, 13603, Bad Sassendorf', '0308070807', 'Sherry_XFranz94@nowh')
INSERT dbo.QuanLy(idquanly, account, hoten, diachi, sdt, email) VALUES (2, 'quanly2', N'Nguyễn Quốc Huy	 	 ', N'Daiserstraße 1, 12722, Welver', '0903090307', 'Bud.Albrecht@nowhere')
INSERT dbo.QuanLy(idquanly, account, hoten, diachi, sdt, email) VALUES (3, 'quanly3', N'Đặng Tuấn Anh	 	 ', N'Beetzstraße 24, 09672, Lykershausen', '0819373329', 'Russell@example.com')
INSERT dbo.QuanLy(idquanly, account, hoten, diachi, sdt, email) VALUES (4, 'quanly4', N'Đặng Thành Trung	 	 	', N'Nymphenburger Straße 3, 41247, Neuhemsbach', '0909090309', 'AbelLott@example.com')
INSERT dbo.QuanLy(idquanly, account, hoten, diachi, sdt, email) VALUES (5, 'quanly5', N'Phạm Duy', N'Schrenkstraße 96c, 77345, Pahlsdorf', '0309074776', 'Harvey@example.com')
INSERT dbo.QuanLy(idquanly, account, hoten, diachi, sdt, email) VALUES (6, 'quanly6', N'Nguyễn Thế Tài', N'Hotterstraße 12d, 61488, Ahlsdorf', '0702828678', 'MargotCroft43@exampl')
INSERT dbo.QuanLy(idquanly, account, hoten, diachi, sdt, email) VALUES (7, 'quanly7', N'Trần Bảo Ngân	 	', N'Schwarzmannstraße 1, 85300, Raßmannsdorf', '0907080746', 'exmq9758@example.com')
INSERT dbo.QuanLy(idquanly, account, hoten, diachi, sdt, email) VALUES (8, 'quanly8', N'Nguyễn Thị Mai', N'Bad-Schachener-Straße 1d, 39761, Geithain', '0907030268', 'Ocampo@example.com')
INSERT dbo.QuanLy(idquanly, account, hoten, diachi, sdt, email) VALUES (9, 'quanly9', N'Phạm Bảo Liên	 	 	', N'Neuhauser Straße 237a, 75697, Abbau Ader', '0909090809', 'Ellis_Batiste76@exam')
INSERT dbo.QuanLy(idquanly, account, hoten, diachi, sdt, email) VALUES (10, 'quanly10', N'Nguyễn Thị Việt Yên', N'Franz-Josef-Strauß-Ring 8, 35725, Bolsterlang', '0309371247', 'AbbyCreamer@example.')
GO
INSERT dbo.cuahang(idcuahang, diachi, sdt,idquanly) VALUES (1, N'Erhardtstraße 98, 74718, Maasbüll', '0707030839',1)
INSERT dbo.cuahang(idcuahang, diachi, sdt,idquanly) VALUES (2, N'Rupertigaustraße 171, 31085, Karlshuld', '0909095140',2)
INSERT dbo.cuahang(idcuahang, diachi, sdt,idquanly) VALUES (3, N'Waltherstraße 1, 63355, Hengelbach', '0909080937',3)
INSERT dbo.cuahang(idcuahang, diachi, sdt,idquanly) VALUES (4, N'Therese-Danner-Platz 2, 91935, Gießübel', '0907327410',4)
INSERT dbo.cuahang(idcuahang, diachi, sdt,idquanly) VALUES (5, N'Pilotystraße 1, 03973, Holle', '0708030336',5)
INSERT dbo.cuahang(idcuahang, diachi, sdt,idquanly) VALUES (6, N'Adalbert-Stifter-Straße 11-15, 24456, Abbenrode', '0909030907',6)
INSERT dbo.cuahang(idcuahang, diachi, sdt,idquanly) VALUES (7, N'Karl-Scharnagl-Ring 17, 97640, Neuenkirchen', '0708788138',7)
INSERT dbo.cuahang(idcuahang, diachi, sdt,idquanly) VALUES (8, N'Palmstraße 2f, 97300, Wilischthal', '0709193779',8)
INSERT dbo.cuahang(idcuahang, diachi, sdt,idquanly) VALUES (9, N'Untere Feldstraße 1, 77278, Süptitz', '0808090703',9)
INSERT dbo.cuahang(idcuahang, diachi, sdt,idquanly) VALUES (10, N'Adalbertstraße 2, 16119, Abberode', '0907030809',10)
GO



INSERT dbo.LoaiHoa(maloaihoa, tenloai) VALUES (3, N'Hoa mùa Hạ')
INSERT dbo.LoaiHoa(maloaihoa, tenloai) VALUES (2, N'Hoa mùa Xuân ')
INSERT dbo.LoaiHoa(maloaihoa, tenloai) VALUES (1, N'Hoa mùa Đông')
INSERT dbo.LoaiHoa(maloaihoa, tenloai) VALUES (4, N'Hoa mùa Thu')
GO



INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (50, N'Hoa giấy thái', 1, N'tím ', 41144.0569,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (44, N'Tulip trắng', 1, N'trắng', 45324.1557,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (27, N'Lan Bạch Nhạn', 3, N'vàng ', 78167.8787,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (47, N'Lan Tam Bảo Sắc', 3, N'xanh ', 64110.2325,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (45, N'Lan Hoàng Lạp', 4, N'đen', 65282.6168,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (48, N'Tulip tím', 3, N'tím', 38327.3974,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (33, N'Hồng leo tầm xuân', 2, N'đỏ', 71011.7413,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (8, N'Lan cẩm báo', 1, N'hồng', 44447.4395,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (46, N'Hoa hồng tường vi', 2, N'đỏ', 69403.7985,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (49, N'Lan Đùi Gà', 1, N'xanh ', 76206.8339,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (18, N'Hoa giấy cẩm thạch', 1, N'tím ', 11514.7926,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (39, N'Hoa hồng tỉ muội', 3, N'vàng ', 41956.4427,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (34, N'Hoa hồng trắng', 4, N'trắng', 57967.0569,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (13, N'Tulip vàng', 1, N'vàng', 48887.4157,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (3, N'Hồng phấn nữ hoàng', 4, N'đỏ', 18026.1173,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (28, N'Hoa hồng đỏ', 3, N'đỏ', 74191.3372,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (9, N'Quế lan hương', 3, N'đen', 70160.9133,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (4, N'Tulip xanh', 4, N'xanh ', 95891.8493,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (40, N'Tulip đen', 3, N'đen ', 71559.3246,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (23, N'Lan Trúc Phật Bà', 3, N'hồng', 92172.8613,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (29, N'Hoa hồng tím', 3, N'tím ', 35954.8842,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (35, N'Hoa hồng Keira', 1, N'xanh ', 37206.7915,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (19, N'Hoa hồng Blue Sky', 4, N'xanh', 56175.4134,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (10, N'Hoa hồng quế ', 1, N'trắng', 73472.1307,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (14, N'Hoa hồng vàng', 1, N'vàng', 22047.827,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (5, N'Tulip đỏ', 2, N'đỏ ', 54778.7903,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (11, N'Hoa hồng Juliet', 3, N'tím ', 35499.3814,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (6, N'Tulip cam', 1, N'cam', 65181.0353,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (1, N'Hoa hồng xanh dương', 4, N'xanh dương', 83479.2289,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (20, N'Hoa hồng Masora', 3, N'hồng', 36148.2414,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (24, N'Hoa lan chuỗi ngọc', 4, N'xanh ', 63431.4908,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (15, N'Lan Kiều tím', 1, N'tím ', 64159.6714,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (21, N'Hồng leo tầm xuân', 2, N'đen', 82947.8109,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (7, N'Hoa hồng tường vi', 3, N'trắng', 67938.2049,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (30, N'Hoa hồng tỉ muội', 1, N'tím ', 78173.1466,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (25, N'Hoa hồng trắng', 4, N'trắng', 67015.856,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (2, N'Lan Bạch Nhạn', 2, N'vàng ', 38421.4512,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (16, N'Tulip trắng', 3, N'trắng', 18032.2806,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (22, N'Hồng phấn nữ hoàng', 4, N'đỏ', 30566.6201,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (31, N'Hoa hồng đỏ', 1, N'đỏ ', 32843.7235,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (41, N'Lan Tam Bảo Sắc', 4, N'xanh ', 45883.789,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (17, N'Lan Hoàng Lạp', 4, N'trắng', 74761.1606,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (36, N'Hoa giấy thái', 3, N'xanh ', 99452.2633,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (26, N'Lan Đùi Gà', 2, N'vàng ', 75806.9418,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (32, N'Lan cẩm báo', 4, N'đỏ', 92771.8663,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (42, N'Hoa hồng tím', 4, N'tím', 51400.2073,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (12, N'Tulip tím', 2, N'tím', 14147.6424,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (37, N'Hoa hồng Keira', 1, N'hồng', 87078.2502,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (43, N'Hoa hồng Blue Sky', 1, N'xanh ', 29284.5087,0)
INSERT dbo.Hoa(mahoa, tenhoa, maloaihoa, mausac, dongia,giamgia) VALUES (38, N'Hoa hồng Juliet', 2, N'vàng ', 70199.149,0)
GO


--
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (2, 'user17', N'Phạm Bảo Liên	 	 	', N'Orffstraße 5, 55856, Riesbürg', '0703549721', 'AbeSSims856@example.')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (8, 'user00', N'Hoàng Đức Anh	 	 ', N'Wagmüllerstraße 8, 05289, Kasel', '0808865541', 'Abraham4@example.com')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (49, 'user45', N'Trần An Dương	 	 ', N'Dürnbräugasse 24, 27762, Gallentin', '0708101911', 'iydogbz3859@example.')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (12, 'user10', N'Lưu Trang Anh	 	 ', N'Gellertstraße 11-16, 87138, Weinähr', '0307091751', 'RooseveltAbbott@exam')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (28, 'user36', N'Bùi Mạnh Hùng', N'Krumbacherstraße 3, 42211, Aach', '0372403841', 'Buena.W_Moran286@now')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (47, 'user05', N'Nguyễn Mạnh Hùng', N'Anglerstraße 8d, 22310, Pfaffen-Schwabenheim', '0908162033', 'LelandAckerman@examp')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (23, 'user19', N'Trần Bảo Ngân	 	', N'Aberlestraße 57b, 41768, Zwickau', '0307030308', 'AlesiaLilly47@nowher')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (36, 'user19', N'Bùi Văn Quân', N'Lueg ins Land 14-17, 81090, Wangenheim', '0964996426', 'Gustavo_G.Frantz69@n')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (18, 'user21', N'Mạc Trung Đức	 	 ', N'Spiridon-Louis-Ring 2, 96809, Albersroda', '0307585685', 'Rachell_Hatley946@ex')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (45, 'user31', N'Trần Uyên Nhi	 	', N'Winthirstraße 6, 72606, Wilhelmsdorf', '0848551810', 'Abraham.Andersen334@')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (50, 'user09', N'Nguyễn Văn Chung', N'Felix-Dahn-Straße 181c, 46529, Altdorf', '0308090765', 'AlonzoTeel@example.c')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (48, 'user15', N'Phạm Hoàng Anh	 	 ', N'Ackermannstraße 21-25, 23115, Borgisdorf', '0885120024', 'Librada.Valenzuela@n')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (13, 'user05', N'Đỗ Hà Linh	 	', N'Birkerstraße 1, 99077, Affing', '0908057175', 'qfaozsv350@example.c')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (46, 'user34', N'Đỗ Quang Ngọc	 	 	', N'Stuckstraße 65e, 75303, Oberweis', '0809093285', 'Abreu@nowhere.com')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (3, 'user16', N'Nguyễn Thị Hương', N'Weißenburger Platz 2a, 98312, Gadebusch', '0903576056', 'qgucmz5243@nowhere.c')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (42, 'user12', N'Đỗ Quang Minh', N'Nürnberger Straße 4, 49677, Treuen', '0708090760', 'MarcosBowles@nowhere')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (29, 'user42', N'Vũ Hương Giang	  ', N'Richard-Wagner-Straße 1, 69024, Owschlag', '0309080709', 'Celena.Bermudez@exam')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (37, 'user07', N'Trịnh Thiên Trường	 	 	', N'Nockherstraße 4f, 82620, Klein Woltersdorf', '0808565826', 'Conger@example.com')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (19, 'user27', N'Ngô Gia Minh	 	 	', N'Dachauer Straße 9b, 59029, Eversdorf', '0907730167', 'Timmy.Dugger4@exampl')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (24, 'user33', N'Nguyễn Hữu Hiệp Hoàng	 	 ', N'Hohenstaufenstraße 15-18, 29503, Gorsleben', '0703097318', 'Cahill@example.com')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (14, 'user25', N'Trần Đức Trung', N'Herzog-Ernst-Platz 25, 41664, Kelberg', '0707090308', 'wodawfqh7202@example')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (9, 'user44', N'Phạm Thị Hiền Anh	 ', N'Moltkestraße 1, 09527, Ackermannshof', '0909688775', 'vxtv9455@nowhere.com')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (20, 'user14', N'Đàm Yến Nhi	 	 	 	', N'Am Westpark 4, 93485, Weißensberg', '0807080882', 'Gardner@nowhere.com')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (4, 'user44', N'Nguyễn Mạnh Hùng	 	 ', N'Daiserstraße 64a, 69734, Dermbach', '0703357332', 'Lavonia_Reis462@exam')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (30, 'user09', N'Nguyễn Thị Thu Hằng', N'Karlstraße 4, 98128, Rothenburg', '0934683625', 'Clair.Wicker@example')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (10, 'user43', N'Nguyễn Vũ Gia Hưng	 	 ', N'Schraudolphstraße 1d, 24967, Remscheid', '0309132277', 'Andrew@nowhere.com')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (5, 'user05', N'Đoàn Hoàng Sơn	 	 	', N'Elisabethstraße 25, 94729, Gaymühle, Gem Wallendor', '0703080803', 'Abreu354@example.com')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (11, 'user33', N'Đỗ Văn Tấn', N'Rheinstraße 4, 91522, Iggingen', '0777885583', 'Geneva_Garner@exampl')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (25, 'user27', N'Trần Tuấn Hưng	 	 ', N'Rumfordstraße 1, 59187, Crösten', '0860880502', 'Bottoms@example.com')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (6, 'user24', N'Ngô Văn Hiệp', N'Nürnberger Straße 12-15, 52606, Dorum', '0954628270', 'Aubrey_Parsons7@exam')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (1, 'user19', N'Trần Anh Thi', N'Windenmacherstraße 13, 48506, Wodenhof', '0703030562', 'Ada_Lundberg@example')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (43, 'user10', N'Nguyễn Thị Ngân Hà	 ', N'Max-Planck-Straße 1, 28912, Altenhof', '0308034217', 'RayHadden812@nowhere')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (7, 'user07', N'Vũ Thùy Linh	 	', N'Marsplatz 13d, 35558, Alzey', '0976724944', 'Ochoa@example.com')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (31, 'user07', N'Phạm Khắc Việt Anh	 	 ', N'Fürstenstraße 1a, 94178, Schleuse', '0986167062', 'cvzn7143@example.com')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (15, 'user25', N'Trần Kim Ngân	 	', N'Helene-Lange-Weg 8b, 53340, Abtswind', '0841917323', 'MervinE_Acevedo@exam')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (26, 'user27', N'Mai Hoàng Minh	 	 	', N'Rheinbergerstraße 42b, 03805, Bad Doberan', '0732260727', 'EusebiaWyatt11@examp')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (38, 'user04', N'Phạm văn Nam', N'Klosterhofstraße 7b, 61110, Schmalstede', '0707080809', 'Crosby@example.com')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (21, 'user19', N'Trịnh Đình Minh 	', N'Bogenstraße 1, 39751, Achberg', '0809082059', 'Leigh@example.com')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (44, 'user17', N'Phạm Đặng Gia Như	 	 	', N'Pilotystraße 2, 18877, Starsiedel', '0746195907', 'KaterineBagley643@ex')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (32, 'user05', N'Cao Thị Phương Thảo', N'Morassistraße 132, 06755, Denklingen', '0807030883', 'RobinAcevedo@example')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (39, 'user03', N'Phạm Gia Minh	 	 	', N'Ackerstraße 6, 69495, Aurich', '0859568777', 'Alcala1@example.com')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (34, 'user25', N'Vũ Văn Thắng', N'Hofgartenstraße 2, 77814, Rendsburg', '0703020017', 'Manley452@example.co')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (27, 'user41', N'Nguyễn Văn Đạm', N'Zillertalstraße 1b, 56504, Craupe', '0907094452', 'Bellamy@example.com')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (16, 'user32', N'Trần Hoài Phương', N'Kaulbachstraße 1, 43538, Zinndorf', '0307030903', 'zkmnwaux9970@nowhere')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (40, 'user06', N'Phạm  Gia Mạnh', N'Am Tucherpark 1, 93492, Kaperich', '0737301648', 'Bennett.H.Pfeiffer98')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (33, 'user17', N'Tô Diệu Thảo	 	', N'Ebersberger Straße 2, 48509, Mespelbrunn', '0709090708', 'AdolphPannell245@exa')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (35, 'user04', N'Nguyễn Công Thành	 	 	', N'Nikolaistraße 62, 44717, Abtlöbnitz', '0707036037', 'JodyAcevedo@nowhere.')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (41, 'user33', N'Mai Văn Bình', N'Kurfürstenplatz 6, 88017, Holzsußra', '0708080803', 'Chamberlain@nowhere.')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (22, 'user11', N'Đinh Thúy Hằng ', N'Stuckstraße 9, 35915, Bärenstein', '0707080703', 'RusselBeam@example.c')
INSERT dbo.KhachHang(idkhachhang, account, hoten, diachi, sdt, email) VALUES (17, 'user48', N'Tô Sỹ Ngọc', N'Weiglstraße 2d, 93214, Gemmerich', '0908070307', 'Abbott962@example.co')
GO


--
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (1, 'nhanvien1', 5, N'Lê Tất Thế', N'Petersplatz 7, 79344, Neustadt-Glewe', '0728027232', 'Keven.Darling@nowher', 2811043.6809, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (2, 'nhanvien2', 5, N'Bùi Khánh Ngọc 	', N'Aberlestraße 18, 99252, Pützlingen', '0909080703', 'YolandeEscamilla97@n', 4353931.7202, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (3, 'nhanvien3', 4, N'Phạm  Ngọc Thạch', N'Guldeinstraße 29b, 25726, Krottelbach', '0701124130', 'xqmxtw0599@example.c', 2442518.86, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (4, 'nhanvien4', 1, N'Vũ Duy Phương', N'Ackerstraße 6b, 46106, Walting', '0307085096', 'mpcpltaa.mwjzank@now', 3919479.1234, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (5, 'nhanvien5', 8, N'Nguyễn Thái Dương	 	 ', N'Sankt-Jakobs-Platz 1, 78851, Kiedrich', '0807000423', 'Jordan@example.com', 4278000.7731, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (6, 'nhanvien6', 5, N'Trần Đức Dương	 	 ', N'Gabrielenstraße 6e, 28615, Dönitz', '0779524649', 'Rigoberto.Holman@now', 2046214.4291, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (7, 'nhanvien7', 9, N'Mai Văn Bình', N'Adelgundenstraße 2, 84955, Rabenäußig', '0307030010', 'grbatl4337@nowhere.c', 4207023.4974, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (8, 'nhanvien8', 2, N'Đỗ Thùy Linh	 	', N'Utzschneiderstraße 27c, 81722, Schwabert', '0392428030', 'Bonilla@example.com', 2833875.6641, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (9, 'nhanvien9', 5, N'Đỗ Hải Nam	 	 	', N'Schwarzmannstraße 14-15, 65009, Adelheidsdorf', '0803080807', 'Ayres@example.com', 4127665.1821, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (10, 'nhanvien10', 3, N'Đỗ Mạnh Huy', N'Ruppertstraße 7, 88446, Mlode', '0309030303', 'Abernathy43@example.', 4478889.4884, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (11, 'nhanvien11', 7, N'Đặng Huyền Thi	 	', N'Körnerstraße 1f, 11940, Schkauditz', '0707909298', 'RamonSpooner@example', 3026660.9062, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (12, 'nhanvien12', 4, N'Bùi Phạm Vân Anh', N'Amalienstraße 1, 96701, Aasbüttel', '0808080908', 'Anthony661@example.c', 3191976.368, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (13, 'nhanvien13', 1, N'Hoàng Đức Anh	 	 ', N'Schwarzstraße 43, 79559, Sulzdorf', '0303095501', 'DonteAndrus777@examp', 4580749.2493, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (14, 'nhanvien14', 8, N'Bùi Văn Quân', N'Güllstraße 1d, 73023, Willstätt', '0309035882', 'TiaraAlbert@example.', 3368322.1656, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (15, 'nhanvien15', 10, N'Đỗ Quang Ngọc	 	 	', N'Ackerstraße 12b, 55199, Baldringen', '0807651501', 'FredricR_Abel@exampl', 2194584.9413, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (16, 'nhanvien16', 6, N'Trần Diệu Lê', N'Schulstraße 1, 93717, Dexheim', '0908314138', 'Cortes@example.com', 4698413.4656, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (17, 'nhanvien17', 2, N'Nguyễn Thị Hương', N'Rosenstraße 6, 53628, Mücke', '0309030303', 'Donohue@nowhere.com', 4436113.7699, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (18, 'nhanvien18', 4, N'Bùi Mạnh Hùng', N'Artur-Kutscher-Platz 8, 81609, Abberode', '0307090809', 'Palmer42@nowhere.com', 3170983.854, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (19, 'nhanvien19', 6, N'Trần An Dương	 	 ', N'Wurzerstraße 1, 43934, Oberwallmenach', '0908080922', 'hvvmnzra.iblah@examp', 4481190.2186, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (20, 'nhanvien20', 3, N'Phạm Thị Thanh Thùy', N'Alexandrastraße 2, 81575, Windorf', '0303070709', 'kgsvoskw_jczz@nowher', 3194878.0472, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (21, 'nhanvien21', 3, N'Đỗ Quang Minh', N'Gollierstraße 7e, 86710, Agathenburg', '0706226081', 'Otelia.Tierney@nowhe', 2796710.934, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (22, 'nhanvien22', 6, N'Nguyễn Hữu Hiệp Hoàng	 	 ', N'Bavariastraße 94d, 54297, Alleringersleben', '0908090809', 'Malloy@example.com', 2460645.4399, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (23, 'nhanvien23', 9, N'Đỗ Trọng Đức', N'Reisingerstraße 15a, 43014, Unterreit', '0970303261', 'Lynwood_Wilhite635@e', 3217408.5289, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (24, 'nhanvien24', 6, N'Lưu Trang Anh	 	 ', N'Reifenstuelstraße 8, 18343, Neuermark-Lübars', '0809030907', 'KatlynAlonso@nowhere', 2597818.7596, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (25, 'nhanvien25', 2, N'Đinh Thùy Linh	 	 	', N'Adamstraße 4, 44898, Fintel', '0903080787', 'KelsieL_Forrester95@', 3508965.4465, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (26, 'nhanvien26', 2, N'Trần Bảo Ngân	 	', N'Amiraplatz 13, 17106, Unterbrüz', '0303090809', 'Abney831@example.com', 3889617.2264, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (27, 'nhanvien27', 4, N'Trần Uyên Nhi	 	', N'Bereiteranger 27e, 43473, Großpösna', '0809242638', 'Russell_Angel@nowher', 3517857.8196, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (28, 'nhanvien28', 7, N'Nguyễn Quốc Huy	 	 ', N'Kohlstraße 27, 66986, Bannesdorf', '0372548227', 'YukiAcker7@example.c', 2072524.3947, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (29, 'nhanvien29', 6, N'Trần Đức Trung', N'Aberlestraße 22-27, 92994, Breidenbach', '0752343623', 'LonnaOlmstead@exampl', 2986022.9539, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (30, 'nhanvien30', 6, N'Hoàng Nhật Mai	 	', N'Höchlstraße 2, 56688, Neuendorf b Niemegk', '0309080803', 'TreyVilla54@example.', 2701999.6334, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (31, 'nhanvien31', 7, N'Trần Anh Thi', N'Hohenzollernstraße 2, 46923, Abenberg', '0703090309', 'rpgytwho.kjiputsjyj@', 2244913.3955, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (32, 'nhanvien32', 2, N'Đàm Yến Nhi	 	 	 	', N'Regensburger Platz 7, 79755, Aerzen', '0307030311', 'Amaya@example.com', 3650390.3811, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (33, 'nhanvien33', 10, N'Trần Kim Ngân	 	', N'Deidesheimer Straße 18f, 08698, Spornitz', '0308070303', 'Franz62@nowhere.com', 2965735.5066, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (34, 'nhanvien34', 7, N'Đặng Thành Trung	 	 	', N'Marktstraße 2e, 03212, Altendiez', '0809070909', 'lzmt0@example.com', 3966379.3977, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (35, 'nhanvien35', 7, N'Mạc Trung Đức	 	 ', N'Rolandstraße 9b, 99165, Derschen', '0307080308', 'kiuuxinx_ilbil@nowhe', 2558090.7031, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (36, 'nhanvien36', 3, N'Phạm Hoàng Anh	 	 ', N'Saarstraße 2, 58700, Leißling', '0707080865', 'TeganFaust4@nowhere.', 4146772.2198, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (37, 'nhanvien37', 5, N'Vũ Hương Giang	  ', N'Gärtnerplatz 1, 07369, Aasbüttel', '0909079011', 'OdessaAmador@example', 2709924.1994, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (38, 'nhanvien38', 5, N'Nguyễn Thế Tài', N'Gentzstraße 12-19, 17411, Bendhof', '0372124745', 'Eugenie.Fuchs8@nowhe', 2972434.9963, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (39, 'nhanvien39', 9, N'Phạm Thị Hiền Anh	 ', N'Adamstraße 1, 01927, Lausnitz', '0327720478', 'Abbott469@example.co', 4957506.8419, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (40, 'nhanvien40', 3, N'Phạm Đặng Gia Như	 	 	', N'Gumppenbergstraße 91, 33643, Alterode', '0808080803', 'xpygf6449@nowhere.co', 2215821.0257, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (41, 'nhanvien41', 10, N'Nguyễn Mạnh Hùng	 	 ', N'Adamstraße 1, 38903, Balgstädt', '0709090908', 'HerbertBass6@example', 4574941.4423, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (42, 'nhanvien42', 4, N'Nguyễn Thị Ngân Hà	 ', N'Hans-Fischer-Straße 30, 67676, Hirz-Maulsbach', '0807090803', 'AdolphAbel@example.c', 3078661.0954, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (43, 'nhanvien43', 6, N'Nguyễn Thị Thu Hằng', N'Elisabeth-Kohn-Straße 94, 58505, Addebüll', '0853648754', 'DwainDahl@example.co', 4500858.3172, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (44, 'nhanvien44', 2, N'Nguyễn Thị Mai', N'Ligsalzstraße 4c, 28258, Hebertshausen', '0309080809', 'LatoyaLatham@example', 4592620.8419, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (45, 'nhanvien45', 9, N'Trần Hoài Phương', N'Richard-Wagner-Straße 9, 01923, Neu Gülze', '0903085234', 'Enoch.Tribble@exampl', 2037013.6601, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (46, 'nhanvien46', 9, N'Phạm  Gia Mạnh', N'Adelheidstraße 1e, 43224, Tastungen', '0703746504', 'Marin666@example.com', 3183023.3674, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (47, 'nhanvien47', 4, N'Đinh Trọng Hiệp', N'Ringseisstraße 3, 18361, Rosenau', '0803090725', 'LesiaMosher@example.', 4765617.9325, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (48, 'nhanvien48', 5, N'Hoàng Đại Thắng', N'Gentzstraße 5, 39788, Weilmünster', '0750655045', 'Cassaundra_N.Villanu', 2033964.5585, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (49, 'nhanvien49', 7, N'Nguyễn Vũ Gia Hưng	 	 ', N'Auerfeldstraße 7, 24488, Prinzhöfte', '0908298436', 'Adam.Andersen@exampl', 3914261.9449, 0, 0)
INSERT dbo.NhanVien(idnhanvien, account, idcuahang, hoten, diachi, sdt, email, luong, sodonhang, doanhso) VALUES (50, 'nhanvien50', 8, N'Phạm Bảo Liên	 	 	', N'Helene-Lange-Weg 54, 16298, Metzenhausen', '0807996079', 'ScottAbbott@example.', 4683271.0308, 0, 0)
GO


--
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (50, 33, 13, '2021-03-11', 0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (46, 16, 29, '2021-08-25', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (37, 10, 32, '2021-12-25', 0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (18, 7, 48, '2021-07-02', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (13, 11, 12, '2021-07-31', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (5, 28, 33, '2021-06-16',0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (43, 20, 4, '2021-12-09',0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (25, 15, 4, '2021-01-14', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (31, 33, 19, '2021-03-10', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (19, 43, 1, '2021-12-23', 0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (38, 44, 48, '2021-06-04',0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (11, 13, 46, '2021-04-22', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (6, 36, 47, '2021-06-09', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (26, 11, 26, '2021-02-23',0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (32, 23, 10, '2021-11-28', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (44, 20, 39, '2021-05-13', 0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (49, 35, 19, '2021-11-29',0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (47, 10, 24, '2021-11-05', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (45, 43, 11, '2021-07-28',0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (48, 21, 42, '2021-12-28', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (39, 22, 1, '2021-11-13',0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (1, 11, 23, '2021-01-01',0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (7, 38, 25, '2021-08-23',0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (34, 13, 24, '2021-04-19', 0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (2, 43, 32, '2021-08-12', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (27, 30, 7, '2021-06-06', 0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (14, 22, 34, '2021-03-03', 0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (20, 47, 24, '2021-03-31', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (8, 12, 25, '2021-06-22', 0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (40, 47, 2, '2021-04-13', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (35, 24, 16, '2021-02-17', 0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (3, 2, 25, '2021-04-03', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (15, 16, 25, '2021-02-14',0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (33, 48, 24, '2021-02-14', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (28, 12, 28, '2021-10-30', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (23, 38, 24, '2021-10-19',0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (21, 40, 11, '2021-04-13', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (9, 12, 23, '2021-04-20',0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (29, 1, 39, '2021-06-26',0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (16, 24, 27, '2021-09-21', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (41, 16, 43, '2021-03-28',0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (36, 2, 49, '2021-04-23', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (4, 5, 14, '2021-09-03', 0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (42, 32, 7, '2021-04-29', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (24, 38, 10, '2021-07-29',0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (22, 1, 13, '2021-11-18', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (17, 30, 20, '2021-01-06',0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (12, 46, 26, '2021-04-20',0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (30, 26, 37, '2021-10-17', 0, 'Da Giao',N'Orffstraße 5, 55856, Riesbürg')
INSERT dbo.DonHang(madh, idkhachhang, idnhanvien, ngaygiao, tongtien, tinhtrang,diachigiaohang) VALUES (10, 48, 6, '2021-04-13', 0, 'Chua Giao',N'Orffstraße 5, 55856, Riesbürg')
GO


--
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (17, 12, 3, 19623.56)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (31, 46, 13, 894712.994)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (47, 4, 7, 9413499.9261)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (18, 47, 7, 3792536.2129)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (20, 6, 22, 2859411.2825)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (10, 38, 48, 1628030.1271)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (24, 32, 16, 5078099.6098)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (12, 37, 96, 7659936.7528)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (22, 42, 24, 3621365.19)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (7, 19, 81, 892648.0254)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (6, 34, 35, 8469043.6454)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (45, 40, 5, 8084219.9599)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (36, 17, 4, 2212222.3374)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (26, 13, 83, 3305382.8308)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (48, 23, 75, 6274087.8045)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (30, 43, 73, 8230649.4849)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (32, 3, 64, 2619944.1799)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (21, 2, 45, 399568.1768)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (4, 36, 70, 2887472.3204)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (39, 29, 23, 8373913.0268)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (8, 1, 11, 6198255.4418)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (9, 16, 75, 3074095.6684)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (19, 49, 65, 3039689.9648)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (44, 28, 17, 2171746.7135)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (13, 45, 58, 1746100.793)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (38, 18, 81, 9731007.844)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (34, 10, 84, 6195811.6101)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (40, 20, 95, 9738947.9988)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (2, 14, 20, 6104810.5028)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (1, 35, 93, 5820827.3802)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (42, 26, 9, 6064017.0843)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (5, 48, 53, 5735192.0596)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (35, 24, 1, 9297876.5685)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (29, 22, 99, 2974309.142)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (27, 5, 76, 6858502.5893)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (3, 15, 99, 7409633.2248)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (49, 9, 45, 9938432.3966)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (11, 39, 33, 335212.9905)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (50, 50, 37, 261574.0115)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (33, 7, 89, 7477255.8299)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (16, 31, 66, 7211862.616)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (14, 11, 18, 7273772.6088)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (15, 21, 69, 6435498.8944)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (43, 33, 35, 883121.3791)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (28, 30, 79, 923646.3664)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (41, 41, 56, 3163123.3143)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (23, 25, 90, 2640628.515)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (46, 44, 15, 4906378.5241)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (25, 8, 17, 6399580.5617)
INSERT dbo.ChiTietDonHang(madh, mahoa, soluong, dongia) VALUES (37, 27, 17, 8861198.5134)
GO


--
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (47, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (9, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (18, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (4, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (28, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (50, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (45, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (48, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (46, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (23, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (13, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (19, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (42, '2021-12-31', 'X')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (14, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (20, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (49, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (15, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (37, '2021-12-31', 'X')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (43, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (21, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (29, '2021-12-31', 'X')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (38, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (10, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (16, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (5, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (11, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (24, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (30, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (25, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (22, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (44, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (6, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (31, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (39, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (26, '2021-12-31', 'X')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (32, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (17, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (12, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (1, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (34, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (40, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (27, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (33, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (7, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (35, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (41, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (36, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (2, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (8, '2021-12-31', 'V')
INSERT dbo.diemdanh(idnhanvien, ngay, diemdanh) VALUES (3, '2021-12-31', 'V')
GO



--

--
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (7, 18, 71)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (9, 46, 25)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (8, 46, 94)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (4, 47, 70)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (8, 49, 100)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (10, 13, 95)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (5, 46, 8)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (8, 39, 95)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (6, 49, 44)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (3, 45, 55)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (3, 47, 55)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (9, 49, 19)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (2, 48, 78)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (4, 45, 82)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (10, 18, 51)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (9, 34, 50)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (5, 48, 67)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (7, 49, 1)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (3, 33, 8)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (1, 27, 44)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (9, 18, 84)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (8, 18, 76)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (10, 49, 88)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (6, 33, 66)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (5, 45, 7)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (1, 44, 91)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (4, 48, 6)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (10, 39, 80)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (5, 33, 30)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (2, 47, 5)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (4, 8, 6)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (6, 48, 52)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (1, 47, 9)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (9, 39, 52)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (6, 8, 81)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (2, 45, 16)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (7, 8, 6)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (2, 27, 45)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (1, 50, 97)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (4, 33, 47)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (10, 34, 52)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (7, 46, 37)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (3, 48, 27)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (7, 33, 6)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (5, 8, 30)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (1, 45, 97)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (6, 46, 84)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (2, 44, 59)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (8, 8, 29)
INSERT dbo.tonkho(idcuahang, mahoa, soluongtonkho) VALUES (3, 27, 92)
GO