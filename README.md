# centos_apache_php
apache24+php5.6 in centos6
#Dockerfile 文件有很多需要优化的地方
#目标:
#更快的构建速度
#更小的Docker镜像大小
#更少的Docker镜像层
#充分利用镜像缓存
#增加Dockerfile可读性
#让Docker容器使用起来更简单

#总结

#编写.dockerignore文件
#容器只运行单个应用
#将多个RUN指令合并为一个
#基础镜像的标签不要用latest
#每个RUN指令后删除多余文件
#选择合适的基础镜像(alpine版本最好)
#设置WORKDIR和CMD
#使用ENTRYPOINT (可选)
#在entrypoint脚本中使用exec
#COPY与ADD优先使用前者

#合理调整COPY与RUN的顺序
#设置默认的环境变量，映射端口和数据卷
#使用LABEL设置镜像元数据
#添加HEALTHCHECK