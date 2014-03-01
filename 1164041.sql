select * from GIAOVIEN
select * from GIAOVIEN_DAY_MONHOC 
---------------------cau 3
create trigger cau3 on GIAOVIEN_DAY_MONHOC
for insert
as 
	begin
		declare @Magv nchar(10)
		declare cur_search cursor for(select Magv from inserted)
		open cur_search
		begin
		fetch next from cur_search into @Magv
		while @@fetch_status=0
			begin
			update GIAOVIEN SET somoncotheGD =somoncotheGD +1
				where Magv =@Magv 
		fetch next from cur_search into @Magv
			end
		end
		close cur_search
		deallocate cur_search
end
create trigger cau3_2 on GIAOVIEN_DAY_MONHOC
for delete
as 
	begin
		declare @Magv nchar(10)
		declare cur_search cursor for(select Magv from inserted)
		open cur_search
		begin
		fetch next from cur_search into @Magv
		while @@fetch_status=0
			begin
			update GIAOVIEN SET somoncotheGD =somoncotheGD -1
				where Magv =@Magv 
		fetch next from cur_search into @Magv
			end
		end
		close cur_search
		deallocate cur_search
end
-----------cau 2
create trigger cau2 on HOCVIEN
for insert
as 
	begin
		declare @Malop nchar(10)
		declare cur_search cursor for(select Malop from inserted)
		open cur_search
		begin
		fetch next from cur_search into @Malop
		while @@fetch_status=0
			begin
			update LOPHOC SET Siso =Siso+1
				where Malop=@Malop
		fetch next from cur_search into @Malop
			end
		end
		close cur_search
		deallocate cur_search
end
 
create trigger cau2_2 on HOCVIEN
for insert
as 
	begin
		declare @Malop nchar(10)
		declare cur_search cursor for(select Malop from inserted)
		open cur_search
		begin
		fetch next from cur_search into @Malop
		while @@fetch_status=0
			begin
			update LOPHOC SET Siso =Siso-1
				where Malop=@Malop
		fetch next from cur_search into @Malop
			end
		end
		close cur_search
		deallocate cur_search
end
-------------cau 1
select * from PHANCONG
select * from GIAOVIEN 
create trigger cau1 on PHANCONG
for insert
as 
	begin
		declare @Magv nchar(10)
		declare cur_search cursor for(select Magv from inserted)
		open cur_search
		begin
		fetch next from cur_search into @Magv
		while @@fetch_status=0
			begin
			update GIAOVIEN SET somondaGD =somondaGD +1
				where Magv =@Magv 
		fetch next from cur_search into @Magv
			end
		end
		close cur_search
		deallocate cur_search
end
create trigger cau1_2 on PHANCONG
for delete
as 
	begin
		declare @Magv nchar(10)
		declare cur_search cursor for(select Magv from inserted)
		open cur_search
		begin
		fetch next from cur_search into @Magv
		while @@fetch_status=0
			begin
			update GIAOVIEN SET somondaGD =somondaGD -1
				where Magv =@Magv 
		fetch next from cur_search into @Magv
			end
		end
		close cur_search
		deallocate cur_search
end
-------------CAU 4
create trigger cau4 on KETQUA
for insert
as 
	begin
		declare @MaHV nchar(10),@Mamonhoc nchar(10),@Diem int
		declare cur_search cursor for(select MaHV,Mamonhoc,Diem from inserted where Diem>=5)
		open cur_search
		begin
		fetch next from cur_search into @MaHV,@Mamonhoc,@Diem
		while @@fetch_status=0
			begin
			declare @tinchi int
			set @tinchi =0
			set @tinchi =(select Sochi from MONHOC where Mamonhoc =@Mamonhoc)
			update HOCVIEN SET tinchi =tinchi +@tinchi
				where Mahocvien =@MaHV 
		fetch next from cur_search into @MaHV,@Mamonhoc,@Diem
			end
		end
		close cur_search
		deallocate cur_search
