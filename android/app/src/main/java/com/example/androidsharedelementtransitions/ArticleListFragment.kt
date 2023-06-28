package com.example.androidsharedelementtransitions

import android.os.Bundle
import android.transition.TransitionInflater
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
import androidx.core.view.doOnPreDraw
import androidx.fragment.app.Fragment
import androidx.navigation.NavOptions
import androidx.navigation.NavOptionsBuilder
import androidx.navigation.findNavController
import androidx.navigation.fragment.FragmentNavigatorExtras
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.androidsharedelementtransitions.databinding.FragmentArticleListBinding

val MOCK_ARTICLES: Array<Article> = arrayOf(
    Article("How Now Brown Cow? Nursery Rhymes in the Age of Artificial Intelligence"),
    Article("Breaking News: AI Invents the Ultimate Dad Jokes"),
    Article("AI Travel Guide: Navigating the Virtual World on a Budget"),
    Article("AI Confidential: Unveiling the Secret Lives of Chatbots"),
    Article("Hitchhiker's Guide to the AI-Pocalypse: How to Outsmart Rogue Robots"),
    Article("The AI Olympics: Digital Athletes Compete for Gold"),
)

class ArticleListFragment : Fragment() {

    private var _binding: FragmentArticleListBinding? = null
    private val binding get() = _binding!!

    private lateinit var articleListAdapter: ArticleListAdapter
    private lateinit var articleListRecyclerView: RecyclerView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        sharedElementEnterTransition = TransitionInflater.from(requireContext())
            .inflateTransition(R.transition.shared_element)
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentArticleListBinding.inflate(inflater, container, false)

        val view = binding.root
        articleListAdapter = ArticleListAdapter(MOCK_ARTICLES) { article, textView, imageView ->
            val extras = FragmentNavigatorExtras(
                textView to article.titleId,
                imageView to article.imageId
            )
            val args = Bundle().apply {
                putSerializable("article", article)
            }
            view.findNavController().navigate(R.id.articleListToDetails, args, null, extras)
        }

        val layoutManager = LinearLayoutManager(requireContext())
        val spacingDecorator = DividerItemDecoration(requireContext(), DividerItemDecoration.VERTICAL)
        spacingDecorator.setDrawable(ContextCompat.getDrawable(requireContext(), R.drawable.article_list_spacing)!!)

        articleListRecyclerView = view.findViewById(R.id.recycler_view)
        articleListRecyclerView.adapter = articleListAdapter
        articleListRecyclerView.layoutManager = layoutManager
        articleListRecyclerView.addItemDecoration(spacingDecorator)

        return view
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        postponeEnterTransition()
        (view.parent as? ViewGroup)?.doOnPreDraw {
            startPostponedEnterTransition()
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}