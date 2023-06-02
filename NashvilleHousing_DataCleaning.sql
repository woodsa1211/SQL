/* 

Cleaning Data in SQL Queries 

*/ 

Select * 
FROM 
[Project Portfolio]..[NashvilleHousing]

--------------------------------------------------------------------------------------------------------------------------------------------
-- Standardize Date Format 

Select SaleDateConverted, CONVERT(Date,SaleDate)
FROM 
[Project Portfolio]..[NashvilleHousing]

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing 
ADD SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

----------------------------------------------------------------------------------------------------------------------------------------------------
--Populate Property Address Data 

Select *
FROM 
[Project Portfolio]..[NashvilleHousing]
--WHERE PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelId, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM 
[Project Portfolio]..[NashvilleHousing] a
JOIN [Project Portfolio]..[NashvilleHousing] b
on a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueId
WHERE a.PropertyAddress is null

Update a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM 
[Project Portfolio]..[NashvilleHousing] a
JOIN [Project Portfolio]..[NashvilleHousing] b
on a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueId
WHERE a.PropertyAddress is null

---------------------------------------------------------------------------------------------------------------------------------------------------
--Breaking out Property Address into Individual Columns (Address, City, State) 

Select PropertyAddress
From [Project Portfolio]..[NashvilleHousing]
--Where PropertyAddress is null
--order by ParcelID

Select PropertyAddress
From [Project Portfolio]..[NashvilleHousing]
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [Project Portfolio]..[NashvilleHousing]


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From [Project Portfolio]..[NashvilleHousing]



--Breaking out Owner Address into Individual Columns (Address, City, State) 

SELECT OwnerAddress
FROM 
[Project Portfolio]..[NashvilleHousing]

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3), 
PARSENAME(REPLACE(OwnerAddress, ',','.'),2), 
PARSENAME(REPLACE(OwnerAddress, ',','.'),1) 
FROM [Project Portfolio]..[NashvilleHousing]


ALTER TABLE NashvilleHousing 
ADD OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE NashvilleHousing 
ADD OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE NashvilleHousing 
ADD OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

SELECT *
FROM 
[Project Portfolio]..[NashvilleHousing]


-------------------------------------------------------------------------------------------------------------------------------------------------------
--Change Y and N in "Sold as Vacant' Field 

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM 
[Project Portfolio]..[NashvilleHousing]
Group by SoldAsVacant
Order by 2

Select SoldasVacant, 
CASE When SoldAsVacant = 'Y' THEN 'Yes' 
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM [Project Portfolio]..[NashvilleHousing]

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes' 
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END 


-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates 

WITH RowNumCTE as (
SELECT *, 
ROW_NUMBER() OVER ( 
PARTITION BY ParcelID, 
			 PropertyAddress, 
			 SalePrice, 
			 SaleDate, 
			 LegalReference
			 ORDER BY 
			 UniqueId
			 ) row_num

FROM [Project Portfolio]..[NashvilleHousing]
--ORDER BY ParcelID
) 
SELECT *
FROM RowNumCTE
WHERE row_num > 1 
--ORDER BY PropertyAddress

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Delete Unused Columns 

SELECT * 
FROM [Project Portfolio]..[NashvilleHousing]

ALTER TABLE [Project Portfolio]..[NashvilleHousing] 
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress 

ALTER TABLE [Project Portfolio]..[NashvilleHousing] 
DROP COLUMN SaleDate