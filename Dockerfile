FROM mcr.microsoft.com/playwright:v1.57.0

# Set timezone and disable interactive prompts
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    DISPLAY=:99

# Install xvfb-run and VNC server with all dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    xvfb \
    x11-utils \
    x11-xserver-utils \
    openbox \
    x11vnc \
    novnc \
    websockify \
    supervisor \
    dbus \
    dbus-x11 \
    xterm \
    curl \
    wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create supervisor configuration for VNC and noVNC
RUN mkdir -p /etc/supervisor/conf.d

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose ports
EXPOSE 99:0
EXPOSE 5900
EXPOSE 6080

# Set entrypoint to use supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
