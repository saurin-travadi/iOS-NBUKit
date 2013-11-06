#!/bin/sh
set -e

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
install_resource "GPUImage/framework/Resources/lookup.png"
install_resource "GPUImage/framework/Resources/lookup_amatorka.png"
install_resource "GPUImage/framework/Resources/lookup_miss_etikate.png"
install_resource "GPUImage/framework/Resources/lookup_soft_elegance_1.png"
install_resource "GPUImage/framework/Resources/lookup_soft_elegance_2.png"
install_resource "NBUCore/Source/Dashboard/NBUDashboard.xib"
install_resource "NBUCore/Source/Dashboard/NBULogAdjustLevelsCell.xib"
install_resource "../../NBUKitResources.bundle"
install_resource "../../Source/Assets/NBUAssetsGroupView.xib"
install_resource "../../Source/Assets/NBUAssetsGroupViewController.xib"
install_resource "../../Source/Assets/NBUAssetsLibraryViewController.xib"
install_resource "../../Source/Assets/NBUAssetThumbnailView.xib"
install_resource "../../Source/Image/NBUCropViewController.xib"
install_resource "../../Source/Image/NBUEditImageViewController.xib"
install_resource "../../Source/Image/NBUFilterThumbnailView.xib"
install_resource "../../Source/Image/NBUPresetFilterViewController.xib"
install_resource "../../Source/Picker/NBUCameraViewController.xib"
install_resource "../../Source/Picker/NBUImagePickerController.xib"
install_resource "../../Source/UI/NBUBadgeView.xib"
install_resource "../../Source/UI/NBUGalleryThumbnailView.xib"
install_resource "../../Source/UI/NBUGalleryView.xib"
install_resource "../../Source/UI/NBUGalleryViewController.xib"
install_resource "../../Source/UI/NBURefreshControl.xib"
install_resource "../../Source/UI/NBUSplashView.xib"
install_resource "../../Source/UI/NBUTabBarControllerSample.xib"

rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]]; then
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"
