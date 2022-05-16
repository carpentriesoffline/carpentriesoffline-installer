from ubuntu:20.04 

#      - name: Download base image
#        if: steps.cache-image.outputs.cache-hit != 'true'
#        run: |
#          wget --quiet ${{ env.IMG_URL }}
#          echo "${{ env.PI_ZIP_CHECKSUM }} ${{ env.PI_ZIP }}" | sha256sum -c
#          unzip ${{ env.PI_ZIP }}
#          mv ${{ env.PI_IMG }} ${{ env.PI_IMG }}.orig
#      - name: Create clean base image
#        run: cp ${{ env.PI_IMG }}.orig ${{ env.PI_IMG }}
#      - name: Install packages
#        run: sudo apt-get install -y qemu-system-arm qemu-efi expect

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata unzip git wget qemu-system-arm qemu-efi expect && \
    wget --quiet https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-01-12/2021-01-11-raspios-buster-armhf-lite.zip && \
    echo "d49d6fab1b8e533f7efc40416e98ec16019b9c034bc89c59b83d0921c2aefeef 2021-01-11-raspios-buster-armhf-lite.zip" | sha256sum -c && \
    unzip 2021-01-11-raspios-buster-armhf-lite.zip && \
    mv 2021-01-11-raspios-buster-armhf-lite.zip 2021-01-11-raspios-buster-armhf-lite.zip.orig

#     - name: Checkout qemu pi kernels
#        uses: actions/checkout@v2
#        with:
#          repository: dhruvvyas90/qemu-rpi-kernel
#          path: qemu-rpi-kernel


RUN mkdir -p /checkout/test && \
    cd /checkout && \
    git clone https://github.com/dhruvvyas90/qemu-rpi-kernel

COPY test /checkout/test


#      - name: Resize image
#        run: |
#          cp ${{env.PI_IMG}} base.img
#          qemu-img resize -f raw ${{ env.PI_IMG }} +4G
#          chmod +x ./checkout/test/resize_pi.exp
#          ./checkout/test/resize_pi.exp ${{env.PI_IMG}}



RUN cp /2021-01-11-raspios-buster-armhf-lite.img /checkout/boot.img && \
    chmod +x /checkout/test/resize_pi.exp && \
    cd /checkout && \
    qemu-img resize -f raw /2021-01-11-raspios-buster-armhf-lite.img +4G

#let the system boot up once to resize the partition
RUN cd /checkout && \ 
    cat /checkout/test/resize_pi.exp

#   /checkout/test/resize_pi.exp /2021-01-11-raspios-buster-armhf-lite.img


#install carpenpi
RUN cd /checkout && \
   /checkout/test/install_carpenpi.exp /2021-01-11-raspios-buster-armhf-lite.img


#      - name: Run QEMU & install CarpenPi
#        run: |
#          ls -l ./checkout/test/
#          # Don't do it! It's not ready!
#          #./checkout/test/install_carpenpi.exp ${{env.PI_IMG}}
#      - name: Shrink final image
#        run: |
#          wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh
#          chmod a+x pishrink.sh
#          sudo ./pishrink.sh ${{env.PI_IMG}} ${{env.OUTPUT_IMG}}
#          zip ${{env.OUTPUT_ZIP}} ${{env.OUTPUT_IMG}}
#      - name: Upload image as release
#        id: upload-release-asset 
#        uses: actions/upload-release-asset@v1
#        env:
#          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
#        with:
#          upload_url: ${{ github.event.release.upload_url }}
#          asset_path: ${{env.OUTPUT_ZIP}}
#          asset_name: ${{env.OUTPUT_ZIP}}
#          asset_content_type: application/zip
