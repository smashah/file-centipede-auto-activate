ARG BASE_IMAGE=jlesage/file-centipede:26.03.1
FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.source="https://github.com/smashah/file-centipede-auto-activate" \
      org.opencontainers.image.description="Automatically enters File Centipede's current public trial activation code"

# curl fetches the publisher-provided code and xdotool enters it through the
# application's normal activation dialog.
RUN add-pkg curl xdotool

COPY rootfs/ /
