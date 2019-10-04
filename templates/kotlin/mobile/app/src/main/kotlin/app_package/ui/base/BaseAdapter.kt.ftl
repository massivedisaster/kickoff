package ${configs.packageName}.ui.base

import androidx.recyclerview.widget.RecyclerView

abstract class BaseAdapter<T, VH : RecyclerView.ViewHolder> :  RecyclerView.Adapter<VH> {

    protected val data = ArrayList<T>()

    constructor(data: List<T>) {
        this.data.addAll(data)
    }

    constructor(): this(ArrayList<T>())

    fun appendData(data: Collection<T>?) {
        this.data.addAll(data ?: return)
        notifyDataSetChanged()
    }

    override fun getItemCount(): Int {
        return data.size
    }

    fun setData(data: Collection<T>?) {
        this.data.clear()
        this.data.addAll(data?:return)
        notifyDataSetChanged()
    }

    fun add(item: T, position: Int) {
        data[position] = item
        notifyItemInserted(position)
    }

    fun getItem(position: Int): T? {
        if (position < 0 || position >= data.size)
            return null
        return data[position]
    }

    fun getItemPosition(item: T): Int {
        return data.indexOf(item)
    }

    fun remove(position: Int) {
        data.removeAt(position)
        notifyItemRemoved(position)
    }

    fun remove(item: T) {
        data.remove(item)
        notifyItemRemoved(getItemPosition(item))
    }

    fun reset() {
        data.clear()
        notifyDataSetChanged()
    }

    fun move(oldPosition: Int, newPosition: Int) {
        swap(data, oldPosition, newPosition)
    }

    private fun swap(data: ArrayList<T>, oldPosition: Int, newPosition: Int) {
        val item = data.removeAt(oldPosition)
        add(item, newPosition)
    }
}