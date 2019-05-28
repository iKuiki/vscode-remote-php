#-----------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See LICENSE in the project root for license information.
#-----------------------------------------------------------------------------------------

FROM php:7-cli

# Install xdebug
RUN yes | pecl install xdebug \
	&& echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
	&& echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
	&& echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive

# Install git, process tools, lsb-release (common in install instructions for CLIs), zsh, locales, git-flow vim
RUN apt-get update && apt-get -y install --no-install-recommends apt-utils 2>&1 \
	&& apt-get -y install git procps lsb-release zsh less locales git-flow vim \
	# Clean up
	&& apt-get autoremove -y \
	&& apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/* \
	# Add zh_CN locale support
	&& echo 'zh_CN.UTF-8 UTF-8' >> /etc/locale.gen \
	&& locale-gen

# Clean up
ENV DEBIAN_FRONTEND=dialog

# Set time zone
ENV TZ=Asia/Shanghai

# Install Oh-My-Zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
	&& php composer-setup.php \
	&& php -r "unlink('composer-setup.php');" \
	&& mv composer.phar /usr/local/bin/composer

# 将composer设置为国内源
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com

# Set the default shell to zsh rather than sh
ENV SHELL /bin/zsh
