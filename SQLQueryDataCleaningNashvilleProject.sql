/*
Cleaning Data in SQL Queries
*/

SELECT * 
FROM
dbo.NashvilleHousing

--Standardize Date Format

SELECT SaleDate, CONVERT (Date, SaleDate)
FROM
dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT (Date, SaleDate)

--Populate Property Address Data

SELECT *
FROM 
dbo.NashvilleHousing
WHERE PropertyAddress is NULL
Order By parcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM 
dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b 
	ON a.ParcelID = b.ParcelID
	AND
	a.uniqueid <> b.uniqueid
Where a.PropertyAddress is NULL

UPDATE a 
SET
PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM 
dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b 
	ON a.ParcelID = b.ParcelID
	AND
	a.uniqueid <> b.uniqueid
Where a.PropertyAddress is NULL


--Breaking Out Address Into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM 
dbo.NashvilleHousing

SELECT
SUBSTRING (propertyaddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING (propertyaddress,CHARINDEX(',',PropertyAddress)+1,LEN(propertyaddress)) as Street
FROM
dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING (propertyaddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity NVARCHAR(255)
UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING (propertyaddress, CHARINDEX(',',PropertyAddress)+1 , LEN(propertyaddress))



Select 
Parsename(Replace(owneraddress,',', '.'),3),
Parsename(Replace(owneraddress,',', '.'),2),
Parsename(Replace(owneraddress,',', '.'),1)
From NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = Parsename(Replace(owneraddress,',', '.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitCity = Parsename(Replace(owneraddress,',', '.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitState = Parsename(Replace(owneraddress,',', '.'),1)


--Change Y and N to Yes and No in "Sold as Vacant" Field

Select Distinct(Soldasvacant)
From NashvilleHousing

Select Soldasvacant,
Case when Soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
Else SoldAsVacant
END
From NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = 
Case when Soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
Else SoldAsVacant
END 

--Remove Duplicates

WITH ROWNUMCTE AS(
Select *,
Row_Number() Over (
Partition BY 
			ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY 
				UniqueID ) row_num
From NashvilleHousing)
DELETE from ROWNUMCTE
Where row_num > 1

--Delete Unused Columns 

ALTER TABLE dbo.nashvillehousing
Drop Column
		Owneraddress,
		taxdistrict,
		Propertyaddress,
		Saledate

Select *
From dbo.NashvilleHousing
