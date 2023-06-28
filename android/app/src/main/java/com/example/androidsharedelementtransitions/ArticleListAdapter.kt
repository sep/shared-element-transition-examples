package com.example.androidsharedelementtransitions

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView

class ArticleListAdapter(
    private val articles: Array<Article>,
    private val onSelect: (article: Article, textView: TextView, imageView: ImageView) -> Unit,
) :
    RecyclerView.Adapter<ArticleListAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val textView: TextView
        val imageView: ImageView

        init {
            textView = view.findViewById(R.id.article_title)
            imageView = view.findViewById(R.id.article_image)
            view.outlineProvider = RoundedCornersOutlineProvider()
            view.clipToOutline = true
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.article_preview, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.itemView.setOnClickListener {
            onSelect(articles[position], holder.textView, holder.imageView)
        }

        val article = articles[position]
        holder.textView.text = article.title
        holder.textView.transitionName = article.titleId
        holder.imageView.transitionName = article.imageId
    }

    override fun getItemCount() = articles.size
}