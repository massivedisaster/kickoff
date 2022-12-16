package ${configs.packageName}.di.component

import dagger.Component
import ${configs.packageName}.di.module.ApiModule
import ${configs.packageName}.di.module.DatabaseModule
import ${configs.packageName}.di.module.RepositoryModule
import ${configs.packageName}.di.module.UtilsModule

@Component(modules = [
    ApiModule::class,
    DatabaseModule::class,
    RepositoryModule::class,
    UtilsModule::class
])
abstract class AppComponent