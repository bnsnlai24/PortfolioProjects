select*
from housingproject..NashvilleHousing

-- standardize date format

select SaleDateConverted, convert(date, saledate)
from housingproject..NashvilleHousing

alter table housingproject..NashvilleHousing
add SaleDateConverted date;

update housingproject..NashvilleHousing
set SaleDateConverted = convert(date, saledate)

-- populate property address date

select*
from housingproject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull (a.propertyaddress, b.PropertyAddress)
from housingproject..NashvilleHousing a
join housingproject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = isnull (a.propertyaddress, b.PropertyAddress)
from housingproject..NashvilleHousing a
join housingproject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null

-- breaking out address into individual columns (address, city, date)

select*
from housingproject..NashvilleHousing

alter table housingproject..NashvilleHousing
add PropertySplitAddress Nvarchar(255);

Update housingproject..NashvilleHousing
set PropertySplitAddress = PARSENAME (replace(propertyaddress, ',', '.'),2)

alter table housingproject..NashvilleHousing
add PropertySplitCity Nvarchar(255);

Update housingproject..NashvilleHousing
set PropertySplitCity = PARSENAME (replace(propertyaddress, ',', '.'),1)



-- breaking out owneraddress

select*
from housingproject..NashvilleHousing

select PARSENAME (replace(owneraddress,',', '.'), 3),
PARSENAME (replace(owneraddress,',', '.'), 2),
PARSENAME (replace(owneraddress,',', '.'), 1)
from housingproject..NashvilleHousing

alter table housingproject..NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

Update housingproject..NashvilleHousing
set OwnerSplitAddress = PARSENAME (replace(owneraddress,',', '.'), 3)

alter table housingproject..NashvilleHousing
add OwnerSplitCity Nvarchar(255);

Update housingproject..NashvilleHousing
set OwnerSplitCity = PARSENAME (replace(owneraddress,',', '.'), 2)

alter table housingproject..NashvilleHousing
add OwnerSplitState Nvarchar(255);

Update housingproject..NashvilleHousing
set OwnerSplitState = PARSENAME (replace(owneraddress,',', '.'), 1)

-- change y and n to yes and no in "sold as vacant" field

select distinct(SoldAsVacant), count(soldasvacant)
from housingproject..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from housingproject..NashvilleHousing

update housingproject..NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end

-- delete unused columns

select*
from housingproject..NashvilleHousing

alter table housingproject..NashvilleHousing
drop columnm, owneraddress, taxdistrict, propertyaddress



