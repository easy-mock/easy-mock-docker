### docker-compose 文件内容
```
version: "3.3"
services:
  mongodb:
    image: mongo:3.4
    volumes:
      - type: bind
        source: ./data/db # 数据库文件存放地址，根据需要修改为本地地址
        target: /data/db
  redis:
    image: redis:4.0.6
    command: redis-server --appendonly yes
    volumes:
      - type: bind
        source: ./data/redis # redis 数据文件存放地址，根据需要修改为本地地址
        target: /data
  web:
    image: easymock/easymock:1.6.0
    command: /bin/bash -c "npm start"
    links:
      - mongodb:mongodb
    ports:
      - 7300:7300
    volumes:
      - type: bind 
        source: ./logs # 日志地址，根据需要修改为本地地址
        target: /home/easy-mock/easy-mock/logs
      - type: bind
        source: ./production.json # 配置地址，请使用本地配置地址替换
        target: /home/easy-mock/easy-mock/config/production.json
```

### 使用方式
1. 安装 docker-compose
2. 新建文件 `docker-compose.yml` 并将上面 docker-compose 文件内容复制进入 `docker-compose.yml`，然后将内容中注释位置替换为自己需要的本地地址即可。主要有三个需要替换的地方，数据库文件存储位置，日志文件存储位置，自定义配置文件本地地址。
3. 启动：`docker-compose up -d`

自定义配置参考 [easymock readme](https://github.com/easy-mock/easy-mock) 中的配置小节。

**注意**
* **使用容器方式运行不需要指定 `db` 和 `redis` 参数**
* **production.json 配置中注意以下问题**

```
{
  "port": 7300,
  "host": "0.0.0.0",
  "pageSize": 30,
  "proxy": false,
  "db": "mongodb://mongodb/easy-mock" # host 请务必替换为mongodb, 而非 localhost
  ......
  ......
}
```
