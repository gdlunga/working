using Debug
using Dates
using DataFrames

@debug function cohort()

	input_file = "./data/rating_transitions.csv"

	ds    = readtable(input_file, separator=';')

	ids      = ds[1]
	rating   = int(ds[3])

	nclassi  = maximum(rating)- minimum(rating)
	Ni       = zeros(Float32, nclassi + 1)
	Nij      = zeros(Float32, nclassi, nclassi)
	pij      = zeros(Float32, nclassi-1, nclassi+1)

	trdates  = Dates.Date(ds[2],"yyyy-mm-dd")
	tryears  = [int(Year(d)) for d in trdates]

	ystart   = minimum(tryears)
	yend     = maximum(tryears)-1
	#@bp

	newrat    = 0
	not_rated = 0
	defaulted = maximum(rating)

	for k in 1:length(ids)
		#
		t = max(ystart, tryears[k])
		# Within this While loop we find the cohort to which observation k
		# belongs. To decide whether it belongs to a certain cohort, we check
		# whether the current rating informations is the latest in the current
		# year t. If there is a migration during the current period, we exit
		# the While loop and continue with the next observation. If not we
		# first check whether the issuer is in default or not rated. In these
		# two cases we exit the While loop because we do not compute transitions
		# for these two categories.
		while t < yend
			# Escludiamo dall'analisi tutte le transizioni che avvengono
			# all'interno dello stesso anno
			if(k != length(ids))
				if(ids[k+1] == ids[k] && tryears[k] <= t); break; end
			end
			# Escludiamo anche tutte le controparti gia' fallite o prive
			# di rating
			if(rating[k]==defaulted || rating[k]==not_rated); break; end
			# Add to number of issuers in cohort
			Ni[rating[k]+1]+=1
			# Determiniamo qual'e' il nuovo rating alla fine del prossimo
			# anno. Poiche' i dati sono ordinati per controparte e per anno
			# di transizione, questo implica che se la controparte allo
			# step k + 1 è diversa da quella allo step k, allora la
			# controparte k-esima ha mantenuto invariato il proprio rating.
			if(k != length(ids))
				if(ids[k+1] != ids[k] || tryears[k+1] > t+1)
					# rating invariato
					newrat = rating[k]
				else
					# il rating e' variato e quindi cerchiamo qual'e' il
					# nuovo rating prevalente alla fine del periodo in esame
					kn=k+1
					while tryears[kn+1] == tryears[kn] && ids[kn+1] == ids[kn]
						if(rating[kn] == defaulted); break; end
						kn += 1
					end
					newrat = rating[kn]
				end
            else
				newrat = rating[k]
			end
			# Add to number of transitions
			Nij[rating[k],newrat]+=1
			# exit if observation k cannot belong to cohort of y+1
			if(newrat != rating[k]); break; end
			t += 1
		end
		#print(k,'\t', ids[k],'\t', t, '\t', rating[k],"\n")
	end

	# compute transition frequencies
	for(i in 1:(nclassi-1))
		for(j in (1:nclassi))
		   if(Ni[i] > 0); pij[i, j]=Nij[i,j]/Ni[i]; end
		end
	end

	# NR category to the end
	for(i in 1:(nclassi-1))
		if(Ni[i] > 0); pij[i,nclassi+1]=Nij[i,1]/Ni[i]; end
	end

	print(Ni,"\n")
	print(Nij,"\n")
	print(pij,"\n")
end

cohort()
println("It worked!")
