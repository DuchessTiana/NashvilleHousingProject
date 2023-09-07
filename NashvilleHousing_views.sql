select *
from PortfolioProject.dbo.NashVilleHousing

select SaleDate, CONVERT(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing


select SaleDateConverted, CONVERT(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)



select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is Null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
   on a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
   on a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


select  PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is Null
--order by ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity =  SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))



select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing


select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
from PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2



select SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'YES'
       when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
from PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'YES'
       when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END


WITH RowNumCTE AS(
select *,
   ROW_NUMBER() OVER (
   PARTITION BY ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				   UniqueID
				   ) row_num

from PortfolioProject.dbo.NashvilleHousing
)
SELECT *
from RowNumCTE
where row_num > 1
order by PropertyAddress



select *
from PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress,SaleDate


CREATE VIEW NashvilleHousing_views AS
SELECT UniqueID,ParcelID,SalePrice,LegalReference,SoldAsVacant,OwnerName,SaleDateConverted,PropertySplitAddress,PropertySplitCity,
       OwnerSplitAddress,OwnerSplitCity,OwnerSplitState
FROM PortfolioProject.dbo.NashvilleHousing
WHERE OwnerSplitAddress is not Null;


SELECT *
FROM NashvilleHousing_views





