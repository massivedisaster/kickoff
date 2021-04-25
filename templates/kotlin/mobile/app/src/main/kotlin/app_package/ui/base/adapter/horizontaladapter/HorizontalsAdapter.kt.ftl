package ${configs.packageName}.ui.base.adapter.horizontaladapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.databinding.ViewDataBinding
import androidx.recyclerview.widget.AsyncListDiffer
import androidx.recyclerview.widget.RecyclerView
import ${configs.packageName}.R
import ${configs.packageName}.data.common.NetworkState
import ${configs.packageName}.network.models.response.CategoryModel
import ${configs.packageName}.ui.base.adapter.*
import kotlin.reflect.KClass

class HorizontalsAdapter<T : Any, VB : ViewDataBinding, VH : BaseViewHolder<T, VB>, C : BaseDiffCallback<T>, A : BaseAdapter<T, VB, VH, C>>(
        private val adapterClass: KClass<A>,
        private val genericCardClickListener: (ClickType, GenericStateCard) -> Unit = { _, _ -> },
        private val clickListener: (obj: Any, type: Enum<*>) -> Unit = { _, _ -> },
        private val genericCardClickListenerInternal: (ClickType, GenericStateCard) -> Unit = { _, _ -> },
        private val clickListenerInternal: (adapter: RecyclerView.Adapter<RecyclerView.ViewHolder>, index: Int, obj: Any, type: Enum<*>) -> Unit = { _, _, _, _ -> },
        private val genericCardErrorListener: (emptyViews: GenericStateCardErrorViews, errorViews: GenericStateCardErrorViews, isFullHeight: Boolean, state: NetworkState?) -> Unit = { _, _, _, _-> },
        private val onNewList: (previousList: List<Any>, currentList: List<Any>) -> Unit = { _, _ -> }
) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {

    private val viewPool = RecyclerView.RecycledViewPool()

    private val GENERIC_TYPE = 0
    private val CATEGORY_TYPE = 1

    private val adapterDiff = HorizontalsDiffCallback()
    private val mDiffer = AsyncListDiffer(this, adapterDiff)

    private val adaptersList: MutableMap<Long, BaseAdapter<T, VB, VH, C>> = mutableMapOf()

    private fun innerAdapter() = adapterClass.constructors.first().call(genericCardClickListenerInternal, clickListenerInternal, genericCardErrorListener, onNewList)

    companion object {
        private const val genericDefaultKey = -1L

        fun generateInitialNetworkStateBasedList(networkState: NetworkState): LinkedHashMap<Long, Triple<Any?, List<Any>?, NetworkState>?> {
            val map = linkedMapOf<Long, Triple<Any?, List<Any>?, NetworkState>?>()
            return when {
                networkState.isLoading -> {
                    map[genericDefaultKey] = Triple(genericDefaultKey, GenericStateCard.getLoadingEmptyList() as List<Any>?, networkState)
                    map
                }
                networkState.isFailed -> {
                    map[genericDefaultKey] = Triple(genericDefaultKey, GenericStateCard.getErrorEmptyList(state = networkState) as List<Any>?, networkState)
                    map
                }
                networkState.isEmpty -> {
                    map[genericDefaultKey] = Triple(genericDefaultKey, GenericStateCard.getEmptyContentEmptyList() as List<Any>?, networkState)
                    map
                }
                else -> throw UnsupportedOperationException("You should use setList in case of Success")
            }
        }

        fun getState(adaptersList: LinkedHashMap<Long, Triple<Any?, List<Any>?, NetworkState>?>): NetworkState {
            return if (adaptersList.containsKey(genericDefaultKey)) {
                when {
                    (adaptersList[genericDefaultKey]?.second?.get(0) as GenericStateCard).showingLoading -> NetworkState.LOADING
                    (adaptersList[genericDefaultKey]?.second?.get(0) as GenericStateCard).showingError -> NetworkState.error(null)
                    (adaptersList[genericDefaultKey]?.second?.get(0) as GenericStateCard).showingEmptyContent -> NetworkState.EMPTY
                    else -> NetworkState.SUCCESS
                }
            } else {
                NetworkState.SUCCESS
            }
        }
    }

    fun setList(list: LinkedHashMap<Long, Triple<Any?, List<Any>?, NetworkState>?>) {
        if (list.containsKey(genericDefaultKey)) {
            if (list.size > 1) {
                throw UnsupportedOperationException("Your list contains the used generic default key for states\n" +
                        "Consider using the static function to generate you state list and guarantee that your content data does not contains the default key -1L")
            }
            adaptersList.clear()
            mDiffer.submitList(list[genericDefaultKey]?.second)
        } else {
            list.keys.forEach {
                if (!adaptersList.containsKey(it)) {
                    adaptersList[it] = innerAdapter()
                }
            }
            adaptersList.keys.filter { !list.containsKey(it) }.toList().forEach {
                adaptersList.remove(it)
            }

            val finalList: List<Any> = list.map { Pair(it.value?.first, it.value?.second) }.toList()
            mDiffer.submitList(finalList) //creating a new list avoids problems
            mDiffer.addListListener(object : AsyncListDiffer.ListListener<Any> {
                override fun onCurrentListChanged(previousList: MutableList<Any>, currentList: MutableList<Any>) {
                    currentList.forEach {
                        if (it is Pair<*, *>) {
                            adaptersList[(it.first as CategoryModel).id]?.setList(it.second as MutableList<Any>)
                        }
                    }
                    mDiffer.removeListListener(this)
                }
            })
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int) = when (viewType) {
        CATEGORY_TYPE -> HorizontalsViewHolder(LayoutInflater.from(parent.context).inflate(R.layout.item_category, parent, false), viewPool)
        else -> GenericStateCardFullHeightViewHolder(LayoutInflater.from(parent.context).inflate(R.layout.item_generic_view_state_full_height, parent, false))
    }

    override fun getItemViewType(position: Int) = if ((mDiffer.currentList[position] is Pair<*, *>)) { CATEGORY_TYPE } else { GENERIC_TYPE }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        when (holder.itemViewType) {
            CATEGORY_TYPE -> {
                val category = mDiffer.currentList[position] as Pair<*, *>
                (holder as HorizontalsViewHolder).bind(category.first as CategoryModel, clickListener, adaptersList[(category.first as CategoryModel).id])
            }
            GENERIC_TYPE -> {
                val genericStateCard = mDiffer.currentList[position] as GenericStateCard
                (holder as GenericStateCardFullHeightViewHolder).bind(holder, genericStateCard, genericCardClickListener, genericCardErrorListener)
            }
        }
    }

    override fun getItemCount() = mDiffer.currentList.size

}