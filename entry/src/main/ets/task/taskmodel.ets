import relationalStore from '@ohos.data.relationalStore';
import valueBuckets from '../utils/valueBuckets';
import common from '@ohos.app.ability.common';

// 定义数据库记录类型
interface TaskRecord {
  ID: number;
  NAME: string;
  DEFINE: string;
}

class TaskModel {
  private rdbStore: relationalStore.RdbStore | null = null;
  private TableName: string = 'Task';

  // 初始化数据库
  initDb(context: common.UIAbilityContext): void {
    // 1. rdb配置
    const config: relationalStore.StoreConfig = {
      name: 'TASK.db',
      securityLevel: relationalStore.SecurityLevel.S1
    };

    // 2. 初始化sql语句
    const sql = `CREATE TABLE IF NOT EXISTS TASK(
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      NAME TEXT NOT NULL,
      DEFINE TEXT NOT NULL
    )`;

    // 获取rdb
    relationalStore.getRdbStore(context, config, (err: Error, rdbStore: relationalStore.RdbStore) => {
      if (err) {
        console.error('testTag', '获取rdbstore失败！' + err.message);
        return;
      }

      // 执行Sql
      try {
        rdbStore.executeSql(sql);
        console.log('testTag', '获取数据库成功');
      } catch (e) {
        console.error('testTag', '执行SQL失败：' + e);
        return;
      }

      // 保存rdbstore
      this.rdbStore = rdbStore;

      // 延迟添加数据
      setTimeout(() => {
        this.addData();
      }, 5000);
    });
  }

  // 查询数据库
  async getData(name: string): Promise<TaskRecord | null> {
    if (!this.rdbStore) {
      console.error('testTag', 'rdbStore未初始化');
      return null;
    }

    // 1. 构建查询条件
    let predicates = new relationalStore.RdbPredicates(this.TableName);
    predicates.equalTo("NAME", name);

    try {
      let resultSet = await this.rdbStore.query(predicates, ["ID", "NAME", "DEFINE"]);

      console.info(`resultSet columnNames: ${resultSet.columnNames}`);
      console.info(`resultSet columnCount: ${resultSet.columnCount}`);

      const rowCount = resultSet.rowCount;

      if (rowCount === 0) {
        resultSet.close();
        return null;
      }

      resultSet.goToFirstRow();
      let record: TaskRecord = {
        ID: resultSet.getDouble(resultSet.getColumnIndex('ID')),
        NAME: resultSet.getString(resultSet.getColumnIndex('NAME')),
        DEFINE: resultSet.getString(resultSet.getColumnIndex('DEFINE'))
      };

      resultSet.close();
      console.info('查询结果: ' + JSON.stringify(record));

      return record;
    } catch (err) {
      console.error("Query failed, err: " + err);
      return null;
    }
  }

  // 添加数据
  addData(): void {
    if (!this.rdbStore) {
      console.error('testTag', 'rdbStore未初始化');
      return;
    }

    let predicates = new relationalStore.RdbPredicates(this.TableName);
    predicates.equalTo("ID", 15);

    this.rdbStore.query(predicates, ["ID", "NAME", "DEFINE"])
      .then((resultSet) => {
        if (resultSet.rowCount <= 0) {
          console.log('开始插入！');

          if (this.rdbStore) {
            this.rdbStore.batchInsert(this.TableName, valueBuckets)
              .then((insertNum) => {
                console.log("batchInsert is successful, the number of values that were inserted = " + insertNum);
              })
              .catch((err: Error) => {
                console.error("batchInsert is failed, err = " + err.message);
              });
          }
        } else {
          console.log('已有数据，无需再次插入！');
        }
        resultSet.close();
      })
      .catch((err: Error) => {
        console.error("查询失败: " + err.message);
      });
  }
}

let taskmodel = new TaskModel();

export default taskmodel as TaskModel;