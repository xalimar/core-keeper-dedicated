###########################################################
# Dockerfile that builds a Core Keeper Gameserver
###########################################################
FROM cm2network/steamcmd:root

LABEL maintainer="xalimar@gmail.com"

ENV STEAMAPPID 1963720 
ENV STEAMAPP core-keeper-server
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"
ENV DLURL="https://raw.githubusercontent.com/xalimar/core-keeper-dedicated"

ENV APPSAVEDIR="${HOMEDIR}/.config/unity3d/Pugstorm/Core Keeper"

RUN set -x \
	&& apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        wget \
        xvfb \
    && mkdir "${STEAMAPPDIR}" \
    && mkdir -p "${APPSAVEDIR}" \
    && wget --max-redirect=30 "${DLURL}/main/etc/entry.sh" -O "${HOMEDIR}/entry.sh" \
    && chmod +x "${HOMEDIR}/entry.sh" \
    && chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" "${HOMEDIR}/.config" \
	&& rm -rf /var/lib/apt/lists/*

USER ${USER}

WORKDIR ${HOMEDIR}

STOPSIGNAL SIGINT

CMD ["bash", "entry.sh"]

# Expose ports
EXPOSE 27015/udp \
    27016/udp
