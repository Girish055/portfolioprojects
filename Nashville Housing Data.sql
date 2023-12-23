

SELECT *
FROM [Portfolio Project].[dbo].[Nashville housing data$]

--standardizing date format

select SaleDate, convert(date, SaleDate)
from  [Portfolio Project].[dbo].[Nashville housing data$] 

update [Portfolio Project].[dbo].[Nashville housing data$]
set SaleDate = convert(date, SaleDate)

Alter Table [Portfolio Project].[dbo].[Nashville housing data$]
add SaleDateConverted Date

update  [Portfolio Project].[dbo].[Nashville housing data$]
set SaleDateConverted = convert(date, SaleDate)

select SaleDateConverted
from [Portfolio Project].[dbo].[Nashville housing data$] 

--populate property address data

select *
from [Portfolio Project].[dbo].[Nashville housing data$] 
where PropertyAddress is null
order by parcelID desc

-- Where propertyaddress is null

select a.parcelID, b.parcelID, a.PropertyAddress, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Project].[dbo].[Nashville housing data$] a
join [Portfolio Project].[dbo].[Nashville housing data$] b
 on a.ParcelID = b.ParcelID
 and a.UniqueID <> b.UniqueID
 where a.PropertyAddress is null


update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Project].[dbo].[Nashville housing data$] a
join [Portfolio Project].[dbo].[Nashville housing data$] b
 on a.ParcelID = b.ParcelID
 and a.UniqueID <> b.UniqueID
 where a.PropertyAddress is null


 -- converting address into individual columns

 select PropertyAddress 
 from [Portfolio Project].[dbo].[Nashville housing data$]

 --CHARINDEX searches for a specific value. searching for (,), in the column (PropertyAddress), and go back one space (-1)
 -- this will give us the column without the comma(,)

 select
 substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
  substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as Address
  from [Portfolio Project].[dbo].[Nashville housing data$]

--Editing the table

  Alter Table [Portfolio Project].[dbo].[Nashville housing data$]
add PropertySplitAddress Nvarchar(255)

update  [Portfolio Project].[dbo].[Nashville housing data$]
 set PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table [Portfolio Project].[dbo].[Nashville housing data$]
add PropertyCityAddress Nvarchar(255)

update  [Portfolio Project].[dbo].[Nashville housing data$]
set PropertyCityAddress = substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) 

select *
from [Portfolio Project].[dbo].[Nashville housing data$]

--parsename looks for periods(.) and it works backwords

 select 
  parsename (replace(OwnerAddress,',', '.'),3),
  parsename (replace(OwnerAddress,',', '.'),2),
  parsename (replace(OwnerAddress,',', '.'),1)
from [Portfolio Project].[dbo].[Nashville housing data$]

Alter Table [Portfolio Project].[dbo].[Nashville housing data$]
add OwnerSplitAddress Nvarchar(255)

update  [Portfolio Project].[dbo].[Nashville housing data$]
set OwnerSplitAddress = parsename (replace(OwnerAddress,',', '.'),3)

Alter Table [Portfolio Project].[dbo].[Nashville housing data$]
add OwnerSplitCity Nvarchar(255)

update  [Portfolio Project].[dbo].[Nashville housing data$]
set OwnerSplitCity =    parsename (replace(OwnerAddress,',', '.'),2)


Alter Table [Portfolio Project].[dbo].[Nashville housing data$]
add OwnerSplitState Nvarchar(255)

update  [Portfolio Project].[dbo].[Nashville housing data$]
set OwnerSplitState = parsename (replace(OwnerAddress,',', '.'),1)

--change Y and N in SoldAsVacant column to yes and no

select distinct (SoldAsVacant), count(SoldAsVacant) s
from [Portfolio Project].[dbo].[Nashville housing data$]
Group by SoldAsVacant
order by 2

 select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
     when SoldASVacant = 'N' then 'No'
	 else SoldAsVacant
	 End
from [Portfolio Project].[dbo].[Nashville housing data$]

update [Portfolio Project].[dbo].[Nashville housing data$]
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
     when SoldASVacant = 'N' then 'No'
	 else SoldAsVacant
	 End


--remove duplicates 
--rownumcte is an expression that stores the values of the query
-- row_number will assign a unique integer to each row
-- The PARTITION BY clause is used to divide the result set into partitions to which the ROW_NUMBER() function is applied 

with RowNumCTE as(
select * ,
  row_number() over (
  partition by ParcelID, propertyaddress, 
               SalePrice, SaleDate, LegalReference
			   order by UniqueID ) row_num
from [Portfolio Project].[dbo].[Nashville housing data$]
--order by parcelID
)
select *
from RowNumCTE
where row_num>1
order by PropertyAddress

--deleting the rows

with RowNumCTE as(
select * ,
  row_number() over (
  partition by ParcelID, propertyaddress, 
               SalePrice, SaleDate, LegalReference
			   order by UniqueID ) row_num
from [Portfolio Project].[dbo].[Nashville housing data$]
--order by parcelID
)
delete
from RowNumCTE
where row_num>1
--order by PropertyAddress

--deleting unused columns 

select *
from [Portfolio Project].[dbo].[Nashville housing data$]
alter table [Portfolio Project].[dbo].[Nashville housing data$]
drop column TaxDistrict, OwnerAddress