end
----------cau 5
create trigger cau5 on KETQUA
for insert
as 
	begin
		declare @MaHV nchar(10),@Diem int
		declare cur_search cursor for(select MaHV,AVG(Diem) from inserted where Diem>=5 GROUP BY MaHV)
		open cur_search
		begin
		fetch next from cur_search into @MaHV,@Diem
		while @@fetch_status=0
			begin
			update HOCVIEN SET DTB =DTB +@Diem
				where Mahocvien =@MaHV 
		fetch next from cur_search into @MaHV,@Mamonhoc,@Diem
			end
		end
		close cur_search
		deallocate cur_search
end
create trigger cau5_2 on KETQUA
for delete
as 
	begin
		declare @MaHV nchar(10),@Diem int
		declare cur_search cursor for(select MaHV,AVG(Diem) from deleted where Diem>=5 GROUP BY MaHV)
		open cur_search
		begin
		fetch next from cur_search into @MaHV,@Diem
		while @@fetch_status=0
			begin
			update HOCVIEN SET DTB =DTB -@Diem
				where Mahocvien =@MaHV 
		fetch next from cur_search into @MaHV,@Mamonhoc,@Diem
			end
		end
		close cur_search
		deallocate cur_search
end
create trigger cau5_3 on KETQUA
for update
as 
	begin
		declare @MaHV nchar(10),@Diem int,@temp int
		declare cur_search cursor for(select MaHV,AVG(Diem) from inserted where Diem>=5 GROUP BY MaHV)
		open cur_search
		begin
		fetch next from cur_search into @MaHV,@Diem
		while @@fetch_status=0
			begin
			set @temp=(select AVG(Diem) from deleted)
			update HOCVIEN SET DTB =DTB -@temp +@Diem
				where Mahocvien =@MaHV 
		fetch next from cur_search into @MaHV,@Mamonhoc,@Diem
			end
		end
		close cur_search
		deallocate cur_search
end
--------------cau 6
--Ketqua insert update delete
--		+		+		+
create trigger cau6_1 on KETQUA
for insert,update,delete
as 
	begin
		declare @MaHV nchar(10),@Diem int
		declare cur_search cursor for(select MaHV,AVG(Diem) from inserted where Diem>=5 GROUP BY MaHV)
		open cur_search
		begin
		fetch next from cur_search into @MaHV,@Diem
		while @@fetch_status=0
			begin
			IF(@Diem<5)
			begin
			update HOCVIEN set xeploai ='' where Mahocvien =@MaHV
			update HOCVIEN SET xeploai=N'Yếu' where Mahocvien =@MaHV 
			end
			if(@Diem=5)
			begin
			update HOCVIEN set xeploai ='' where Mahocvien =@MaHV
			update HOCVIEN SET xeploai=N'Trung bình' where Mahocvien =@MaHV
			end
			if(@Diem>5 and @Diem <=6.5)
			begin
			update HOCVIEN set xeploai ='' where Mahocvien =@MaHV
			update HOCVIEN SET xeploai=N'Trung bình khá' where Mahocvien =@MaHV
			end
			if(@Diem>6.5 and @Diem <8)
			begin
			update HOCVIEN set xeploai ='' where Mahocvien =@MaHV
			update HOCVIEN SET xeploai=N'Khá' where Mahocvien =@MaHV
			end
			if(@Diem>=8 and @Diem <9)
			begin
			update HOCVIEN set xeploai ='' where Mahocvien =@MaHV
			update HOCVIEN SET xeploai=N'Giỏi' where Mahocvien =@MaHV
			end
			if(@Diem>=9 and @Diem <=10)
			begin
			update HOCVIEN set xeploai ='' where Mahocvien =@MaHV
			update HOCVIEN SET xeploai=N'Xuất sắc' where Mahocvien =@MaHV
			end
		fetch next from cur_search into @MaHV,@Mamonhoc,@Diem
			end
		end
		close cur_search
		deallocate cur_search
select * from HOCVIEN
SELECT * FROM MONHOC
SELECT * FROM KETQUA 