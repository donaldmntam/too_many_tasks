import 'package:too_many_tasks/common/util_classes/channel/ports.dart';
import 'package:too_many_tasks/task_list/models/message.dart' as task_list;

typedef TaskListMasterPort = 
  MasterPort<task_list.MasterMessage, task_list.SlaveMessage>;
typedef TaskListSlavePort = 
  SlavePort<task_list.MasterMessage, task_list.SlaveMessage>;